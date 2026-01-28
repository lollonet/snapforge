# SnapForge Architecture

This document describes the technical architecture of the SnapForge multiroom audio ecosystem.

## System Overview

SnapForge consists of three main components that work together to provide synchronized multiroom audio:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              AUDIO SOURCES                                   │
├─────────────────┬─────────────────┬─────────────────┬───────────────────────┤
│ Local Library   │ AirPlay         │ TCP Stream      │ (Future: Spotify)     │
│ (MPD)           │ (iOS/macOS)     │ (any app)       │                       │
└────────┬────────┴────────┬────────┴────────┬────────┴───────────────────────┘
         │                 │                 │
         ▼                 ▼                 ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         snapMULTI (Server)                                   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │     MPD     │  │ Shairport   │  │ TCP Server  │  │    Snapserver       │ │
│  │  Port 6600  │  │   Sync      │  │  Port 4953  │  │  Ports 1704/1780    │ │
│  │             │  │  (AirPlay)  │  │             │  │                     │ │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘  │  - Stream mgmt      │ │
│         │                │                │         │  - Client registry  │ │
│         ▼                ▼                ▼         │  - Group control    │ │
│  ┌─────────────────────────────────────────────┐   │  - JSON-RPC API     │ │
│  │              FIFO / Named Pipes              │───│                     │ │
│  │           /audio/snapcast_fifo               │   └─────────────────────┘ │
│  └─────────────────────────────────────────────┘                            │
│                                                                              │
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

                    ┌─────────────────────────────────────┐
                    │            SnapCTRL                 │
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
                    │  │     │  TCP Client   │─────────┼──┼──► Port 1780
                    │  │     │  JSON-RPC     │         │  │
                    │  │     └───────────────┘         │  │
                    │  └───────────────────────────────┘  │
                    │  Windows / macOS / Linux            │
                    └─────────────────────────────────────┘
```

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
| 1780 | Controller → Server | TCP | JSON-RPC API |
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
