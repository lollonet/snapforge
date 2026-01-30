# 5-Minute Quickstart

> From zero to synchronized music in every room.

This guide gets you a working multiroom audio system as fast as possible.
For detailed configuration, see the [Deployment Guide](DEPLOYMENT-GUIDE.md).

## What you'll need

| Role | Hardware | You'll install |
|------|----------|---------------|
| **Server** | Any Linux PC or Raspberry Pi 4 | [snapMULTI](https://github.com/lollonet/snapMULTI) |
| **Client** (one per room) | Raspberry Pi + audio HAT or USB DAC | [rpi-snapclient](https://github.com/lollonet/rpi-snapclient-usb) |
| **Controller** (optional) | Your laptop (macOS/Linux/Windows) | [SnapCTRL](https://github.com/lollonet/snapctrl) |

Don't have a Raspberry Pi? You can still try the server + controller on a single machine.

---

## Step 1 — Start the server

On the machine that will be your server:

```bash
# Install Docker if you don't have it
curl -fsSL https://get.docker.com | sh

# Install Avahi for network discovery
sudo apt install -y avahi-daemon

# Clone and start
git clone https://github.com/lollonet/snapMULTI.git
cd snapMULTI
cp .env.example .env
```

Edit `.env` — set only these three paths:

```bash
MUSIC_LOSSLESS_PATH=/path/to/your/FLAC
MUSIC_LOSSY_PATH=/path/to/your/MP3
TZ=Europe/Rome
```

Start it:

```bash
docker compose up -d
```

**Verify it works:**

```bash
# You should see snapserver and mpd running
docker ps

# You should see _snapcast._tcp advertised
avahi-browse -r _snapcast._tcp --terminate
```

Server is ready. It's discoverable on your network.

---

## Step 2 — Add a room (Raspberry Pi client)

On each Raspberry Pi that has an audio HAT or USB DAC:

```bash
git clone https://github.com/lollonet/rpi-snapclient-usb.git
cd rpi-snapclient-usb
./scripts/setup.sh
```

The setup script asks you to:
1. **Pick your audio HAT** from 11 supported models (HiFiBerry, IQaudio, JustBoom, Allo, USB...)
2. **Pick a display resolution** if you have a screen attached (for album art)
3. **Set a room name** (e.g., "Living Room", "Kitchen")

That's it. The client will:
- Find the server automatically via mDNS (no IP to configure)
- Start playing whatever the server is streaming
- Show album art on the attached display

**Verify:**

```bash
docker ps   # snapclient should be running
```

Repeat for each room.

---

## Step 3 — Control from your desktop

On your laptop:

```bash
git clone https://github.com/lollonet/snapctrl.git
cd snapctrl
uv pip install -e .
python -m snapctrl
```

> No `uv`? Use `pip install -e .` instead. Or just try the demo: `python demo.py`

SnapCTRL will:
- Discover the server on your network
- Show all connected rooms
- Let you control volume, mute, and group rooms together
- Show what's playing with album art

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
| Add Spotify Connect | Coming soon — see [Roadmap](../README.md#roadmap) |

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

**SnapCTRL can't connect?**

Make sure port 1780 is accessible from your laptop:

```bash
curl -s http://SERVER_IP:1780/jsonrpc \
  -d '{"id":1,"jsonrpc":"2.0","method":"Server.GetStatus"}' | jq .
```

For more, see the [Deployment Guide troubleshooting section](DEPLOYMENT-GUIDE.md#troubleshooting).

---

**SnapForge** — the open-source Sonos alternative. [github.com/lollonet/snapforge](https://github.com/lollonet/snapforge)
