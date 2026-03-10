<p align="center">
  <img src="../../branding/logo.svg" alt="SnapForge" width="80">
</p>

# Architettura di SnapForge

Questo documento descrive l'architettura tecnica dell'ecosistema audio multiroom SnapForge.

## Panoramica del Sistema

SnapForge è composto da una piattaforma open e app native che lavorano insieme per fornire audio multiroom sincronizzato:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              SORGENTI AUDIO                                  │
├─────────────────┬─────────────────┬─────────────────┬───────────────────────┤
│ Libreria Locale │ AirPlay         │ Stream TCP      │ Spotify (librespot)   │
│ (MPD)           │ (iOS/macOS)     │ (qualsiasi app) │ Tidal (ARM)           │
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

              ┌───────────────────────────────────────────────────────┐
              │       App Native SnapForge (disponibili presto)       │
              │  ┌──────────────────────┐  ┌───────────────────────┐  │
              │  │   SnapClient iOS     │  │  SnapClient Android   │  │
              │  │  Swift · AVAudioEngine│  │  Kotlin · Oboe       │  │
              │  │  FLAC / Opus / PCM   │  │  FLAC / Opus / PCM   │  │
              │  │  Porta 1704 (audio)  │  │  Porta 1704 (audio)  │  │
              │  │  Porta 1705 (ctrl)   │  │  Porta 1705 (ctrl)   │  │
              │  └──────────────────────┘  └───────────────────────┘  │
              └───────────────────────────────────────────────────────┘

                    ┌─────────────────────────────────────┐
                    │    SnapCTRL (disponibile presto)    │
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
                    │  │     │  Client TCP   │─────────┼──┼──► Porta 1705
                    │  │     │  JSON-RPC     │         │  │
                    │  │     └───────────────┘         │  │
                    │  └───────────────────────────────┘  │
                    │  macOS/Windows (a pagamento) · Linux (gratuito)  │
                    └─────────────────────────────────────┘
