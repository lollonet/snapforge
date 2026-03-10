<p align="center">
  <img src="../branding/logo.svg" alt="SnapForge" width="80">
</p>

# SnapForge Architecture

This document describes the technical architecture of the SnapForge multiroom audio ecosystem.

## System Overview

SnapForge consists of an open platform and native apps that work together to provide synchronized multiroom audio:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              AUDIO SOURCES                                  │
├─────────────────┬─────────────────┬─────────────────┬───────────────────────┤
│ Local Library   │ AirPlay         │ TCP Stream      │ Spotify (librespot)   │
│ (MPD)           │ (iOS/macOS)     │ (any app)       │ Tidal (ARM)           │
└────────┬────────┴────────┬────────┴────────┬────────┴───────────────────────┘
         │                 │                 │
         ▼                 ▼                 ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         snapMULTI (Server)                                  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │     MPD     │  │ Shairport   │  │ TCP Server  │  │    Snapserver       │ │
│  │  Port 6600  │  │   Sync      │  │  Port 4953  │  │  Ports 1704/1780    │ │
│  │             │  │  (AirPlay)  │  │             │  │                     │ │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  │  - Stream mgmt      │ │
│         │                │                │         │  - Client registry  │ │
│         ▼                ▼                ▼         │  - Group control    │ │
│  ┌─────────────────────────────────────────────┐    │  - JSON-RPC API     │ │
│  │              FIFO / Named Pipes              │───│                     │ │
│  │           /audio/snapcast_fifo               │   └─────────────────────┘ │
│  └─────────────────────────────────────────────┘                            │
│                                                                             │
│  Network: host mode │ mDNS via Avahi │ Docker containers                    │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │
                          TCP Port 1704 (audio stream)
                          TCP Port 1780 (JSON-RPC API)
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
│ │ HiFiBerry   │ │          │ │  IQaudio    │ │          │ │   USB DAC   │ │
│ └─────────────┘ │          │ └─────────────┘ │          │ └─────────────┘ │
└─────────────────┘          └─────────────────┘          └─────────────────┘

              ┌───────────────────────────────────────────────────────┐
              │           SnapForge Native Apps (coming soon)         │
              │  ┌──────────────────────┐  ┌───────────────────────┐  │
              │  │   SnapClient iOS     │  │  SnapClient Android   │  │
              │  │  Swift · AVAudioEngine│  │  Kotlin · Oboe       │  │
              │  │  FLAC / Opus / PCM   │  │  FLAC / Opus / PCM   │  │
              │  │  Port 1704 (audio)   │  │  Port 1704 (audio)   │  │
              │  │  Port 1705 (control) │  │  Port 1705 (control) │  │
              │  └──────────────────────┘  └───────────────────────┘  │
              └───────────────────────────────────────────────────────┘

                    ┌─────────────────────────────────────┐
                    │    SnapCTRL (coming soon)           │
                    │  ┌───────────────────────────────┐  │
                    │  │      PySide6/Qt6 GUI          │  │
                    │  │                               │  │
                    │  │  ┌─────────┐  ┌───────────┐   │  │
                    │  │  │ Groups  │  │  Clients  │   │  │
                    │  │  │ Panel   │  │   Panel   │   │  │
                    │  │  └────┬────┘  └─────┬─────┘   │  │
                    │  │       └──────┬──────┘         │  │
                    │  │              ▼                │  │
                    │  │     ┌───────────────┐         │  │
                    │  │     │  State Store  │         │  │
                    │  │     └───────┬───────┘         │  │
                    │  │             ▼                 │  │
                    │  │     ┌───────────────┐         │  │
                    │  │     │  TCP Client   │─────────┼──┼──► Port 1705
                    │  │     │  JSON-RPC     │         │  │
                    │  │     └───────────────┘         │  │
                    │  └───────────────────────────────┘  │
                    │  macOS/Windows (paid) · Linux (free)│
                    └─────────────────────────────────────┘
