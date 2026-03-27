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
- Ports 1704, 1705, 1780, 6600 accessible
- mDNS/Bonjour working (port 5353 UDP)

## Phase 1: Server Deployment (snapMULTI)

Follow the **[snapMULTI installation guide](https://github.com/lollonet/snapMULTI#quick-start)** for full step-by-step instructions (plug-and-play for Raspberry Pi, or manual Docker setup for any Linux machine).

### Verify Server

After deployment, confirm the server is running:

```bash
# Services running
docker ps

# mDNS advertisement
avahi-browse -r _snapcast._tcp --terminate

# JSON-RPC API responds
curl -s http://localhost:1780/jsonrpc \
  -H "Content-Type: application/json" \
  -d '{"id":1,"jsonrpc":"2.0","method":"Server.GetStatus"}' | jq

# MPD accessible
mpc status
```

## Phase 2: Client Deployment (rpi-snapclient-usb)

Follow the **[rpi-snapclient-usb setup guide](https://github.com/lollonet/rpi-snapclient-usb#zero-touch-auto-install-recommended)** — zero-touch auto-install (recommended) or interactive script. Supports 11 audio HATs and USB DACs.

### Verify Client Connection

```bash
# Check if connected to server
docker ps   # snapclient should be running

# On server, verify client appears
curl -s http://localhost:1780/jsonrpc \
  -d '{"id":1,"jsonrpc":"2.0","method":"Server.GetStatus"}' | jq '.result.server.groups[].clients'
```

## Phase 3: Control Your System

### Built-in Web UI (available now)

Open `http://<server-ip>:1780` in any browser to manage speakers, switch sources, and adjust volume.

### Native Apps (coming soon)

**SnapCTRL** (desktop controller) and **SnapClient iOS/Android** (mobile) are coming soon — see [Native Apps](../README.md#native-apps--coming-soon).

## Verification Checklist

### Server

- [ ] Docker containers running (`docker ps`)
- [ ] Snapserver listening on 1704, 1705, 1780 (`ss -tlnp | grep -E "1704|1705|1780"`)
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
sudo ufw allow from 192.168.1.0/24 to any port 1705
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