```

## Confronto Componenti

Matrice hardware, piattaforma e funzionalita' per tutti i componenti SnapForge.

### Piattaforma e Installazione

| | **snapMULTI** | **rpi-snapclient** | **SnapCTRL** | **santcasp** | **SnapClient iOS** | **SnapClient Android** |
|---|---|---|---|---|---|---|
| **Ruolo** | Hub audio + sorgenti | Altoparlante per stanza | GUI controllo desktop | Binari core Snapcast | Client audio iOS | Client audio Android |
| **Piattaforma** | Qualsiasi Linux (x86_64, ARM64) | Raspberry Pi (ARM64) | macOS, Linux, Windows | Linux, macOS, Windows | iOS 17+ (iPhone/iPad) | Android (API 26+) |
| **Installazione** | Docker Compose | Docker + script setup | pip/uv (Linux) · App Store/Microsoft Store | .deb / .tar.gz / .zip | App Store (presto) | Play Store (presto) |
| **Funziona headless** | Si | Si | No | Si | No | No |
| **Funziona in Docker** | Si | Si | No | No | No | No |

### Requisiti Hardware

| | **snapMULTI** | **rpi-snapclient** | **SnapCTRL** | **santcasp** | **SnapClient iOS** | **SnapClient Android** |
|---|---|---|---|---|---|---|
| **CPU minima** | 2 core | 1 core | Qualsiasi moderno | Qualsiasi | Apple A12+ | ARMv7 / ARM64 |
| **RAM minima** | 1 GB | 512 MB | 256 MB | 64 MB | — (gestita dall'OS) | — (gestita dall'OS) |
| **RAM consigliata** | 2 GB | 1 GB | — | — | — | — |
| **Storage minimo** | 1 GB + libreria musicale | 8 GB scheda SD | 200 MB | 50 MB | ~50 MB | ~50 MB |
| **Hardware tipico** | RPi 4 4GB, NUC, NAS, vecchio laptop | RPi 3B/4/5 + scheda audio | Qualsiasi laptop/desktop | Integrato negli altri componenti | iPhone / iPad (iOS 17+) | Telefono/tablet Android (API 26+) |
| **Prezzo per unita'** | €50–150 (RPi) / €0 (riuso PC) | €35–80 (RPi + HAT + case + alimentatore) | Gratuito (Linux) · a pagamento (macOS/Windows) | Gratuito | A pagamento (App Store) | A pagamento (Play Store) |

### Capacita' Audio

| | **snapMULTI** | **rpi-snapclient** | **SnapCTRL** | **santcasp** | **SnapClient iOS** | **SnapClient Android** |
|---|---|---|---|---|---|---|
| **Uscita audio** | Nessuna (distribuisce ai client) | HAT I2S, DAC USB, HDMI, jack 3.5mm | Nessuna (solo controllo) | ALSA, PulseAudio, PipeWire | Altoparlante, cuffie, AirPlay | Altoparlante, cuffie, BT |
| **Codec** | Stream FLAC (48kHz/16bit) | Dipende dal HAT (fino a 192kHz/24bit) | — | Dipende dal codec | FLAC, Opus, PCM | FLAC, Opus, PCM |
| **Sorgenti audio** | MPD, AirPlay, Spotify, Tidal, TCP | Riceve solo lo stream | — | Qualsiasi PCM / pipe / TCP | Riceve solo lo stream | Riceve solo lo stream |
| **Sync** | Distribuisce stream time-synced | <1ms (protocollo Snapcast) | — | <1ms | <1ms (NTP-style) | <1ms (NTP-style, soft sync) |
| **Display** | Headless | Opzionale: copertine album, analizzatore spettro | GUI desktop (volume, gruppi, copertine) | — | Lock screen, Control Center | In riproduzione, copertine |

### Rete

| | **snapMULTI** | **rpi-snapclient** | **SnapCTRL** | **santcasp** | **SnapClient iOS** | **SnapClient Android** |
|---|---|---|---|---|---|---|
| **Rete** | Gigabit consigliata, modalita' host | WiFi o Ethernet | Qualsiasi | Qualsiasi | WiFi / cellulare+VPN | WiFi / cellulare+VPN |
| **Porte (ascolto)** | 1704, 1705, 1780, 6600, 4953, 5353 | 5353 (mDNS) | Nessuna (solo uscita) | 1704, 1705, 1780 | Nessuna (solo uscita) | Nessuna (solo uscita) |
| **Discovery** | Pubblica `_snapcast._tcp` | Scopre il server via mDNS | Scopre il server via mDNS | mDNS opzionale | mDNS (NWBrowser / Bonjour) | mDNS (NsdManager) |
| **Banda** | ~1.5 Mbps per client (FLAC) | ~1.5 Mbps in ingresso | Trascurabile | ~1.5 Mbps per client | ~1.5 Mbps in ingresso | ~1.5 Mbps in ingresso |

### Dipendenze

| | **snapMULTI** | **rpi-snapclient** | **SnapCTRL** | **santcasp** | **SnapClient iOS** | **SnapClient Android** |
|---|---|---|---|---|---|---|
| **Runtime** | Docker, Avahi | Docker, ALSA | Python 3.11+, PySide6, Qt6 | — | iOS 17+, AVAudioEngine | Android API 26+, Oboe |
| **Build** | — (immagini pre-costruite) | — (immagini pre-costruite) | pip / uv | CMake, compilatore C++17 | Xcode 17+, autotools | Android Studio, NDK, CMake |
| **CI/CD** | GitHub Actions (runner self-hosted ARM64) | GitHub Actions (runner self-hosted ARM64) | GitHub Actions | Build manuali | GitHub Actions | GitHub Actions (self-hosted) |

> **Nota**: santcasp fornisce i binari core `snapserver` e `snapclient` che snapMULTI e rpi-snapclient includono nelle loro immagini Docker. SnapCTRL, SnapClient iOS e SnapClient Android sono tutti client di controllo/ascolto — nessuno di loro serve audio.

## Topologie di Deployment

Quali componenti girano su quale hardware e come combinarli.

### Matrice di Supporto Piattaforme

#### Componenti vs Hardware

| | **PC** | **NUC** | **ARM 7v (Pi Zero)** | **ARM 64v (Pi 3/4/5)** | **iPhone/iPad** | **Android** |
|---|:---:|:---:|:---:|:---:|:---:|:---:|
| **Server** | X | X | — | X | — | — |
| **rpi-snapclient** | X | X | X | X | — | — |
| **SnapClient iOS** | — | — | — | — | X | — |
| **SnapClient Android** | — | — | — | — | — | X |
| **CTRL** | X | — | — | — | — | — |
| **Sorgente MPD** | X | X | N/A | X | — | — |

- **CTRL** richiede una GUI desktop (PySide6/Qt6) — disponibile solo su PC (laptop/desktop).
- **Pi Zero** (ARM 7v): solo rpi-snapclient. CPU/RAM insufficienti per server o MPD.
- **MPD** non applicabile su Pi Zero — troppo debole per indicizzazione e decodifica musicale.
- **SnapClient iOS/Android** — disponibili presto; si connettono a qualsiasi server Snapcast come endpoint audio personale.

#### Hardware vs Pacchetti Installabili

| | **SRV** | **CLIENT** | **CTRL** | **MPD** |
|---|:---:|:---:|:---:|:---:|
| **PC** | X | X | X | X |
| **NUC** | X | X | — | X |
| **Pi Zero** | — | X | — | X |
| **Pi 3/4/5** | X | X | — | X |

### Profili Hardware

| Hardware | Descrizione | Ruolo ideale |
|----------|-------------|--------------|
| **PC** (laptop/desktop) | Completo. Puo' far girare tutto incluso CTRL. | All-in-one, test, o stazione di controllo |
| **NUC** (mini-PC Intel) | Mini-PC headless. Potente, fanless, sempre acceso. | Server dedicato (SRV + MPD) |
| **Pi Zero / ARM 7v** | Single-core, 512 MB RAM, <1 W a riposo. | Endpoint piu' economico (solo client) |
| **Pi 3/4/5 / ARM 64v** | Quad-core, 1–8 GB RAM. Il Pi 4 da 4 GB e' il punto ottimale. | Versatile: server o client |

### Scenari di Deployment

#### 1. All-in-one su PC (sviluppo/test)

Tutto su una macchina. Ideale per provare SnapForge senza hardware Pi.

```
┌──────────────────────────────────────────┐
│              PC / Laptop                 │
│                                          │
│  snapMULTI (SRV + MPD)                  │
│  snapclient (altoparlante locale)       │
│  SnapCTRL (GUI)                         │
└──────────────────────────────────────────┘
```

#### 2. Pi 4 server dedicato + Pi client (il piu' comune)

Il setup casalingo consigliato. Un Pi 4 come server, un Pi per stanza.

```
┌───────────────────┐     ┌─────────────────┐
│   Pi 4 (server)   │────▶│ Pi 3B (camera)  │
│   SRV + MPD       │     │ CLIENT          │
└───────────────────┘     └─────────────────┘
         │
         ├────────────────▶┌─────────────────┐
         │                 │ Pi 4 (cucina)   │
         │                 │ CLIENT          │
         │                 └─────────────────┘
         │
         └────────────────▶┌─────────────────┐
                           │ Pi Zero (bagno) │
                           │ CLIENT          │
                           └─────────────────┘