```

## Component Comparison

Hardware, platform and capability matrix for all SnapForge components.

### Platform & Installation

| | **snapMULTI** | **rpi-snapclient** | **SnapCTRL** | **santcasp** | **SnapClient iOS** | **SnapClient Android** |
|---|---|---|---|---|---|---|
| **Role** | Audio hub + sources | Room speaker endpoint | Desktop control GUI | Core Snapcast binaries | iOS audio client | Android audio client |
| **Platform** | Any Linux (x86_64, ARM64) | Raspberry Pi (ARM64) | macOS, Linux, Windows | Linux, macOS, Windows | iOS 17+ (iPhone/iPad) | Android (API 26+) |
| **Install method** | Docker Compose | Docker + setup script | pip/uv (Linux) · App Store/Microsoft Store | .deb / .tar.gz / .zip | App Store (coming soon) | Play Store (coming soon) |
| **Runs headless** | Yes | Yes | No | Yes | No | No |
| **Runs in Docker** | Yes | Yes | No | No | No | No |

### Hardware Requirements

| | **snapMULTI** | **rpi-snapclient** | **SnapCTRL** | **santcasp** | **SnapClient iOS** | **SnapClient Android** |
|---|---|---|---|---|---|---|
| **Min CPU** | 2 cores | 1 core | Any modern | Any | Apple A12+ | ARMv7 / ARM64 |
| **Min RAM** | 1 GB | 512 MB | 256 MB | 64 MB | — (OS managed) | — (OS managed) |
| **Rec RAM** | 2 GB | 1 GB | — | — | — | — |
| **Min storage** | 1 GB + music library | 8 GB SD card | 200 MB | 50 MB | ~50 MB | ~50 MB |
| **Typical hardware** | RPi 4 4GB, NUC, NAS, old laptop | RPi 3B/4/5 + audio HAT | Any laptop/desktop | Embedded in other components | iPhone / iPad (iOS 17+) | Android phone/tablet (API 26+) |
| **Price per unit** | €50–150 (RPi) / €0 (reuse PC) | €35–80 (RPi + HAT + case + PSU) | Free (Linux) · paid (macOS/Windows) | Free | Paid (App Store) | Paid (Play Store) |

### Audio Capabilities

| | **snapMULTI** | **rpi-snapclient** | **SnapCTRL** | **santcasp** | **SnapClient iOS** | **SnapClient Android** |
|---|---|---|---|---|---|---|
| **Audio output** | None (distributes to clients) | I2S HATs, USB DAC, HDMI, 3.5mm | None (control only) | ALSA, PulseAudio, PipeWire | Speaker, headphones, AirPlay | Speaker, headphones, BT |
| **Codecs** | FLAC stream (48kHz/16bit) | HAT dependent (up to 192kHz/24bit) | — | Codec dependent | FLAC, Opus, PCM | FLAC, Opus, PCM |
| **Audio sources** | MPD, AirPlay, Spotify, Tidal, TCP | Receives stream only | — | Any PCM / pipe / TCP | Receives stream only | Receives stream only |
| **Sync** | Distributes time-synced stream | <1ms (Snapcast protocol) | — | <1ms | <1ms (NTP-style) | <1ms (NTP-style, soft sync) |
| **Display** | Headless | Optional: album art, spectrum analyzer | Desktop GUI (volume, groups, album art) | — | Lock screen, Control Center | Now playing, album art |

### Network

| | **snapMULTI** | **rpi-snapclient** | **SnapCTRL** | **santcasp** | **SnapClient iOS** | **SnapClient Android** |
|---|---|---|---|---|---|---|
| **Network** | Gigabit recommended, host mode | WiFi or Ethernet | Any | Any | WiFi / cellular+VPN | WiFi / cellular+VPN |
| **Ports (listen)** | 1704, 1705, 1780, 6600, 4953, 5353 | 5353 (mDNS) | None (outbound only) | 1704, 1705, 1780 | None (outbound only) | None (outbound only) |
| **Discovery** | Publishes `_snapcast._tcp` | Discovers server via mDNS | Discovers server via mDNS | mDNS optional | mDNS (NWBrowser / Bonjour) | mDNS (NsdManager) |
| **Bandwidth** | ~1.5 Mbps per client (FLAC) | ~1.5 Mbps inbound | Negligible | ~1.5 Mbps per client | ~1.5 Mbps inbound | ~1.5 Mbps inbound |

### Dependencies

| | **snapMULTI** | **rpi-snapclient** | **SnapCTRL** | **santcasp** | **SnapClient iOS** | **SnapClient Android** |
|---|---|---|---|---|---|---|
| **Runtime** | Docker, Avahi | Docker, ALSA | Python 3.11+, PySide6, Qt6 | — | iOS 17+, AVAudioEngine | Android API 26+, Oboe |
| **Build** | — (pre-built images) | — (pre-built images) | pip / uv | CMake, C++17 compiler | Xcode 17+, autotools | Android Studio, NDK, CMake |
| **CI/CD** | GitHub Actions (self-hosted ARM64) | GitHub Actions (self-hosted ARM64) | GitHub Actions | Manual builds | GitHub Actions | GitHub Actions (self-hosted) |

> **Note**: santcasp provides the core `snapserver` and `snapclient` binaries that snapMULTI and rpi-snapclient wrap in their Docker images. SnapCTRL, SnapClient iOS, and SnapClient Android are all purely control/listening clients — none of them serve audio.

## Deployment Topologies

Which components run on which hardware, and how to combine them.

### Platform Support Matrix

#### Components vs Hardware

| | **PC** | **NUC** | **ARM 7v (Pi Zero)** | **ARM 64v (Pi 3/4/5)** | **iPhone/iPad** | **Android** |
|---|:---:|:---:|:---:|:---:|:---:|:---:|
| **Server** | X | X | — | X | — | — |
| **rpi-snapclient** | X | X | X | X | — | — |
| **SnapClient iOS** | — | — | — | — | X | — |
| **SnapClient Android** | — | — | — | — | — | X |
| **CTRL** | X | — | — | — | — | — |
| **MPD source** | X | X | N/A | X | — | — |

- **CTRL** requires a desktop GUI (PySide6/Qt6) — only available on PC (laptop/desktop).
- **Pi Zero** (ARM 7v): rpi-snapclient only. Not enough CPU/RAM for server or MPD.
- **MPD** is N/A on Pi Zero — too weak for music indexing and decoding.
- **SnapClient iOS/Android** — coming soon; connect to any Snapcast server as a personal audio endpoint.

#### Hardware vs Installable Packages

| | **SRV** | **CLIENT** | **CTRL** | **MPD** |
|---|:---:|:---:|:---:|:---:|
| **PC** | X | X | X | X |
| **NUC** | X | X | — | X |
| **Pi Zero** | — | X | — | X |
| **Pi 3/4/5** | X | X | — | X |

### Hardware Profiles

| Hardware | Description | Best role |
|----------|-------------|-----------|
| **PC** (laptop/desktop) | Full-featured. Runs everything including CTRL. | All-in-one, testing, or controller station |
| **NUC** (Intel mini-PC) | Headless mini-PC. Powerful, fanless, always-on. | Dedicated server (SRV + MPD) |
| **Pi Zero / ARM 7v** | Single-core, 512 MB RAM, <1 W idle. | Cheapest room endpoint (client only) |
| **Pi 3/4/5 / ARM 64v** | Quad-core, 1–8 GB RAM. The Pi 4 4 GB is the sweet spot. | Versatile: server or client |

### Deployment Scenarios

#### 1. All-in-one PC (dev/testing)

Everything on one machine. Good for trying SnapForge without any Pi hardware.

```
┌──────────────────────────────────────────┐
│              PC / Laptop                 │
│                                          │
│  snapMULTI (SRV + MPD)                  │
│  snapclient (local speaker)             │
│  SnapCTRL (GUI)                         │
└──────────────────────────────────────────┘
```

#### 2. Dedicated Pi 4 server + Pi clients (most common)

The recommended home setup. One Pi 4 as server, one Pi per room.

```
┌───────────────────┐     ┌─────────────────┐
│   Pi 4 (server)   │────▶│ Pi 3B (bedroom) │
│   SRV + MPD       │     │ CLIENT          │
└───────────────────┘     └─────────────────┘
         │
         ├────────────────▶┌─────────────────┐
         │                 │ Pi 4 (kitchen)  │
         │                 │ CLIENT          │
         │                 └─────────────────┘
         │
         └────────────────▶┌─────────────────┐
                           │ Pi Zero (bath)  │
                           │ CLIENT          │
                           └─────────────────┘
