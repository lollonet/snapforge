# Home Setup Example / Esempio Setup Casa

A typical home multiroom audio setup with 3 rooms.

Un tipico setup audio multiroom domestico con 3 stanze.

## Architecture / Architettura

```
┌─────────────────────────────────────────────────────────────┐
│                    HOME NETWORK / RETE CASA                 │
│                                                             │
│  ┌─────────────┐     ┌─────────────┐     ┌─────────────┐   │
│  │   Server    │     │   Router    │     │    NAS      │   │
│  │  snapMULTI  │◄────│   WiFi/     │────►│   Music     │   │
│  │  (RPi 4)    │     │   Ethernet  │     │   Library   │   │
│  └──────┬──────┘     └──────┬──────┘     └─────────────┘   │
│         │                   │                               │
│         │    ┌──────────────┼──────────────┐               │
│         │    │              │              │               │
│         ▼    ▼              ▼              ▼               │
│  ┌───────────────┐  ┌───────────────┐  ┌───────────────┐   │
│  │ Living Room   │  │   Bedroom     │  │   Kitchen     │   │
│  │ RPi 4 + DAC2  │  │ RPi 4 + DAC+  │  │ RPi 4 + Amp2  │   │
│  │ → Amplifier   │  │ → Active Spk  │  │ → Passive Spk │   │
│  └───────────────┘  └───────────────┘  └───────────────┘   │
│                                                             │
│  ┌───────────────┐                                         │
│  │   SnapCTRL    │  Desktop/Laptop for control             │
│  │   (Desktop)   │  Desktop/Laptop per controllo           │
│  └───────────────┘                                         │
└─────────────────────────────────────────────────────────────┘
```

## Bill of Materials

| Component | Model | Qty | Unit Price | Total |
|-----------|-------|-----|------------|-------|
| Server | Raspberry Pi 4 4GB | 1 | €55 | €55 |
| Server SD | SanDisk Extreme 64GB | 1 | €15 | €15 |
| Server PSU | Official RPi PSU | 1 | €10 | €10 |
| Client Living | Raspberry Pi 4 2GB | 1 | €45 | €45 |
| DAC Living | HiFiBerry DAC2 Pro | 1 | €65 | €65 |
| Case Living | HiFiBerry Case | 1 | €20 | €20 |
| Client Bedroom | Raspberry Pi 4 2GB | 1 | €45 | €45 |
| DAC Bedroom | HiFiBerry DAC+ Standard | 1 | €35 | €35 |
| Case Bedroom | Official RPi Case | 1 | €8 | €8 |
| Client Kitchen | Raspberry Pi 4 2GB | 1 | €45 | €45 |
| Amp Kitchen | HiFiBerry Amp2 | 1 | €55 | €55 |
| Speakers Kitchen | Passive bookshelf | 1 pair | €50 | €50 |
| Client SD x3 | SanDisk 32GB | 3 | €12 | €36 |
| Client PSU x3 | Official RPi PSU | 3 | €10 | €30 |
| **Total** | | | | **€514** |

## Configuration Files

### Server .env

```bash
# /home/user/snapMULTI/.env

# Music library paths
MUSIC_LOSSLESS_PATH=/mnt/nas/Music/FLAC
MUSIC_LOSSY_PATH=/mnt/nas/Music/MP3

# Server settings
SERVER_IP=192.168.1.100
TZ=Europe/Rome
```

### Client Configuration

Each client needs `/etc/default/snapclient`:

**Living Room:**
```bash
SNAPCLIENT_OPTS="--host 192.168.1.100 --hostID living-room --soundcard hw:0,0"
```

**Bedroom:**
```bash
SNAPCLIENT_OPTS="--host 192.168.1.100 --hostID bedroom --soundcard hw:0,0"
```

**Kitchen:**
```bash
SNAPCLIENT_OPTS="--host 192.168.1.100 --hostID kitchen --soundcard hw:0,0"
```

## Network Configuration

### Static IPs (Recommended)

| Device | IP | MAC | Notes |
|--------|----|----|-------|
| Server | 192.168.1.100 | Reserve in router | Snapserver |
| Living Room | 192.168.1.101 | Reserve in router | Client |
| Bedroom | 192.168.1.102 | Reserve in router | Client |
| Kitchen | 192.168.1.103 | Reserve in router | Client |

### Firewall Rules (Server)

```bash
sudo ufw allow from 192.168.1.0/24 to any port 1704 proto tcp
sudo ufw allow from 192.168.1.0/24 to any port 1780 proto tcp
sudo ufw allow from 192.168.1.0/24 to any port 6600 proto tcp
```

## Usage Tips / Consigli d'Uso

### Daily Use / Uso Quotidiano

1. **Start music / Avvia musica:**
   ```bash
   mpc play
   ```

2. **Control via phone / Controllo da telefono:**
   - Install MPDroid (Android) or MPD Remote (iOS)
   - Connect to 192.168.1.100:6600

3. **AirPlay from iPhone:**
   - Open Control Center → AirPlay → Select "Snapcast"

### Group Management / Gestione Gruppi

Use SnapCTRL to:
- Create groups (e.g., "Downstairs" = Living + Kitchen)
- Adjust individual client volumes
- Switch audio sources

## Troubleshooting

### Common Issues / Problemi Comuni

**No audio on client / Nessun audio sul client:**
```bash
# Check connection / Verifica connessione
journalctl -u snapclient -f

# Test audio device / Testa dispositivo audio
speaker-test -t wav -c 2
```

**Client disconnects / Client si disconnette:**
- Check WiFi signal strength
- Consider Ethernet for problematic clients
- Increase buffer in snapserver.conf

**Audio out of sync / Audio non sincronizzato:**
- All clients should have similar latency
- Adjust per-client latency in SnapCTRL
