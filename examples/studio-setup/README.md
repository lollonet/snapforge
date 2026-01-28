# Studio/Pro Setup Example / Esempio Setup Studio/Pro

A professional or semi-pro setup for recording studios, podcast rooms, or high-end listening.

Un setup professionale o semi-pro per studi di registrazione, sale podcast o ascolto high-end.

## Architecture / Architettura

```
┌─────────────────────────────────────────────────────────────────┐
│                    STUDIO NETWORK / RETE STUDIO                 │
│                                                                 │
│  ┌─────────────────┐                                           │
│  │  Server (x86)   │   Intel NUC / Mini PC                     │
│  │  snapMULTI      │   Running Docker                          │
│  │  + Local SSD    │   1TB+ music storage                      │
│  └────────┬────────┘                                           │
│           │                                                     │
│           │ Gigabit Ethernet (REQUIRED)                        │
│           │                                                     │
│  ┌────────┴────────────────────────────────────────────┐       │
│  │              Managed Switch (Gigabit)               │       │
│  └────────┬─────────────┬─────────────┬───────────────┘       │
│           │             │             │                        │
│           ▼             ▼             ▼                        │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐           │
│  │ Control Room │ │ Studio A     │ │ Studio B     │           │
│  │              │ │              │ │              │           │
│  │ RPi 4 4GB    │ │ RPi 4 4GB    │ │ RPi 4 4GB    │           │
│  │ Allo Boss2   │ │ Allo DigiOne │ │ HiFiBerry    │           │
│  │ → Monitor    │ │ → External   │ │ DAC2 Pro     │           │
│  │   Speakers   │ │   DAC        │ │ → Headphones │           │
│  │              │ │              │ │   Amp        │           │
│  └──────────────┘ └──────────────┘ └──────────────┘           │
│                                                                 │
│  ┌──────────────┐                                              │
│  │  SnapCTRL    │  On workstation for monitoring               │
│  │  (Desktop)   │  Su workstation per monitoraggio             │
│  └──────────────┘                                              │
└─────────────────────────────────────────────────────────────────┘
```

## Key Differences from Home Setup

| Aspect | Home | Studio |
|--------|------|--------|
| Network | WiFi OK | **Wired Ethernet required** |
| Server | Raspberry Pi | **x86 Mini PC** |
| DACs | Standard HATs | **High-end HATs** |
| Buffer | 1000ms | **Lower (300-500ms)** for monitoring |
| Codec | FLAC | FLAC or PCM for lowest latency |

## Bill of Materials

| Component | Model | Qty | Unit Price | Total |
|-----------|-------|-----|------------|-------|
| Server | Intel NUC i5 | 1 | €350 | €350 |
| Server RAM | 16GB DDR4 | 1 | €50 | €50 |
| Server SSD | 1TB NVMe | 1 | €80 | €80 |
| Switch | TP-Link TL-SG108 | 1 | €25 | €25 |
| Cat6 Cables | 2m x 4 | 4 | €5 | €20 |
| Client Control | Raspberry Pi 4 4GB | 1 | €55 | €55 |
| DAC Control | Allo Boss2 | 1 | €85 | €85 |
| PSU Control | iFi iPower 5V | 1 | €50 | €50 |
| Case Control | Allo Acrylic | 1 | €25 | €25 |
| Client Studio A | Raspberry Pi 4 4GB | 1 | €55 | €55 |
| DAC Studio A | Allo DigiOne | 1 | €80 | €80 |
| Case Studio A | Allo Acrylic | 1 | €25 | €25 |
| Client Studio B | Raspberry Pi 4 4GB | 1 | €55 | €55 |
| DAC Studio B | HiFiBerry DAC2 Pro | 1 | €65 | €65 |
| Case Studio B | HiFiBerry Steel | 1 | €20 | €20 |
| SD Cards | SanDisk Extreme 32GB | 3 | €12 | €36 |
| Client PSU | iFi iPower 5V | 3 | €50 | €150 |
| **Total** | | | | **€1,226** |