```

#### 3. NUC server + Pi clients + PC controller (power user)

Dedicated always-on NUC server, Pi endpoints, desktop controller.

```
┌───────────────────┐     ┌─────────────────┐
│   NUC (server)    │────▶│ Pi clients      │
│   SRV + MPD       │     │ (one per room)  │
└───────────────────┘     └─────────────────┘
         ▲
         │ JSON-RPC
┌───────────────────┐
│   PC (laptop)     │
│   SnapCTRL        │
└───────────────────┘
```

#### 4. Pi 4 server + Pi Zero clients (cheapest multi-room)

Lowest cost per room (~€15 per Pi Zero W + USB DAC).

```
┌───────────────────┐     ┌───────────────────┐
│   Pi 4 (server)   │────▶│ Pi Zero W (room1) │
│   SRV + MPD       │     │ CLIENT + USB DAC  │
└───────────────────┘     └───────────────────┘
         │
         └────────────────▶┌───────────────────┐
                           │ Pi Zero W (room2) │
                           │ CLIENT + USB DAC  │
                           └───────────────────┘
```

#### 5. PC server + desktop client (no Pi needed)

Use your existing PC as both server and listening endpoint. No Raspberry Pi required.

```
┌──────────────────────────────────────────┐
│              PC / Laptop                 │
│                                          │
│  snapMULTI (SRV + MPD)                  │
│  snapclient (speakers/headphones)       │
│  SnapCTRL (GUI)                         │
└──────────────────────────────────────────┘
```

### Co-location: Server + MPD

The server (snapserver) and MPD can run on the **same machine** or on **different machines**. This choice affects latency and architecture.

| Topology | Audio link | Latency | Complexity | Storage | Best for |
|----------|-----------|---------|------------|---------|----------|
| **Same host** | FIFO pipe (`/audio/snapcast_fifo`) | ~0 ms | Simple | Local disk or NFS mount | Most setups |
| **Separate hosts** | TCP/HTTP stream | +5–20 ms | Higher | NAS / remote storage | Large music libraries on NAS |

**Why it matters:** MPD writes decoded PCM audio to a FIFO pipe. Snapserver reads from that same pipe. This requires both processes to share the same filesystem — which means the same machine (or at least the same Docker volume).

If you need MPD on a different machine (e.g., a NAS with large storage), you must switch from the FIFO pipe to a TCP or HTTP output in MPD, and configure snapserver to read from a TCP source instead. This adds network latency and configuration complexity.

**Default (recommended):** Keep server + MPD co-located. This is how snapMULTI is configured out of the box.

### What Can Share a Machine

| Combination | Works? | Notes |
|-------------|:------:|-------|
| Server + MPD | **Yes** (recommended) | Connected via FIFO pipe. Must be co-located for zero-latency audio. |
| Server + Client | **Yes** | The server machine doubles as a room speaker. No port conflicts. |
| Client + CTRL | **Yes** (PC only) | No port conflicts. Both make outbound connections. |
| Server + Client + MPD | **Yes** | All-in-one setup. Works on Pi 4 or PC. |
| Server + CTRL | **Yes** (PC only) | Control the system from the server machine itself. |

## Component Details

### snapMULTI (Server)

The server component runs as Docker containers with host networking for mDNS support.

#### Services

| Service | Port | Protocol | Purpose |
|---------|------|----------|---------|
| Snapserver | 1704 | TCP | Audio streaming to clients |
| Snapserver | 1780 | HTTP | JSON-RPC control API |
| MPD | 6600 | TCP | Music Player Daemon control |
| TCP Input | 4953 | TCP | External audio stream input |
| mDNS | 5353 | UDP | Service discovery (via host Avahi) |

#### Audio Pipeline

```
Audio Source → Decoder → PCM 48kHz/16bit/Stereo → FIFO → Snapserver → FLAC → Network
```

#### Docker Architecture

```yaml
services:
  snapMULTI:      # Snapserver + Shairport-sync
    network_mode: host
    volumes:
      - /run/dbus/system_bus_socket  # For Avahi mDNS
      - ./audio:/audio               # FIFO pipes

  mpd:           # Music Player Daemon
    network_mode: host
    volumes:
      - ./audio:/audio               # FIFO output
      - /path/to/music:/music:ro     # Music library
