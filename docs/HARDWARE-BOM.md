<!-- markdownlint-disable MD013 MD033 MD041 MD060 -->

<p align="center">
  <img src="../branding/logo.svg" alt="SnapForge" width="80">
</p>

# SnapForge Hardware BOM

This document lists hardware categories and reference assemblies for
SnapForge open-platform deployments.

Prices are indicative street prices in EUR and may vary by market,
availability, shipping, and tax.

## Scope

| Layer | Role | Typical hardware owner |
| --- | --- | --- |
| `snapMULTI` | Server, sources, and service runtime | Linux host, Raspberry Pi, mini PC, or NAS |
| `SnapClient Pi` | Raspberry Pi room endpoint | Raspberry Pi board, audio output module, storage, power |
| `Santcasp` | Fork/package layer | No dedicated hardware requirement in this BOM |

## Procurement Notes

- Verify exact hardware-profile support in the owning product repository
  before purchase.
- For amplifier HATs, confirm the required power-supply voltage and current
  against the board datasheet.
- For USB DACs, confirm Linux kernel support and stable ALSA device
  enumeration.
- Wired networking is optional at BOM level and should be selected according
  to site constraints.

## Server Hosts

| Host class | Example | CPU / RAM | Local storage | Network | Indicative price |
| --- | --- | --- | --- | --- | --- |
| Existing Linux host | Existing PC, NAS, or VM host | Existing hardware | Existing hardware | Existing hardware | 0 |
| Raspberry Pi 4 | 4 GB model | ARM / 4 GB | microSD or SSD | 1 GbE, Wi-Fi | 55-70 |
| Raspberry Pi 5 | 4 GB model | ARM / 4 GB | microSD or SSD | 1 GbE, Wi-Fi | 70-90 |
| Mini PC | Intel NUC, Beelink, HP Mini | x86 / 8 GB+ | SSD | 1 GbE | 150-350 |
| NAS with Docker | Synology, QNAP, similar | NAS-dependent | NAS-dependent | 1 GbE+ | existing hardware |

## Endpoint Core Hardware

| Board | Memory | Ethernet | Wi-Fi | Storage | Indicative price |
| --- | --- | --- | --- | --- | --- |
| Raspberry Pi Zero 2 W | 512 MB | No | Yes | microSD | 15-20 |
| Raspberry Pi 3B+ | 1 GB | 100 MbE | Yes | microSD | 30-40 |
| Raspberry Pi 4 | 2 GB | 1 GbE | Yes | microSD or SSD | 45-55 |
| Raspberry Pi 4 | 4 GB | 1 GbE | Yes | microSD or SSD | 55-65 |
| Raspberry Pi 5 | 4 GB | 1 GbE | Yes | microSD or SSD | 70-90 |

## Audio Output Modules

### I2S DAC HATs

| Model | Output class | Nominal format | Indicative price |
| --- | --- | --- | --- |
| HiFiBerry DAC+ Standard | Analog RCA | 24-bit / 192 kHz | 35-40 |
| HiFiBerry DAC+ Pro | Analog RCA | 24-bit / 192 kHz | 45-50 |
| HiFiBerry DAC2 Pro | Analog RCA | 32-bit / 384 kHz | 60-70 |
| IQaudio DAC+ | Analog RCA | 24-bit / 192 kHz | 35-40 |
| IQaudio DAC Pro | Analog RCA | 24-bit / 192 kHz | 45-55 |
| Allo Boss | Analog RCA | 32-bit / 384 kHz | 60-70 |
| Allo Boss2 | Analog RCA | 32-bit / 768 kHz | 80-90 |
| JustBoom DAC HAT | Analog RCA | 24-bit / 192 kHz | 30-40 |

### Digital Output Boards

| Model | Output | Indicative price |
| --- | --- | --- |
| HiFiBerry Digi+ Standard | Coaxial + optical | 30-35 |
| HiFiBerry Digi2 Pro | Coaxial + optical | 45-50 |
| Allo DigiOne | Coaxial + BNC | 75-85 |
| IQaudio DigiAMP+ | SPDIF + amplifier path | 50-60 |

### Amplifier HATs

| Model | Nominal output | Speaker type | Indicative price |
| --- | --- | --- | --- |
| HiFiBerry Amp2 | 2 x 30 W | Passive speakers | 50-60 |
| IQaudio DigiAMP+ | 2 x 35 W | Passive speakers | 50-60 |
| JustBoom Amp HAT | 2 x 30 W | Passive speakers | 45-55 |
| HiFiBerry Amp3 | 2 x 60 W | Passive speakers | 60-70 |

### USB DACs

| Model | Output class | Indicative price |
| --- | --- | --- |
| Generic USB DAC | Analog / headphone | 10-20 |
| FiiO E10K | Analog / headphone | 70-90 |
| Topping D10s | Analog line-out | 90-110 |
| SMSL M100 | Analog line-out | 70-90 |

