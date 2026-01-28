# SnapForge

> Ecosistema audio multiroom open-source per uso domestico e professionale.

[![Licenza](https://img.shields.io/badge/licenza-MIT-blue.svg)](LICENSE)

🌍 *[English](README.md) | Italiano*

## Cos'è SnapForge?

SnapForge è un ecosistema completo per costruire sistemi audio multiroom sincronizzati. Streaming della musica dalla tua libreria, dispositivi AirPlay o qualsiasi sorgente audio verso più stanze con sincronizzazione perfetta.

**Basato su [Snapcast](https://github.com/badaix/snapcast)**, SnapForge fornisce componenti pronti per la produzione per server, client e interfacce di controllo.

## L'Ecosistema

| Componente | Descrizione | Repository |
|------------|-------------|------------|
| **snapMULTI** | Server con MPD, AirPlay e input TCP | [snapMULTI](https://github.com/lollonet/snapMULTI) |
| **rpi-snapclient-usb** | Client Raspberry Pi con supporto 11 HAT audio | [rpi-snapclient-usb](https://github.com/lollonet/rpi-snapclient-usb) |
| **SnapCTRL** | Controller desktop cross-platform (Qt6) | [snapctrl](https://github.com/lollonet/snapctrl) |

## Architettura

```
                    ┌─────────────────────────────────────────┐
                    │          SORGENTI AUDIO                 │
                    │  MPD │ AirPlay │ Stream TCP │ Spotify   │
                    └──────────────────┬──────────────────────┘
                                       │
                                       ▼
                    ┌─────────────────────────────────────────┐
                    │         snapMULTI (Server)              │
                    │  Snapserver + MPD + Shairport-sync      │
                    │  Docker │ autodiscovery mDNS            │
                    └──────────────────┬──────────────────────┘
                                       │
              ┌────────────────────────┼────────────────────────┐
              │                        │                        │
              ▼                        ▼                        ▼
    ┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
    │ rpi-snapclient  │      │ rpi-snapclient  │      │ rpi-snapclient  │
    │ Soggiorno       │      │ Camera          │      │ Cucina          │
    │ HiFiBerry DAC+  │      │ IQaudio DigiAMP │      │ DAC USB         │
    └─────────────────┘      └─────────────────┘      └─────────────────┘

                    ┌─────────────────────────────────────────┐
                    │            SnapCTRL                     │
                    │  App desktop per volume, gruppi,        │
                    │  selezione stream (Windows/Mac/Linux)   │
                    └─────────────────────────────────────────┘
```

## Funzionalità

### Server (snapMULTI)
- Tre sorgenti audio: MPD (libreria locale), AirPlay, input TCP
- Deployment basato su Docker con networking host
- Autodiscovery mDNS/Avahi
- Streaming FLAC a 48kHz/16bit

### Client (rpi-snapclient-usb)
- Supporto per 11 HAT audio (HiFiBerry, IQaudio, Allo, JustBoom, USB)
- Servizio visualizzazione copertine album
- Script di setup automatizzato
- Installazione Docker o nativa

### Controller (SnapCTRL)
- Applicazione desktop Qt6 nativa
- Controllo in tempo reale via JSON-RPC
- Controllo volume gruppi e client
- Selezione sorgente stream

## Quick Start

### 1. Deploy del Server

```bash
git clone https://github.com/lollonet/snapMULTI.git
cd snapMULTI
cp .env.example .env
# Modifica .env con i percorsi della tua libreria musicale
docker compose up -d
```

### 2. Setup di un Client (Raspberry Pi)

```bash
git clone https://github.com/lollonet/rpi-snapclient-usb.git
cd rpi-snapclient-usb
./scripts/setup.sh
# Segui i prompt per selezionare il tuo HAT audio
```

### 3. Installa il Controller

```bash
git clone https://github.com/lollonet/snapctrl.git
cd snapctrl
uv pip install -e .
python -m snapctrl
```

## Documentazione

| Documento | Descrizione |
|-----------|-------------|
| [Architettura](docs/it/ARCHITECTURE.md) | Design del sistema e interazione componenti |
| [Guida al Deployment](docs/it/DEPLOYMENT-GUIDE.md) | Istruzioni di setup passo-passo |
| [BOM Hardware](docs/it/HARDWARE-BOM.md) | Hardware consigliato e costi |

## Casi d'Uso

### Audio Domestico
Streaming della tua libreria musicale in ogni stanza. Controlla tutto dal telefono (app MPD) o desktop (SnapCTRL).

### Modalità Festa
Una sorgente, sync perfetto su tutti i diffusori. Niente più eco da una stanza all'altra.

### Musica di Sottofondo per Business
Ristoranti, uffici, negozi - audio sincronizzato con controllo per zone.

### Hi-Fi DIY
Costruisci un multiroom di grado audiofilo a una frazione delle soluzioni commerciali (Sonos, HEOS, BluOS).

## Confronto

| Funzionalità | SnapForge | Sonos | Chromecast Audio | AirPlay 2 |
|--------------|-----------|-------|------------------|-----------|
| Open Source | ✅ | ❌ | ❌ | ❌ |
| Self-hosted | ✅ | ❌ | ❌ | ❌ |
| Hardware agnostico | ✅ | ❌ | ❌ | ❌ |
| Precisione sync | <1ms | ~30ms | ~30ms | ~50ms |
| Costo per stanza | ~€50 | ~€200+ | Discontinuato | €100+ |
| Solo rete locale | ✅ | ❌ (cloud) | ❌ (cloud) | ✅ |

## Roadmap

- [ ] Controller web-based (integrazione snapweb)
- [ ] Integrazione Home Assistant
- [ ] Sorgente Spotify Connect
- [ ] Immagini Raspberry Pi pre-configurate
- [ ] Opzioni di supporto commerciale

## Contribuire

Ogni componente ha il proprio repository con linee guida per i contributi. Inizia con il componente che vuoi migliorare:

- [Issue snapMULTI](https://github.com/lollonet/snapMULTI/issues)
- [Issue rpi-snapclient-usb](https://github.com/lollonet/rpi-snapclient-usb/issues)
- [Issue snapctrl](https://github.com/lollonet/snapctrl/issues)

Per discussioni sull'intero ecosistema, apri una issue in questo repository.

## Licenza

Licenza MIT - vedi [LICENSE](LICENSE) per i dettagli.

Tutti i componenti di SnapForge sono rilasciati sotto Licenza MIT.

---

**SnapForge** fa parte dell'ecosistema software [Forge](https://github.com/lollonet).