## Configuration Files

### Server docker-compose.yml additions

```yaml
services:
  snapMULTI:
    # ... standard config ...
    environment:
      - TZ=Europe/Rome
    # Lower buffer for studio monitoring
    command: ["snapserver", "-c", "/etc/snapserver.conf"]
```

### snapserver.conf (Studio Optimized)

```ini
[stream]
source = pipe:////audio/snapcast_fifo?name=MPD
sampleformat = 48000:16:2
codec = flac
# Lower buffer for monitoring (300ms instead of 1000ms)
buffer = 300
# Increase send buffer for stability
send_buffer = 0

[http]
enabled = true
bind_to_address = 0.0.0.0
port = 1780

[tcp]
enabled = true
bind_to_address = 0.0.0.0
port = 1704

[logging]
sink = null
filter = *:info
```

### Client Configuration (Low Latency)

Each client `/etc/default/snapclient`:

**Control Room:**
```bash
SNAPCLIENT_OPTS="--host 192.168.1.100 --hostID control-room --soundcard hw:0,0 --latency 0"
```

**Studio A:**
```bash
SNAPCLIENT_OPTS="--host 192.168.1.100 --hostID studio-a --soundcard hw:0,0 --latency 0"
```

**Studio B:**
```bash
SNAPCLIENT_OPTS="--host 192.168.1.100 --hostID studio-b --soundcard hw:0,0 --latency 0"
```

## Network Configuration

### VLAN Separation (Recommended)

```
VLAN 10: Production (DAWs, interfaces)
VLAN 20: Audio streaming (Snapcast) ← Isolate here
VLAN 30: Management (general network)
```

### Quality of Service (QoS)

On managed switch, prioritize:
- Port 1704 (audio stream): Highest priority
- Port 1780 (control): High priority
- Port 6600 (MPD): Normal priority

### Static IPs

| Device | IP | Notes |
|--------|----|----|
| Server | 192.168.20.1 | Snapserver |
| Control Room | 192.168.20.10 | Primary monitoring |
| Studio A | 192.168.20.11 | Recording room |
| Studio B | 192.168.20.12 | Mixing room |

## Latency Tuning

### For Real-Time Monitoring

If using for live monitoring during recording:

1. **Reduce server buffer:**
   ```ini
   buffer = 150
   ```

2. **Use PCM instead of FLAC:**
   ```ini
   codec = pcm
   ```

3. **Wired Ethernet is MANDATORY**

4. **Expected latency:** ~50-100ms (not suitable for live instrument monitoring)

### For Playback Only

Default settings are fine. Buffer can be higher for stability.

## Integration with DAW

### Send Audio to Snapcast

From your DAW, route audio to Snapcast via TCP:

**Using JACK:**
```bash
# Create JACK client that sends to Snapcast
jack_connect system:capture_1 snapcast:input_1
jack_connect system:capture_2 snapcast:input_2
```

**Using PipeWire:**
```bash
# Route PipeWire sink to Snapcast TCP
pw-cat -r - | nc 192.168.20.1 4953
```

### Stream DAW Output

```bash
# Capture system audio and send to Snapcast
ffmpeg -f pulse -i default \
  -f s16le -ar 48000 -ac 2 \
  tcp://192.168.20.1:4953
```

## Troubleshooting

### Audio Glitches / Glitch Audio

1. Check network utilization: `iftop`
2. Verify Gigabit connection: `ethtool eth0`
3. Increase buffer if needed
4. Check CPU usage on server: `htop`

### Latency Differences Between Rooms

1. Use SnapCTRL to measure per-client latency
2. Adjust individual client latency offset
3. Ensure all clients use Ethernet

### DAC Clicks/Pops

1. Check power supply quality
2. Try different USB cable (for USB DACs)
3. Verify sample rate matching (48kHz everywhere)
