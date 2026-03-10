<p align="center">
  <img src="branding/hero.svg" alt="SnapForge — Self-hosted multiroom audio" width="100%">
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License"></a>
  <a href="https://github.com/users/lollonet/projects/3"><img src="https://img.shields.io/badge/project-board-orange.svg" alt="Project Board"></a>
  <a href="docs/QUICKSTART.md"><img src="https://img.shields.io/badge/start-in%205%20min-brightgreen.svg" alt="Quickstart"></a>
</p>

<p align="center">
  <em>English | <a href="README.it.md">Italiano</a></em>
</p>

---

> **Self-hosted multiroom audio.** Stream music to every room in perfect sync — from your library, AirPlay, Spotify, or any source. Runs on hardware you already own.

## The Ecosystem

### Open Platform — free & self-hosted

| Component | What it does | Repository |
|-----------|-------------|------------|
| **snapMULTI** | Server — Spotify, AirPlay, Tidal, MPD & TCP sources in Docker | [snapMULTI](https://github.com/lollonet/snapMULTI) |
| **rpi-snapclient-usb** | Room speaker — Raspberry Pi audio endpoint with 11 DAC HAT options | [rpi-snapclient-usb](https://github.com/lollonet/rpi-snapclient-usb) |
| **santcasp** | Engine — prebuilt Snapcast binaries for Linux, macOS & Windows | [santcasp](https://github.com/lollonet/santcasp) |

### Native Apps — coming soon

| App | What it does | Availability |
|-----|-------------|--------------|
| **SnapClient iOS** | iPhone & iPad — synchronized playback, server control, now playing | App Store — coming soon |
| **SnapClient Android** | Android — synchronized playback, server control, Material 3 UI | Play Store — coming soon |
| **SnapCTRL** | Desktop controller — volume, groups, album art · free on Linux, paid on macOS/Windows | Mac App Store & Microsoft Store — coming soon |

## Architecture

```
                    ┌─────────────────────────────────────────┐
                    │           AUDIO SOURCES                 │
                    │  MPD │ AirPlay │ Spotify │ Tidal │ TCP  │
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

              ┌─────────────────────────────────────────────────┐
              │              SnapForge Apps (coming soon)       │
              │  ┌───────────────────┐  ┌──────────────────┐   │
              │  │  SnapClient iOS   │  │SnapClient Android│   │
              │  │  iPhone · iPad    │  │  Android device  │   │
              │  └───────────────────┘  └──────────────────┘   │
              └─────────────────────────────────────────────────┘

                    ┌─────────────────────────────────────────┐
                    │            SnapCTRL (coming soon)       │
                    │  Desktop controller — groups, volume    │
                    │  free on Linux · paid on macOS/Windows  │
                    └─────────────────────────────────────────┘
```

## Features

### Open Platform

- **[snapMULTI](https://github.com/lollonet/snapMULTI)** — audio server with Spotify (librespot), AirPlay (shairport-sync), Tidal, MPD and TCP sources; Docker-based; mDNS autodiscovery
- **[rpi-snapclient-usb](https://github.com/lollonet/rpi-snapclient-usb)** — Raspberry Pi audio endpoint; 11 audio HAT profiles, album art display, spectrum analyzer, zero-touch install
- **[santcasp](https://github.com/lollonet/santcasp)** — prebuilt snapclient/snapserver packages for Ubuntu, Debian, macOS and Windows

### Native Apps (coming soon)

- **SnapClient iOS** — synchronized audio playback for iPhone and iPad; full server control from your pocket
- **SnapClient Android** — synchronized audio playback for Android; Material 3 UI with album art and group control
- **SnapCTRL** — desktop controller for macOS, Windows and Linux; groups, volume, album art, now playing; **free on Linux**

## Quick Start

**[Full 5-minute quickstart guide](docs/QUICKSTART.md)** — from zero to music in every room.

```bash
# 1. Server (any Linux machine)
git clone https://github.com/lollonet/snapMULTI.git && cd snapMULTI
cp .env.example .env          # edit paths to your music
docker compose up -d           # server is live

# 2. Client (each Raspberry Pi)
git clone https://github.com/lollonet/rpi-snapclient-usb.git && cd rpi-snapclient-usb
./scripts/setup.sh             # pick your DAC, set room name, done

# 3. Control — open the built-in web UI
open http://<server-ip>:1780   # volume, groups, stream selection in any browser
```

Clients find the server automatically via mDNS. No IP addresses to configure.

> **SnapCTRL** (native desktop app) and **SnapClient iOS/Android** (mobile) are coming soon — see [Native Apps](#native-apps--coming-soon) above.

## Documentation

### English

| Document | Description |
|----------|-------------|
| **[5-Minute Quickstart](docs/QUICKSTART.md)** | **Get running fast — start here** |
| [Architecture](docs/ARCHITECTURE.md) | System design and component interaction |
| [Deployment Guide](docs/DEPLOYMENT-GUIDE.md) | Full setup with verification and troubleshooting |
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
Build audiophile-grade multiroom for a fraction of the cost of commercial solutions.

## Comparison

| Feature | SnapForge | Chromecast Audio | AirPlay 2 | Commercial systems |
|---------|-----------|------------------|-----------|--------------------|
| Open Source | ✅ | ❌ | ❌ | ❌ |
| Self-hosted | ✅ | ❌ | ❌ | ❌ |
| Hardware agnostic | ✅ | ❌ | ❌ | ❌ |
| Sync accuracy | <1ms | ~30ms | ~50ms | ~30ms |
| Cost per room | ~€50 | Discontinued | €100+ | €200+ |
| Local network only | ✅ | ❌ (cloud) | ✅ | ❌ (cloud) |

## Roadmap

- [ ] SnapClient iOS — App Store release
- [ ] SnapClient Android — Play Store release
- [ ] SnapCTRL — Mac App Store & Microsoft Store release
- [ ] Web-based controller (snapweb integration)
- [ ] Home Assistant integration
- [ ] Pre-built Raspberry Pi images

## Contributing

The open platform components welcome contributions — each has its own repository and guidelines:

- [snapMULTI issues](https://github.com/lollonet/snapMULTI/issues) — server and audio sources
- [rpi-snapclient-usb issues](https://github.com/lollonet/rpi-snapclient-usb/issues) — Raspberry Pi clients
- [santcasp issues](https://github.com/lollonet/santcasp/issues) — Snapcast engine binaries

The native apps (SnapClient iOS, SnapClient Android, SnapCTRL) are proprietary and not open for external contributions at this time.

For ecosystem-wide discussions, open an issue in this repository or visit the [project board](https://github.com/users/lollonet/projects/3).

## License

The open platform components (snapMULTI, rpi-snapclient-usb, santcasp) are released under the MIT License — see [LICENSE](LICENSE) for details.

The native apps (SnapClient iOS, SnapClient Android, SnapCTRL) are proprietary software with separate commercial licenses.

---

**SnapForge** — self-hosted multiroom audio. [github.com/lollonet/snapforge](https://github.com/lollonet/snapforge)
