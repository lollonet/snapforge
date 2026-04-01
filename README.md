<!-- markdownlint-disable MD013 MD033 MD041 -->

<p align="center">
  <img src="branding/hero.svg" alt="SnapForge — self-hosted multiroom audio ecosystem" width="100%">
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License"></a>
  <a href="docs/QUICKSTART.md"><img src="https://img.shields.io/badge/start-in%205%20min-brightgreen.svg" alt="Quickstart"></a>
</p>

<p align="center">
  <em>English | <a href="README.it.md">Italiano</a></em>
</p>

---

> **SnapForge is a self-hosted multiroom audio ecosystem built around an open platform.** It combines a server, endpoint clients, and native controllers into a coherent system while staying explicit about what is open, what is proprietary, and what is built on upstream Snapcast.

## What SnapForge Is

`SnapForge` is the ecosystem layer, not a single product.

Its job is to explain how the components fit together:

- `snapMULTI` is the server product.
- `SnapClient` is the endpoint family.
- `Santcasp` is the Snapcast fork/package layer.
- `SnapCTRL` is the desktop controller.

SnapForge does not replace upstream `Snapcast`. It documents and coordinates how the open platform and companion apps fit together.

## Open Platform

The open platform is the main story.

| Component | Role | Source of truth |
| --- | --- | --- |
| [`snapMULTI`](https://github.com/lollonet/snapMULTI) | Server for synchronized playback, sources, and home deployment | `snapMULTI` repo |
| [`SnapClient Pi`](https://github.com/lollonet/snapclient-pi) | Raspberry Pi endpoint with audio HAT / USB DAC support, cover display, and room playback | `snapclient-pi` repo |
| [`Santcasp`](https://github.com/lollonet/santcasp) | Snapcast fork/package layer providing prebuilt binaries and fork-specific runtime work | `santcasp` repo |

## Native Clients And Controllers

These extend the ecosystem around the open platform.

| Component | Role | Availability |
| --- | --- | --- |
| `SnapCTRL` | Desktop controller for groups, volume, metadata, and system state | Platform availability varies |
| `SnapClient iOS` | Native iPhone and iPad endpoint/control client | Platform availability varies |
| `SnapClient Android` | Native Android endpoint/control client | Platform availability varies |

## Ecosystem Map

```text
Audio Sources
  MPD / AirPlay / Spotify / Tidal / TCP
                  |
                  v
          snapMULTI (server)
                  |
                  |  synchronized Snapcast streams
                  v
   +--------------+---------------+------------------+
   |                              |                  |
   v                              v                  v
SnapClient Pi                SnapClient iOS    SnapClient Android
   ^
   |
   +---- Santcasp provides the fork/package layer for snapclient/snapserver binaries

Control surfaces:
- Built-in web UI from snapMULTI
- SnapCTRL desktop controller
```

## Choose Your Path

| If you want to... | Start here |
| --- | --- |
| Run the server and sources | [`snapMULTI`](https://github.com/lollonet/snapMULTI) |
| Add a Raspberry Pi room endpoint | [`SnapClient Pi`](https://github.com/lollonet/snapclient-pi) |
| Use the fork/package layer directly | [`Santcasp`](https://github.com/lollonet/santcasp) |
| Understand how the ecosystem fits together | [Architecture](docs/ARCHITECTURE.md) |

## What Is Open And What Is Not

| Component | Status | License / model |
| --- | --- | --- |
| `snapMULTI` | Open | MIT |
| `SnapClient Pi` | Open | MIT |
| `Santcasp` | Open fork | GPLv3+ |
| `SnapCTRL` | Closed / proprietary | Separate commercial licensing |
| `SnapClient iOS` | Closed / proprietary | Separate commercial licensing |
| `SnapClient Android` | Closed / proprietary | Separate commercial licensing |

## Public Roadmap

This roadmap is intentionally high-level. It is meant to show direction, not to act as a task board or release promise.

### Now

- Stabilize naming and ecosystem boundaries.
- Keep the open platform docs accurate and coherent.
- Tighten the relationship between `snapMULTI`, `SnapClient Pi`, and `Santcasp`.

### Next

- Improve ecosystem-level compatibility visibility.
- Mature the client family narrative across Pi, iOS, and Android.
- Clarify controller and companion-app positioning.

### Later

- Add broader integrations where they strengthen the open platform.
- Expand ecosystem convenience without turning `snapforge` into a product-doc duplicate.

## Documentation

| Document | Description |
| --- | --- |
| [Quickstart](docs/QUICKSTART.md) | Fast routing guide into the right component |
| [Architecture](docs/ARCHITECTURE.md) | Ecosystem structure and component boundaries |
| [Compatibility](docs/COMPATIBILITY.md) | Component roles, cross-repo relationships, and support ownership |
| [Deployment Guide](docs/DEPLOYMENT-GUIDE.md) | Higher-level deployment flow and verification |
| [Hardware BOM](docs/HARDWARE-BOM.md) | Recommended hardware and cost framing |
| [Contributing](CONTRIBUTING.md) | Where contributions belong across the ecosystem |

## Contributing

Open-source contributions should go to the repo that owns the code:

- [`snapMULTI`](https://github.com/lollonet/snapMULTI/issues) for server work
- [`snapclient-pi`](https://github.com/lollonet/snapclient-pi/issues) for Raspberry Pi endpoint work
- [`santcasp`](https://github.com/lollonet/santcasp/issues) for fork/package-layer work
- [`snapforge`](https://github.com/lollonet/snapforge/issues) for ecosystem docs, maps, and cross-repo positioning

The native apps and `SnapCTRL` are not open for external code contributions at this time.

## License

The open platform components are licensed separately in their own repositories.

- `snapMULTI` and `SnapClient Pi` are MIT-licensed.
- `Santcasp` is a GPLv3+ Snapcast fork.
- Native apps and `SnapCTRL` use separate proprietary licensing.

---

**SnapForge** — self-hosted multiroom audio ecosystem. [github.com/lollonet/snapforge](https://github.com/lollonet/snapforge)
