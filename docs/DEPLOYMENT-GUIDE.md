<p align="center">
  <img src="../branding/logo.svg" alt="SnapForge" width="80">
</p>

# SnapForge Deployment Guide

Complete guide to deploying a SnapForge multiroom audio system.

## Prerequisites

### Server Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| CPU | 2 cores | 4 cores |
| RAM | 1 GB | 2 GB |
| Storage | 1 GB + music | SSD recommended |
| Network | 100 Mbps | Gigabit |
| OS | Linux (Docker) | Ubuntu 22.04+ / Debian 12+ |

### Client Requirements (Raspberry Pi)

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| Model | RPi 3B | RPi 4 (2GB+) |
| Storage | 8 GB SD | 16 GB+ SD |
| Network | WiFi | Ethernet (more stable) |
| Audio | USB DAC | I2S HAT (better quality) |

### Network Requirements

- All devices on same subnet (or routed with multicast)
- Ports 1704, 1780, 6600 accessible
- mDNS/Bonjour working (port 5353 UDP)

## Phase 1: Server Deployment (snapMULTI)

### Step 1: Prepare the Host

```bash
# Install Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# Install Avahi (for mDNS)
sudo apt update
sudo apt install -y avahi-daemon avahi-utils

# Verify Avahi is running
systemctl status avahi-daemon
```

### Step 2: Clone and Configure

```bash
# Clone the repository
git clone https://github.com/lollonet/snapMULTI.git
cd snapMULTI

# Copy environment template
cp .env.example .env
```

### Step 3: Edit Configuration

Edit `.env` with your settings:

```bash
# Music library paths on host
MUSIC_LOSSLESS_PATH=/home/user/Music/FLAC
MUSIC_LOSSY_PATH=/home/user/Music/MP3

# Server IP (for clients to connect)
SERVER_IP=192.168.1.100

# Timezone
TZ=Europe/Rome
```

### Step 4: Start Services

```bash
# Start the stack
docker compose up -d

# Verify services are running
docker ps

# Check logs
docker logs snapserver
docker logs mpd
```

### Step 5: Verify Server

```bash
# Test mDNS advertisement
avahi-browse -r _snapcast._tcp --terminate

# Test JSON-RPC API
curl -s http://localhost:1780/jsonrpc \
  -H "Content-Type: application/json" \
  -d '{"id":1,"jsonrpc":"2.0","method":"Server.GetStatus"}' | jq

# Test MPD
mpc status
```

### Step 6: Update Music Database

```bash
# Trigger MPD database update
printf 'update\n' | nc localhost 6600

# Monitor progress
watch -n1 'printf "status\n" | nc localhost 6600 | grep updating'
```

## Phase 2: Client Deployment (rpi-snapclient-usb)

### Option A: Automated Setup (Recommended)

```bash
# On Raspberry Pi
git clone https://github.com/lollonet/rpi-snapclient-usb.git
cd rpi-snapclient-usb

# Run interactive setup
./scripts/setup.sh

# Follow prompts to:
# 1. Select your audio HAT
# 2. Configure server connection
# 3. Set client name
```

### Option B: Docker Setup

```bash
# On Raspberry Pi with Docker installed
docker run -d \
  --name snapclient \
  --device /dev/snd \
  --network host \
  -e SNAPSERVER=192.168.1.100 \
  lollonet/snapclient:latest
```

### Option C: Native Installation

```bash
# Install snapclient
sudo apt update
sudo apt install -y snapclient

# Configure
sudo nano /etc/default/snapclient

# Set: SNAPCLIENT_OPTS="--host 192.168.1.100 --hostID living-room"

# Enable and start
sudo systemctl enable snapclient
sudo systemctl start snapclient
```

### Audio HAT Configuration

For I2S audio HATs, add to `/boot/config.txt`:

```ini
# HiFiBerry DAC+
dtoverlay=hifiberry-dacplus

# HiFiBerry Digi+
dtoverlay=hifiberry-digi

# IQaudio DAC+
dtoverlay=iqaudio-dacplus

# Allo Boss
dtoverlay=allo-boss-dac-pcm512x-audio

# JustBoom DAC
dtoverlay=justboom-dac
```

Then reboot:

```bash
sudo reboot
```

### Verify Client Connection

