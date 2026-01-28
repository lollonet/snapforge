# Architettura di SnapForge

Questo documento descrive l'architettura tecnica dell'ecosistema audio multiroom SnapForge.

## Panoramica del Sistema

SnapForge è composto da tre componenti principali che lavorano insieme per fornire audio multiroom sincronizzato:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              SORGENTI AUDIO                                  │
├─────────────────┬─────────────────┬─────────────────┬───────────────────────┤
│ Libreria Locale │ AirPlay         │ Stream TCP      │ (Futuro: Spotify)     │
│ (MPD)           │ (iOS/macOS)     │ (qualsiasi app) │                       │
└────────┬────────┴────────┬────────┴────────┬────────┴───────────────────────┘
         │                 │                 │
         ▼                 ▼                 ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         snapMULTI (Server)                                   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │     MPD     │  │ Shairport   │  │ Server TCP  │  │    Snapserver       │ │
│  │  Porta 6600 │  │   Sync      │  │  Porta 4953 │  │  Porte 1704/1780    │ │
│  │             │  │  (AirPlay)  │  │             │  │                     │ │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  │  - Gestione stream  │ │
│         │                │                │         │  - Registro client  │ │
│         ▼                ▼                ▼         │  - Controllo gruppi │ │
│  ┌─────────────────────────────────────────────┐   │  - API JSON-RPC     │ │
│  │              FIFO / Named Pipes              │───│                     │ │
│  │           /audio/snapcast_fifo               │   └─────────────────────┘ │
│  └─────────────────────────────────────────────┘                            │
│                                                                              │
│  Rete: modalità host │ mDNS via Avahi │ Container Docker                    │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │
                          Porta TCP 1704 (stream audio)
                          Porta TCP 1780 (API JSON-RPC)
                                       │
         ┌─────────────────────────────┼─────────────────────────────┐
         │                             │                             │
         ▼                             ▼                             ▼
┌─────────────────┐          ┌─────────────────┐          ┌─────────────────┐
│ rpi-snapclient  │          │ rpi-snapclient  │          │ rpi-snapclient  │
│                 │          │                 │          │                 │
│ ┌─────────────┐ │          │ ┌─────────────┐ │          │ ┌─────────────┐ │
│ │ Snapclient  │ │          │ │ Snapclient  │ │          │ │ Snapclient  │ │
│ │ daemon      │ │          │ │ daemon      │ │          │ │ daemon      │ │
│ └──────┬──────┘ │          │ └──────┬──────┘ │          │ └──────┬──────┘ │
│        │        │          │        │        │          │        │        │
│ ┌──────▼──────┐ │          │ ┌──────▼──────┐ │          │ ┌──────▼──────┐ │
│ │  Audio HAT  │ │          │ │  Audio HAT  │ │          │ │  Audio HAT  │ │
│ │ HiFiBerry   │ │          │ │  IQaudio    │ │          │ │   DAC USB   │ │
│ └─────────────┘ │          │ └─────────────┘ │          │ └─────────────┘ │
└─────────────────┘          └─────────────────┘          └─────────────────┘

                    ┌─────────────────────────────────────┐
                    │            SnapCTRL                 │
                    │  ┌───────────────────────────────┐  │
                    │  │      GUI PySide6/Qt6          │  │
                    │  │                               │  │
                    │  │  ┌─────────┐  ┌───────────┐   │  │
                    │  │  │ Pannello│  │  Pannello │   │  │
                    │  │  │ Gruppi  │  │   Client  │   │  │
                    │  │  └────┬────┘  └─────┬─────┘   │  │
                    │  │       └──────┬──────┘         │  │
                    │  │              ▼                │  │
                    │  │     ┌───────────────┐         │  │
                    │  │     │  State Store  │         │  │
                    │  │     └───────┬───────┘         │  │
                    │  │             ▼                 │  │
                    │  │     ┌───────────────┐         │  │
                    │  │     │  Client TCP   │─────────┼──┼──► Porta 1780
                    │  │     │  JSON-RPC     │         │  │
                    │  │     └───────────────┘         │  │
                    │  └───────────────────────────────┘  │
                    │  Windows / macOS / Linux            │
                    └─────────────────────────────────────┘
```

## Dettagli dei Componenti

### snapMULTI (Server)

Il componente server gira come container Docker con networking host per il supporto mDNS.

#### Servizi

| Servizio | Porta | Protocollo | Scopo |
|----------|-------|------------|-------|
| Snapserver | 1704 | TCP | Streaming audio ai client |
| Snapserver | 1780 | HTTP | API di controllo JSON-RPC |
| MPD | 6600 | TCP | Controllo Music Player Daemon |
| Input TCP | 4953 | TCP | Input stream audio esterni |
| mDNS | 5353 | UDP | Discovery servizi (via Avahi host) |

#### Pipeline Audio

```
Sorgente Audio → Decoder → PCM 48kHz/16bit/Stereo → FIFO → Snapserver → FLAC → Rete
```

#### Architettura Docker

```yaml
services:
  snapMULTI:      # Snapserver + Shairport-sync
    network_mode: host
    volumes:
      - /run/dbus/system_bus_socket  # Per mDNS Avahi
      - ./audio:/audio               # Pipe FIFO

  mpd:           # Music Player Daemon
    network_mode: host
    volumes:
      - ./audio:/audio               # Output FIFO
      - /percorso/musica:/music:ro   # Libreria musicale