```

### rpi-snapclient-usb (Client)

Raspberry Pi-based audio endpoint with support for various audio HATs.

#### Supported Audio HATs

| Manufacturer | Models | Interface |
|--------------|--------|-----------|
| HiFiBerry | DAC+, DAC2, Digi+, Amp2 | I2S |
| IQaudio | DAC+, DigiAMP+ | I2S |
| Allo | Boss, Piano, DigiOne | I2S |
| JustBoom | DAC, Digi, Amp | I2S |
| Generic | USB DAC | USB Audio |

#### Client Architecture

```
┌────────────────────────────────────────────┐
│            rpi-snapclient-usb              │
│                                            │
│  ┌──────────────┐    ┌──────────────────┐  │
│  │  Snapclient  │    │ Metadata Service │  │
│  │   daemon     │    │  (album art)     │  │
│  └──────┬───────┘    └────────┬─────────┘  │
│         │                     │            │
│         ▼                     ▼            │
│  ┌──────────────┐    ┌──────────────────┐  │
│  │    ALSA      │    │   LCD/Display    │  │
│  │   Driver     │    │   (optional)     │  │
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

Desktop application for controlling the Snapcast system.

#### Application Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        SnapCTRL                             │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                    UI Layer (Qt6)                    │   │
│  │  ┌───────────────┐  ┌───────────────┐  ┌─────────┐  │   │
│  │  │ GroupsPanel   │  │ ClientsPanel  │  │ Toolbar │  │   │
│  │  │ - Volume      │  │ - Volume      │  │ - Conn  │  │   │
│  │  │ - Mute        │  │ - Mute        │  │ - Theme │  │   │
│  │  │ - Stream      │  │ - Latency     │  │         │  │   │
│  │  └───────────────┘  └───────────────┘  └─────────┘  │   │
│  └─────────────────────────────────────────────────────┘   │
│                            │                                │
│                            ▼                                │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                  State Management                    │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │   │
│  │  │ ServerState │  │ GroupState  │  │ ClientState │  │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  │   │
│  └─────────────────────────────────────────────────────┘   │
│                            │                                │
│                            ▼                                │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                  Network Layer                       │   │
│  │  ┌─────────────────────────────────────────────┐    │   │
│  │  │              SnapcastClient                  │    │   │
│  │  │  - TCP connection                           │    │   │
│  │  │  - JSON-RPC protocol                        │    │   │
│  │  │  - Event handling                           │    │   │
│  │  └─────────────────────────────────────────────┘    │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## Communication Protocols

