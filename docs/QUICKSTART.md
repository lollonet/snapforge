<p align="center">
  <img src="../branding/logo.svg" alt="SnapForge" width="80">
</p>

# 5-Minute Quickstart

> From zero to synchronized music in every room.

This guide gets you a working multiroom audio system as fast as possible.
For detailed configuration, see the [Deployment Guide](DEPLOYMENT-GUIDE.md).

## Choose your setup

| Setup | Hardware | What you get |
|-------|----------|-------------|
| **Minimal** | 1 Pi 4 + audio HAT | Server + client on the same device. One room, zero extras. |
| **Standard** | Pi 4 + Pi per room + laptop | Dedicated server, one speaker per room, desktop controller. |
| **Power user** | NUC + Pi clients + PC | Always-on NUC server, Pi endpoints everywhere, full SnapCTRL on your laptop. |

Not sure? Start with **Minimal** — you can add rooms later without reconfiguring anything.

For the full platform support matrix, see [Architecture — Deployment Topologies](ARCHITECTURE.md#deployment-topologies).

---

## What you'll need

| Role | Hardware | You'll install |
|------|----------|---------------|
| **Server** | Any Linux PC or Raspberry Pi 4 | [snapMULTI](https://github.com/lollonet/snapMULTI) |
| **Client** (one per room) | Raspberry Pi + audio HAT or USB DAC | [rpi-snapclient](https://github.com/lollonet/rpi-snapclient-usb) |
| **Controller** (optional) | Any browser, or your laptop | Built-in web UI · SnapCTRL (coming soon) |

Don't have a Raspberry Pi? You can still try the server + controller on a single machine.

---

## Step 1 — Start the server

Follow the **[snapMULTI Quick Start](https://github.com/lollonet/snapMULTI#quick-start)** — choose between plug-and-play (Raspberry Pi) or manual Docker setup on any Linux machine.

The short version:

```bash
git clone https://github.com/lollonet/snapMULTI.git && cd snapMULTI
cp .env.example .env    # edit paths to your music
docker compose up -d
```

> See the [full snapMULTI README](https://github.com/lollonet/snapMULTI#readme) for all options including Spotify, AirPlay, Tidal, and TCP sources.

---

## Step 2 — Add a room (Raspberry Pi client)

Follow the **[rpi-snapclient-usb setup](https://github.com/lollonet/rpi-snapclient-usb#zero-touch-auto-install-recommended)** — zero-touch auto-install or interactive script. Supports 11 audio HATs.

The short version:

```bash
git clone https://github.com/lollonet/rpi-snapclient-usb.git && cd rpi-snapclient-usb
./scripts/setup.sh     # pick your DAC, set room name, done
```

Clients find the server automatically via mDNS. Repeat for each room.

> See the [full rpi-snapclient-usb README](https://github.com/lollonet/rpi-snapclient-usb#readme) for hardware requirements, display setup, and troubleshooting.

---

## Step 3 — Control your system

Open the built-in web UI in any browser:

```bash
open http://<server-ip>:1780   # volume, groups, stream selection
```

> **SnapCTRL** (native desktop app) and **SnapClient iOS/Android** (mobile) are coming soon — see [Native Apps](../README.md#native-apps--coming-soon).

---

## Step 4 — Play music

### From your music library (MPD)

```bash
# On the server, index your music
mpc update

# Wait for indexing, then play
mpc ls | head -1 | mpc add
mpc play
```

All rooms play in perfect sync.

### From an iPhone/iPad (AirPlay)

1. Open Control Center
2. Tap the AirPlay icon
3. Select "Snapcast"
4. Play from any app — it goes to every room

### From any app (TCP stream)

```bash
# Stream internet radio to all rooms
ffmpeg -i http://stream.radioparadise.com/flac \
  -f s16le -ar 48000 -ac 2 tcp://YOUR_SERVER_IP:4953
```

---

## What just happened

```
Your Music ──→ snapMULTI server ──→ Living Room Pi  ♪
                    │                Kitchen Pi      ♪
                    │                Bedroom Pi      ♪
                    │
              SnapCTRL ←── controls volume, groups, sources
```

- **snapMULTI** receives audio from MPD, AirPlay, or TCP and distributes it via Snapcast
- **rpi-snapclient** on each Pi receives the stream and plays it through the audio HAT
- **SnapCTRL** talks to the server via JSON-RPC to control everything
- **mDNS** makes all components find each other without manual IP configuration

Sync accuracy is **sub-millisecond**. No more echo between rooms.

---

## Next steps

| Want to... | Read |
|-----------|------|
| Understand the full architecture | [Architecture](ARCHITECTURE.md) |
| See all configuration options | [Deployment Guide](DEPLOYMENT-GUIDE.md) |
| Choose hardware and compare costs | [Hardware BOM](HARDWARE-BOM.md) |
| See example setups | [Home Setup](../examples/home-setup/) / [Studio Setup](../examples/studio-setup/) |
| Control from your phone | Use any MPD client app (MALP, MPDroid, MPoD) |
| Stream from Spotify | Open Spotify → Connect → select your server ([details](https://github.com/lollonet/snapMULTI#how-it-works)) |

---

## Troubleshooting

**Client doesn't find the server?**

```bash
# On the client Pi, check mDNS
avahi-browse -r _snapcast._tcp --terminate

# If nothing shows up, connect manually
snapclient --host YOUR_SERVER_IP
```

**No audio output?**

```bash
# Check the audio device is detected
aplay -l

# Test it directly
speaker-test -t wav -c 2
```

**Apps can't connect?**

SnapCTRL and mobile apps connect via TCP on port 1705. The web UI uses port 1780. Make sure both are accessible:

```bash
# Test HTTP/web UI (port 1780)
curl -s http://SERVER_IP:1780/jsonrpc \
  -d '{"id":1,"jsonrpc":"2.0","method":"Server.GetStatus"}' | jq .

# Test TCP control port (port 1705) — used by SnapCTRL, iOS, Android
nc -zv SERVER_IP 1705
```

For more, see the [Deployment Guide troubleshooting section](DEPLOYMENT-GUIDE.md#troubleshooting).

---

**SnapForge** — self-hosted multiroom audio. [github.com/lollonet/snapforge](https://github.com/lollonet/snapforge)