```

### rpi-snapclient-usb (Client)

Endpoint audio basato su Raspberry Pi con supporto per vari HAT audio.

#### HAT Audio Supportati

| Produttore | Modelli | Interfaccia |
|------------|---------|-------------|
| HiFiBerry | DAC+, DAC2, Digi+, Amp2 | I2S |
| IQaudio | DAC+, DigiAMP+ | I2S |
| Allo | Boss, Piano, DigiOne | I2S |
| JustBoom | DAC, Digi, Amp | I2S |
| Generico | DAC USB | USB Audio |

#### Architettura Client

```
┌────────────────────────────────────────────┐
│            rpi-snapclient-usb              │
│                                            │
│  ┌──────────────┐    ┌──────────────────┐  │
│  │  Snapclient  │    │ Servizio         │  │
│  │   daemon     │    │ Metadata         │  │
│  └──────┬───────┘    │ (copertine album)│  │
│         │            └────────┬─────────┘  │
│         ▼                     ▼            │
│  ┌──────────────┐    ┌──────────────────┐  │
│  │    ALSA      │    │   LCD/Display    │  │
│  │   Driver     │    │   (opzionale)    │  │
│  └──────┬───────┘    └──────────────────┘  │
│         │                                  │
│         ▼                                  │
│  ┌──────────────┐                          │
│  │  Audio HAT   │                          │
│  │  (I2S/USB)   │                          │
│  └──────────────┘                          │
└────────────────────────────────────────────┘
```

### SnapCTRL (Controller)

Applicazione desktop per controllare il sistema Snapcast.

#### Architettura Applicazione

```
┌─────────────────────────────────────────────────────────────┐
│                        SnapCTRL                             │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                 Livello UI (Qt6)                     │   │
│  │  ┌───────────────┐  ┌───────────────┐  ┌─────────┐  │   │
│  │  │ PannelloGruppi│  │ PannelloClient│  │ Toolbar │  │   │
│  │  │ - Volume      │  │ - Volume      │  │ - Conn  │  │   │
│  │  │ - Mute        │  │ - Mute        │  │ - Tema  │  │   │
│  │  │ - Stream      │  │ - Latenza     │  │         │  │   │
│  │  └───────────────┘  └───────────────┘  └─────────┘  │   │
│  └─────────────────────────────────────────────────────┘   │
│                            │                                │
│                            ▼                                │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Gestione dello Stato                    │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │   │
│  │  │ ServerState │  │ GroupState  │  │ ClientState │  │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  │   │
│  └─────────────────────────────────────────────────────┘   │
│                            │                                │
│                            ▼                                │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                  Livello Rete                        │   │
│  │  ┌─────────────────────────────────────────────┐    │   │
│  │  │              SnapcastClient                  │    │   │
│  │  │  - Connessione TCP                          │    │   │
│  │  │  - Protocollo JSON-RPC                      │    │   │
│  │  │  - Gestione eventi                          │    │   │
│  │  └─────────────────────────────────────────────┘    │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## Protocolli di Comunicazione

### Protocollo Snapcast (Porta 1704)

Protocollo binario per streaming audio:
- Codec: FLAC (lossless) o PCM
- Formato campione: 48000:16:2 (48kHz, 16-bit, stereo)
- Buffer: 1000ms di default
- Sincronizzazione: algoritmo tipo NTP per precisione <1ms

### API JSON-RPC (Porta 1780)

Protocollo di controllo per la gestione:

```json
// Ottieni stato server
{"id":1,"jsonrpc":"2.0","method":"Server.GetStatus"}

// Imposta volume gruppo
{"id":2,"jsonrpc":"2.0","method":"Group.SetVolume","params":{"id":"group_id","volume":{"percent":50}}}

// Imposta mute client
{"id":3,"jsonrpc":"2.0","method":"Client.SetVolume","params":{"id":"client_id","volume":{"muted":true}}}
```

### Discovery mDNS

Servizi pubblicati:
- `_snapcast._tcp` - Server Snapcast
- `_snapcast-http._tcp` - API JSON-RPC
- `_raop._tcp` - Ricevitore AirPlay (se abilitato)

## Requisiti di Rete

### Porte

| Porta | Direzione | Protocollo | Scopo |
|-------|-----------|------------|-------|
| 1704 | Server → Client | TCP | Stream audio |
| 1780 | Controller → Server | TCP | API JSON-RPC |
| 6600 | App → Server | TCP | Controllo MPD |
| 4953 | Sorgente → Server | TCP | Input audio TCP |
| 5353 | Multicast | UDP | Discovery mDNS |

### Banda

| Qualità | Per Client | 10 Client |
|---------|------------|-----------|
| FLAC 48/16 | ~1.5 Mbps | ~15 Mbps |
| PCM 48/16 | ~1.5 Mbps | ~15 Mbps |

### Latenza

| Segmento | Tipica | Note |
|----------|--------|------|
| Elaborazione server | <1ms | Il buffering aggiunge latenza |
| Rete (WiFi) | 2-10ms | Dipende dalla qualità della rete |
| Buffer client | Configurabile | Default 1000ms |
| Output DAC | <1ms | Dipende dall'hardware |

## Considerazioni sulla Sicurezza

### Stato Attuale

- Tutte le comunicazioni sono **non crittografate**
- Nessuna autenticazione sull'API JSON-RPC
- Progettato **solo per reti locali fidate**

### Raccomandazioni

1. Isolare su VLAN dedicata se possibile
2. Usare regole firewall per limitare l'accesso
3. Non esporre su internet
4. Considerare VPN per accesso remoto

## Scalabilità

### Configurazioni Testate

| Client | Hardware Server | Note |
|--------|-----------------|------|
| 1-5 | Raspberry Pi 4 | Funziona bene |
| 5-10 | Mini PC x86 | Raccomandato |
| 10-20 | Server standard | Uso enterprise |
| 20+ | Non testato | Potrebbe servire ottimizzazione |

### Colli di Bottiglia

1. **Banda di rete** - Limitazione principale per molti client
2. **CPU server** - Encoding di stream multipli
3. **Congestione WiFi** - Preferire client cablati per stabilità