### Snapcast Protocol (Port 1704)

Binary protocol for audio streaming:
- Codec: FLAC (lossless) or PCM
- Sample format: 48000:16:2 (48kHz, 16-bit, stereo)
- Buffer: 1000ms default
- Time sync: NTP-like algorithm for <1ms accuracy

### JSON-RPC API (Port 1780)

Control protocol for management:

```json
// Get server status
{"id":1,"jsonrpc":"2.0","method":"Server.GetStatus"}

// Set group volume
{"id":2,"jsonrpc":"2.0","method":"Group.SetVolume","params":{"id":"group_id","volume":{"percent":50}}}

// Set client mute
{"id":3,"jsonrpc":"2.0","method":"Client.SetVolume","params":{"id":"client_id","volume":{"muted":true}}}
```

### mDNS Service Discovery

Published services:
- `_snapcast._tcp` - Snapcast server
- `_snapcast-http._tcp` - JSON-RPC API
- `_raop._tcp` - AirPlay receiver (if enabled)

## Network Requirements

### Ports

| Port | Direction | Protocol | Purpose |
|------|-----------|----------|---------|
| 1704 | Server → Client | TCP | Audio stream |
| 1705 | Controller/App → Server | TCP | JSON-RPC control API (SnapCTRL, iOS, Android) |
| 1780 | Browser → Server | HTTP | Web UI + JSON-RPC over HTTP |
| 6600 | App → Server | TCP | MPD control |
| 4953 | Source → Server | TCP | TCP audio input |
| 5353 | Multicast | UDP | mDNS discovery |

### Bandwidth

| Quality | Per Client | 10 Clients |
|---------|------------|------------|
| FLAC 48/16 | ~1.5 Mbps | ~15 Mbps |
| PCM 48/16 | ~1.5 Mbps | ~15 Mbps |

### Latency

| Segment | Typical | Notes |
|---------|---------|-------|
| Server processing | <1ms | Buffering adds latency |
| Network (WiFi) | 2-10ms | Depends on network quality |
| Client buffer | Configurable | Default 1000ms |
| DAC output | <1ms | Hardware dependent |

## Security Considerations

### Current State

- All communication is **unencrypted**
- No authentication on JSON-RPC API
- Designed for **trusted local networks only**

### Recommendations

1. Isolate on dedicated VLAN if possible
2. Use firewall rules to restrict access
3. Do not expose to internet
4. Consider VPN for remote access

## Scalability

### Tested Configurations

| Clients | Server Hardware | Notes |
|---------|-----------------|-------|
| 1-5 | Raspberry Pi 4 | Works well |
| 5-10 | x86 mini PC | Recommended |
| 10-20 | Standard server | Enterprise use |
| 20+ | Not tested | May need optimization |

### Bottlenecks

1. **Network bandwidth** - Main limitation for many clients
2. **Server CPU** - Encoding multiple streams
3. **WiFi congestion** - Prefer wired clients for stability
