<p align="center">
  <img src="../branding/logo.svg" alt="SnapForge" width="80">
</p>

# SnapForge Hardware Guide

Bill of Materials and hardware recommendations for building a SnapForge multiroom audio system.

## Quick Reference: Recommended Setups

### Budget Setup (~€150 total)

| Component | Model | Price | Notes |
|-----------|-------|-------|-------|
| Server | Any Linux PC/NAS | €0 | Use existing hardware |
| Client x3 | Raspberry Pi Zero 2 W | €15 each | WiFi only |
| DAC x3 | USB DAC (generic) | €15 each | Basic quality |
| **Total** | | **~€90** | 3 rooms |

### Recommended Setup (~€400 total)

| Component | Model | Price | Notes |
|-----------|-------|-------|-------|
| Server | Raspberry Pi 4 (4GB) | €60 | Dedicated server |
| Client x3 | Raspberry Pi 4 (2GB) | €45 each | Reliable |
| DAC x3 | HiFiBerry DAC+ Standard | €35 each | Good quality |
| Cases x3 | Official RPi case | €10 each | Clean look |
| **Total** | | **~€390** | 3 rooms |

### Audiophile Setup (~€800 total)

| Component | Model | Price | Notes |
|-----------|-------|-------|-------|
| Server | Intel NUC / Mini PC | €200 | For large libraries |
| Client x3 | Raspberry Pi 4 (4GB) | €55 each | Headroom |
| DAC x3 | HiFiBerry DAC2 Pro | €65 each | Excellent quality |
| Cases x3 | Allo Acrylic | €25 each | Premium look |
| Linear PSU x3 | iFi iPower | €50 each | Lower noise |
| **Total** | | **~€785** | 3 rooms, audiophile grade |

## Server Hardware

### Option 1: Raspberry Pi (1-5 clients)

| Model | RAM | Price | Suitable For |
|-------|-----|-------|--------------|
| Pi 4 Model B (2GB) | 2GB | €45 | 1-3 clients |
| Pi 4 Model B (4GB) | 4GB | €55 | 3-5 clients |
| Pi 5 (4GB) | 4GB | €70 | 5+ clients, faster |

**Pros**: Low power, silent, cheap
**Cons**: Limited for large music libraries

### Option 2: Mini PC (5-15 clients)

| Model | Specs | Price | Notes |
|-------|-------|-------|-------|
| Intel NUC 12 | i3, 8GB, 256GB | €300 | Compact, powerful |
| Beelink Mini S | N5095, 8GB | €150 | Budget option |
| HP ProDesk Mini | i5, 8GB | €120 | Used/refurb |

**Pros**: More power, runs NAS duties too
**Cons**: Higher power consumption

### Option 3: Existing NAS/Server

If you have a Synology, QNAP, or other NAS, you can run snapMULTI in Docker directly.

**Requirements:**
- Docker support
- 1GB+ free RAM
- Gigabit network

## Client Hardware

### Raspberry Pi Models

| Model | Price | WiFi | Ethernet | Recommended |
|-------|-------|------|----------|-------------|
| Pi Zero 2 W | €15 | Yes | No | Budget, WiFi only |
| Pi 3B+ | €35 | Yes | 100Mbps | Good balance |
| Pi 4 (2GB) | €45 | Yes | Gigabit | **Recommended** |
| Pi 4 (4GB) | €55 | Yes | Gigabit | Future-proof |
| Pi 5 (4GB) | €70 | Yes | Gigabit | Overkill for audio |

**Recommendation**: Raspberry Pi 4 (2GB) offers the best value for audio clients.

### Alternative SBCs

| Board | Price | Notes |
|-------|-------|-------|
| Orange Pi Zero 2 | €25 | Cheap, works |
| ODROID-C4 | €50 | Good audio support |
| Rock Pi 4 | €60 | RPi 4 alternative |

## Audio DACs

### I2S HATs (Best Quality)

| Model | Price | Bits/kHz | THD+N | Notes |
|-------|-------|----------|-------|-------|
| **HiFiBerry DAC+ Standard** | €35 | 24/192 | -93dB | **Best value** |
| HiFiBerry DAC+ Pro | €45 | 24/192 | -100dB | Clock upgrade |
| HiFiBerry DAC2 Pro | €65 | 32/384 | -112dB | Audiophile |
| IQaudio DAC+ | €35 | 24/192 | -96dB | Good alternative |
| IQaudio DAC Pro | €50 | 24/192 | -102dB | RCA output |
| Allo Boss | €65 | 32/384 | -112dB | Excellent |
| Allo Boss2 | €85 | 32/768 | -120dB | Top tier |
| JustBoom DAC HAT | €35 | 24/192 | -94dB | Budget friendly |

**Recommendation**: HiFiBerry DAC+ Standard for most users. DAC2 Pro or Allo Boss for audiophiles.

### Digital Output (S/PDIF)

For external DAC connection:

| Model | Price | Output | Notes |
|-------|-------|--------|-------|
| HiFiBerry Digi+ Standard | €30 | Coax + Optical | Good |
| HiFiBerry Digi2 Pro | €45 | Coax + Optical | Better clock |
| Allo DigiOne | €80 | Coax + BNC | Audiophile |
| IQaudio DigiAMP+ | €55 | + Amplifier | All-in-one |

### USB DACs

For simplicity or when I2S isn't available:

| Model | Price | Quality | Notes |
|-------|-------|---------|-------|
| Generic USB DAC | €10-20 | Basic | Works |
| FiiO E10K | €80 | Good | Headphone amp too |
| Topping D10s | €100 | Excellent | Measurements king |
| SMSL M100 | €80 | Very good | Compact |