```

#### 3. NUC server + Pi client + PC controller (power user)

NUC sempre acceso come server dedicato, Pi per ogni stanza, desktop come controller.

```
┌───────────────────┐     ┌─────────────────┐
│   NUC (server)    │────▶│ Pi client       │
│   SRV + MPD       │     │ (uno per stanza)│
└───────────────────┘     └─────────────────┘
         ▲
         │ JSON-RPC
┌───────────────────┐
│   PC (laptop)     │
│   SnapCTRL        │
└───────────────────┘
```

#### 4. Pi 4 server + Pi Zero client (multiroom economico)

Costo minimo per stanza (~€15 per Pi Zero W + DAC USB).

```
┌───────────────────┐     ┌───────────────────┐
│   Pi 4 (server)   │────▶│ Pi Zero W (sala1) │
│   SRV + MPD       │     │ CLIENT + DAC USB  │
└───────────────────┘     └───────────────────┘
         │
         └────────────────▶┌───────────────────┐
                           │ Pi Zero W (sala2) │
                           │ CLIENT + DAC USB  │
                           └───────────────────┘
```

#### 5. PC server + client desktop (senza Pi)

Usa il tuo PC come server e punto di ascolto. Nessun Raspberry Pi necessario.

```
┌──────────────────────────────────────────┐
│              PC / Laptop                 │
│                                          │
│  snapMULTI (SRV + MPD)                  │
│  snapclient (casse/cuffie)              │
│  SnapCTRL (GUI)                         │
└──────────────────────────────────────────┘
```

### Co-locazione: Server + MPD

Il server (snapserver) e MPD possono girare sulla **stessa macchina** o su **macchine diverse**. Questa scelta influenza latenza e architettura.

| Topologia | Collegamento audio | Latenza | Complessita' | Storage | Ideale per |
|-----------|-------------------|---------|--------------|---------|------------|
| **Stesso host** | Pipe FIFO (`/audio/snapcast_fifo`) | ~0 ms | Semplice | Disco locale o mount NFS | La maggior parte dei setup |
| **Host separati** | Stream TCP/HTTP | +5–20 ms | Maggiore | NAS / storage remoto | Grandi librerie musicali su NAS |

**Perche' e' importante:** MPD scrive l'audio PCM decodificato su una pipe FIFO. Snapserver legge dalla stessa pipe. Questo richiede che entrambi i processi condividano lo stesso filesystem — cioe' la stessa macchina (o almeno lo stesso volume Docker).

Se hai bisogno di MPD su una macchina diversa (es. un NAS con molto spazio), devi passare dalla pipe FIFO a un output TCP o HTTP in MPD, e configurare snapserver per leggere da una sorgente TCP. Questo aggiunge latenza di rete e complessita' di configurazione.

**Default (consigliato):** Tieni server + MPD co-locati. Questa e' la configurazione di snapMULTI pronta all'uso.

### Cosa Puo' Condividere una Macchina

| Combinazione | Funziona? | Note |
|-------------|:---------:|------|
| Server + MPD | **Si** (consigliato) | Collegati via pipe FIFO. Devono essere co-locati per audio a latenza zero. |
| Server + Client | **Si** | La macchina server diventa anche altoparlante. Nessun conflitto di porte. |
| Client + CTRL | **Si** (solo PC) | Nessun conflitto di porte. Entrambi fanno connessioni in uscita. |
| Server + Client + MPD | **Si** | Setup all-in-one. Funziona su Pi 4 o PC. |
| Server + CTRL | **Si** (solo PC) | Controlla il sistema dalla macchina server stessa. |

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
| 1705 | Controller/App → Server | TCP | API di controllo JSON-RPC (SnapCTRL, iOS, Android) |
| 1780 | Browser → Server | HTTP | Web UI + JSON-RPC via HTTP |
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