## Power, Storage, and Accessories

### Power Supplies

| Model | Use | Nominal output | Indicative price |
| --- | --- | --- | --- |
| Official Raspberry Pi PSU | Raspberry Pi board | 5 V | 10-15 |
| Anker multi-port PSU | Multiple low-power nodes | 5 V | 15-25 |
| iFi iPower 5V | Raspberry Pi board | 5 V | 45-55 |
| Allo Shanti | Dual-rail low-noise supply | 5 V + 5 V | 75-90 |
| Mean Well GST60A | Amplifier HAT deployment | 18 V / 3.3 A | 20-30 |
| iFi iPower X | Amplifier / DAC power | model-dependent | 60-80 |
| Allo Nirvana | Low-noise supply | model-dependent | 90-110 |

### Storage

| Model | Capacity | Use | Indicative price |
| --- | --- | --- | --- |
| SanDisk Extreme | 32 GB | Endpoint boot media | 10-15 |
| Samsung EVO Plus | 64 GB | Endpoint boot media | 12-18 |
| SanDisk Industrial | 16 GB | Endpoint boot media | 18-25 |
| USB SSD | 120-250 GB | Server local storage | 20-40 |

### Network and Enclosures

| Item | Use | Indicative price |
| --- | --- | --- |
| Cat6 patch cable | Wired endpoint uplink | 5-10 |
| 5-port gigabit switch | Small endpoint cluster | 20-30 |
| Official Raspberry Pi case | Standard enclosure | 8-12 |
| Argon ONE | Metal enclosure | 20-30 |
| Flirc case | Passive-cooling enclosure | 15-20 |
| HiFiBerry steel case | HiFiBerry HAT enclosure | 18-25 |
| Generic acrylic case | Generic HAT enclosure | 10-15 |

### Optional Displays

| Model | Resolution / size | Use | Indicative price |
| --- | --- | --- | --- |
| Waveshare 3.5" LCD | 480 x 320 | Compact local display | 20-30 |
| Pimoroni HyperPixel | 800 x 480 | Higher-resolution local display | 45-55 |
| 7" HDMI display | model-dependent | Tabletop display node | 35-50 |

## Reference Assemblies

### Assembly A: Server Only

| Item | Qty | Unit price | Extended price |
| --- | --- | --- | --- |
| Raspberry Pi 4 (4 GB) | 1 | 60 | 60 |
| Official Raspberry Pi PSU | 1 | 12 | 12 |
| microSD 32 GB | 1 | 12 | 12 |
| Case | 1 | 10 | 10 |
| **Total** |  |  | **94** |

### Assembly B: Single Endpoint

| Item | Qty | Unit price | Extended price |
| --- | --- | --- | --- |
| Raspberry Pi 4 (2 GB) | 1 | 50 | 50 |
| HiFiBerry DAC+ Standard | 1 | 38 | 38 |
| Official Raspberry Pi PSU | 1 | 12 | 12 |
| microSD 32 GB | 1 | 12 | 12 |
| HAT-compatible case | 1 | 20 | 20 |
| **Total** |  |  | **132** |

### Assembly C: Open Platform, Three Rooms

| Item | Qty | Unit price | Extended price |
| --- | --- | --- | --- |
| Server host on existing Linux hardware | 1 | 0 | 0 |
| Raspberry Pi 4 (2 GB) | 3 | 50 | 150 |
| HiFiBerry DAC+ Standard | 3 | 38 | 114 |
| Official Raspberry Pi PSU | 3 | 12 | 36 |
| microSD 32 GB | 3 | 12 | 36 |
| HAT-compatible case | 3 | 20 | 60 |
| 5-port gigabit switch | 1 | 25 | 25 |
| **Total** |  |  | **421** |

### Assembly D: Three Amplified Endpoints

| Item | Qty | Unit price | Extended price |
| --- | --- | --- | --- |
| Server host on existing Linux hardware | 1 | 0 | 0 |
| Raspberry Pi 4 (2 GB) | 3 | 50 | 150 |
| HiFiBerry Amp2 | 3 | 55 | 165 |
| 18 V power supply | 3 | 25 | 75 |
| microSD 32 GB | 3 | 12 | 36 |
| Case | 3 | 15 | 45 |
| 5-port gigabit switch | 1 | 25 | 25 |
| **Total** |  |  | **496** |

## Hardware Ownership Boundaries

| Topic | Source of truth |
| --- | --- |
| Server deployment and runtime requirements | `snapMULTI` |
| Raspberry Pi endpoint hardware profiles | `SnapClient Pi` |
| Fork-specific binary packaging | `Santcasp` |
| Ecosystem-level inventory framing | `snapforge` |