### Amplifier HATs

All-in-one solutions with built-in amplification:

| Model | Price | Power | Speakers |
|-------|-------|-------|----------|
| HiFiBerry Amp2 | €55 | 2x30W | Passive |
| IQaudio DigiAMP+ | €55 | 2x35W | Passive |
| JustBoom Amp HAT | €50 | 2x30W | Passive |
| HiFiBerry Amp3 | €65 | 2x60W | Passive |

**Use case**: Kitchen, bathroom, workshop where you want simple passive speakers.

## Power Supplies

### Standard (5V for RPi)

| Type | Price | Notes |
|------|-------|-------|
| Official RPi PSU | €10 | Adequate |
| Anker PowerPort | €15 | Multi-device |
| iFi iPower 5V | €50 | Low noise, audiophile |
| Allo Shanti | €80 | Dual rail, excellent |

**Recommendation**: Official PSU is fine for most. iFi iPower for demanding setups.

### For Amplifier HATs (Higher Power)

| Model | Price | Output | Notes |
|-------|-------|--------|-------|
| Mean Well GST60A | €25 | 18V/3.3A | Budget |
| iFi iPower X | €70 | Various | Low noise |
| Allo Nirvana | €100 | 5V+5V | Audiophile |

## Cases

### Functional

| Model | Price | Notes |
|-------|-------|-------|
| Official RPi Case | €8 | Basic |
| Argon ONE | €25 | Aluminum, passive cooling |
| Flirc Case | €15 | Passive cooling |

### With HAT Support

| Model | Price | Fits |
|-------|-------|------|
| HiFiBerry Steel Case | €20 | HiFiBerry HATs |
| Allo Acrylic Case | €25 | Allo DACs |
| Generic Acrylic | €10 | Most HATs |

### Premium

| Model | Price | Notes |
|-------|-------|-------|
| Allo USBridge Sig. | €250 | Complete solution |
| Pro-Ject Stream Box | €400 | Commercial quality |

## Accessories

### SD Cards

| Model | Size | Price | Notes |
|-------|------|-------|-------|
| SanDisk Extreme | 32GB | €12 | **Recommended** |
| Samsung EVO Plus | 64GB | €15 | Good endurance |
| SanDisk Industrial | 16GB | €20 | Highest reliability |

### Network

| Item | Price | Notes |
|------|-------|-------|
| Cat6 cable | €5/5m | For wired clients |
| TP-Link Switch | €20 | Gigabit 5-port |
| Ethernet to WiFi bridge | €30 | For hard-to-wire spots |

### Display (Optional)

For album art display:

| Model | Price | Size | Notes |
|-------|-------|------|-------|
| Waveshare 3.5" LCD | €25 | 480x320 | Basic |
| Pimoroni HyperPixel | €50 | 800x480 | High quality |
| HDMI mini display | €40 | 7" | For tabletop |

## Sample Configurations

### Configuration A: Living Room (Hi-Fi)

```
Raspberry Pi 4 (4GB)        €55
HiFiBerry DAC2 Pro          €65
Allo Acrylic Case           €25
iFi iPower 5V               €50
SanDisk Extreme 32GB        €12
───────────────────────────────
Total                      €207
```

Connect to existing amplifier/speakers via RCA.

### Configuration B: Kitchen (All-in-one)

```
Raspberry Pi 4 (2GB)        €45
HiFiBerry Amp2              €55
Passive speakers (pair)     €50
Official Case (modified)    €10
Official PSU 15W            €12
SanDisk Extreme 32GB        €12
───────────────────────────────
Total                      €184
```

Self-contained system, just add power.

### Configuration C: Bedroom (Budget)

```
Raspberry Pi Zero 2 W       €15
USB DAC (generic)           €15
Active speakers (2.0)       €40
Generic case                €5
5V 2A PSU                   €8
SanDisk 16GB                €8
───────────────────────────────
Total                       €91
```

Cheapest functional setup.

### Configuration D: Office (Desktop)

```
Raspberry Pi 4 (2GB)        €45
Topping D10s USB DAC       €100
(connect to existing amp)
Argon ONE case              €25
Official PSU                €10
SanDisk Extreme 32GB        €12
───────────────────────────────
Total                      €192
```

High-quality DAC for critical listening.

## Where to Buy

### Europe

| Store | Country | Notes |
|-------|---------|-------|
| [BerryBase](https://www.berrybase.de) | DE | Large selection |
| [The Pi Hut](https://thepihut.com) | UK | Official reseller |
| [Kubii](https://kubii.com) | FR | Good prices |
| [Melopero](https://melopero.com) | IT | Italian reseller |
| [HiFiBerry](https://hifiberry.com) | CH | Direct |
| [Allo](https://allo.com) | Various | Direct |

### Worldwide

| Store | Notes |
|-------|-------|
| [Amazon](https://amazon.com) | Everything |
| [AliExpress](https://aliexpress.com) | Budget options |
| [Audiophonics](https://audiophonics.fr) | Audiophile gear |
| [Parts Express](https://parts-express.com) | US, speakers |

## Cost Comparison vs Commercial

| System | 3 Rooms | 5 Rooms | Notes |
|--------|---------|---------|-------|
| **SnapForge (budget)** | €150 | €230 | DIY |
| **SnapForge (recommended)** | €400 | €600 | DIY |
| **SnapForge (audiophile)** | €800 | €1200 | DIY |
| Sonos | €600+ | €1000+ | Locked ecosystem |
| Bluesound | €900+ | €1500+ | Better quality |
| Bose SoundTouch | €700+ | €1100+ | Discontinued |

**SnapForge advantage**: Open source, upgradeable, repairable, no subscriptions.