```bash
# Check if connected to server
journalctl -u snapclient -f

# On server, verify client appears
curl -s http://localhost:1780/jsonrpc \
  -d '{"id":1,"jsonrpc":"2.0","method":"Server.GetStatus"}' | jq '.result.server.groups[].clients'
```

## Phase 3: Controller Setup (SnapCTRL)

### Installation

```bash
# Clone repository
git clone https://github.com/lollonet/snapctrl.git
cd snapctrl

# Install with uv (recommended)
uv pip install -e .

# Or with pip
pip install -e .
```

### Run

```bash
# Launch GUI
python -m snapctrl

# Or if installed globally
snapctrl
```

### Configuration

On first launch:
1. Enter server IP (e.g., `192.168.1.100`)
2. Enter port (default: `1780`)
3. Click Connect

## Verification Checklist

### Server

- [ ] Docker containers running (`docker ps`)
- [ ] Snapserver listening on 1704, 1780 (`ss -tlnp | grep -E "1704|1780"`)
- [ ] MPD listening on 6600 (`ss -tlnp | grep 6600`)
- [ ] mDNS services advertised (`avahi-browse -r _snapcast._tcp`)
- [ ] Music database indexed (`mpc stats`)

### Client

- [ ] Snapclient service running (`systemctl status snapclient`)
- [ ] Connected to server (check server logs)
- [ ] Audio output working (`speaker-test -t wav -c 2`)
- [ ] Correct audio device selected (`aplay -l`)

### Controller

- [ ] Can connect to server
- [ ] Shows all groups and clients
- [ ] Volume control works
- [ ] Mute control works

## Testing Audio

### Play Test Tone

```bash
# On server, via MPD
mpc add http://www.hochmuth.com/mp3/Haydn_Cello_Concerto_D-1.mp3
mpc play
```

### Stream via TCP Input

```bash
# Stream internet radio
ffmpeg -i http://stream.radioparadise.com/flac \
  -f s16le -ar 48000 -ac 2 \
  tcp://192.168.1.100:4953
```

### Test AirPlay

1. On iPhone/iPad, open Control Center
2. Tap AirPlay icon
3. Select "Snapcast"
4. Play music from any app

## Troubleshooting

### No Audio on Client

```bash
# Check ALSA devices
aplay -l

# Test direct playback
speaker-test -t wav -c 2 -D hw:0,0

# Check snapclient output device
snapclient --list
```

### Client Can't Find Server

```bash
# Test direct connection
snapclient --host 192.168.1.100

# Check firewall on server
sudo ufw status
sudo ufw allow 1704/tcp
sudo ufw allow 1780/tcp
```

### mDNS Not Working

```bash
# On server
avahi-browse -a --terminate

# Check Avahi daemon
systemctl status avahi-daemon

# Restart if needed
sudo systemctl restart avahi-daemon
```

### Audio Stuttering

1. Increase buffer: Edit `snapserver.conf`, set `buffer = 1500`
2. Use wired Ethernet instead of WiFi
3. Check network congestion
4. Reduce number of simultaneous clients

## Production Recommendations

### Security

```bash
# Restrict to local network only
sudo ufw default deny incoming
sudo ufw allow from 192.168.1.0/24 to any port 1704
sudo ufw allow from 192.168.1.0/24 to any port 1780
sudo ufw allow from 192.168.1.0/24 to any port 6600
sudo ufw enable
```

### Monitoring

```bash
# Add to crontab for health check
*/5 * * * * curl -sf http://localhost:1780/jsonrpc -d '{"id":1,"jsonrpc":"2.0","method":"Server.GetStatus"}' || systemctl restart snapserver
```

### Backup Configuration

```bash
# Backup script
tar -czf snapforge-backup-$(date +%Y%m%d).tar.gz \
  /path/to/snapMULTI/.env \
  /path/to/snapMULTI/snapserver.conf \
  /path/to/snapMULTI/mpd/
```

### Auto-Start on Boot

Server containers are configured with `restart: unless-stopped` in docker-compose.

For clients:

```bash
sudo systemctl enable snapclient
```

## Next Steps

1. [Add more clients](#phase-2-client-deployment-rpi-snapclient-usb)
2. [Configure groups via SnapCTRL](#phase-3-controller-setup-snapctrl)
3. [Set up mobile control with MPD apps](https://github.com/lollonet/snapMULTI#control-mpd)
4. [Explore advanced configurations](ARCHITECTURE.md)
