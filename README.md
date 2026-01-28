# SnapForge

> Open-source multiroom audio ecosystem for home and professional use.

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

🌍 *English | [Italiano](README.it.md)*

## What is SnapForge?

SnapForge is a complete ecosystem for building synchronized multiroom audio systems. Stream music from your library, AirPlay devices, or any audio source to multiple rooms with perfect synchronization.

**Built on [Snapcast](https://github.com/badaix/snapcast)**, SnapForge provides production-ready components for server, clients, and control interfaces.

## The Ecosystem

| Component | Description | Repository |
|-----------|-------------|------------|
| **snapMULTI** | Server with MPD, AirPlay & TCP input | [snapMULTI](https://github.com/lollonet/snapMULTI) |
| **rpi-snapclient-usb** | Raspberry Pi client with 11 audio HATs support | [rpi-snapclient-usb](https://github.com/lollonet/rpi-snapclient-usb) |
| **SnapCTRL** | Cross-platform desktop controller (Qt6) | [snapctrl](https://github.com/lollonet/snapctrl) |

## Architecture

```
                    ┌─────────────────────────────────────────┐
                    │           AUDIO SOURCES                 │
                    │  MPD │ AirPlay │ TCP Stream │ Spotify   │
                    └──────────────────┬──────────────────────┘
                                       │
                                       ▼
                    ┌─────────────────────────────────────────┐
                    │         snapMULTI (Server)              │
                    │  Snapserver + MPD + Shairport-sync      │
                    │  Docker │ mDNS autodiscovery            │
                    └──────────────────┬──────────────────────┘
                                       │
              ┌────────────────────────┼────────────────────────┐
              │                        │                        │
              ▼                        ▼                        ▼
    ┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
    │ rpi-snapclient  │      │ rpi-snapclient  │      │ rpi-snapclient  │
    │ Living Room     │      │ Bedroom         │      │ Kitchen         │
    │ HiFiBerry DAC+  │      │ IQaudio DigiAMP │      │ USB DAC         │
    └─────────────────┘      └─────────────────┘      └─────────────────┘

                    ┌─────────────────────────────────────────┐
                    │            SnapCTRL                     │
                    │  Desktop app for volume, groups,        │
                    │  stream selection (Windows/Mac/Linux)   │
                    └─────────────────────────────────────────┘
```

## Features

### Server (snapMULTI)
- Three audio sources: MPD (local library), AirPlay, TCP input
- Docker-based deployment with host networking
- mDNS/Avahi autodiscovery
- FLAC streaming at 48kHz/16bit

### Clients (rpi-snapclient-usb)
- Support for 11 audio HATs (HiFiBerry, IQaudio, Allo, JustBoom, USB)
- Album art display service
- Automated setup scripts
- Docker or native installation

### Controller (SnapCTRL)
- Native Qt6 desktop application
- Real-time control via JSON-RPC
- Group and client volume control
- Stream source selection

## Quick Start

### 1. Deploy the Server

```bash
git clone https://github.com/lollonet/snapMULTI.git
cd snapMULTI
cp .env.example .env
# Edit .env with your music library paths
docker compose up -d
```

### 2. Set Up a Client (Raspberry Pi)

```bash
git clone https://github.com/lollonet/rpi-snapclient-usb.git
cd rpi-snapclient-usb
./scripts/setup.sh
# Follow prompts to select your audio HAT
```

### 3. Install the Controller

```bash
git clone https://github.com/lollonet/snapctrl.git
cd snapctrl
uv pip install -e .
python -m snapctrl
```

## Documentation

### English

| Document | Description |
|----------|-------------|
| [Architecture](docs/ARCHITECTURE.md) | System design and component interaction |
| [Deployment Guide](docs/DEPLOYMENT-GUIDE.md) | Step-by-step setup instructions |
| [Hardware BOM](docs/HARDWARE-BOM.md) | Recommended hardware and costs |

### Italiano

| Documento | Descrizione |
|-----------|-------------|
| [Architettura](docs/it/ARCHITECTURE.md) | Design del sistema e interazione componenti |
| [Guida al Deployment](docs/it/DEPLOYMENT-GUIDE.md) | Istruzioni di setup passo-passo |
| [BOM Hardware](docs/it/HARDWARE-BOM.md) | Hardware consigliato e costi |

## Use Cases

### Home Audio
Stream your music library to every room. Control everything from your phone (MPD apps) or desktop (SnapCTRL).

### Party Mode
One source, perfect sync across all speakers. No more echo from room to room.

### Background Music for Business
Restaurants, offices, retail spaces - synchronized audio with zone control.

### DIY Hi-Fi
Build audiophile-grade multiroom for a fraction of commercial solutions (Sonos, HEOS, BluOS).

## Comparison

| Feature | SnapForge | Sonos | Chromecast Audio | AirPlay 2 |
|---------|-----------|-------|------------------|-----------|
| Open Source | ✅ | ❌ | ❌ | ❌ |
| Self-hosted | ✅ | ❌ | ❌ | ❌ |
| Hardware agnostic | ✅ | ❌ | ❌ | ❌ |
| Sync accuracy | <1ms | ~30ms | ~30ms | ~50ms |
| Cost per room | ~€50 | ~€200+ | Discontinued | €100+ |
| Local network only | ✅ | ❌ (cloud) | ❌ (cloud) | ✅ |

## Roadmap

- [ ] Web-based controller (snapweb integration)
- [ ] Home Assistant integration
- [ ] Spotify Connect source
- [ ] Pre-built Raspberry Pi images
- [ ] Commercial support options

## Contributing

Each component has its own repository with contribution guidelines. Start with the component you want to improve:

- [snapMULTI issues](https://github.com/lollonet/snapMULTI/issues)
- [rpi-snapclient-usb issues](https://github.com/lollonet/rpi-snapclient-usb/issues)
- [snapctrl issues](https://github.com/lollonet/snapctrl/issues)

For ecosystem-wide discussions, open an issue in this repository.

## License

MIT License - see [LICENSE](LICENSE) for details.

All components of SnapForge are released under the MIT License.

---

**SnapForge** is part of the [Forge](https://github.com/lollonet) software ecosystem.
