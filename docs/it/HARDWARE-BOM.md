<!-- markdownlint-disable MD013 MD033 MD041 MD060 -->

<p align="center">
  <img src="../../branding/logo.svg" alt="SnapForge" width="80">
</p>

# SnapForge Hardware BOM

Questo documento elenca categorie hardware e assembly di riferimento per
deployment della open platform SnapForge.

I prezzi sono indicativi, espressi in EUR, e possono variare in base a
mercato, disponibilita, spedizione e imposte.

## Scope

| Layer | Ruolo | Owner hardware tipico |
| --- | --- | --- |
| `snapMULTI` | Server, sorgenti e runtime dei servizi | Host Linux, Raspberry Pi, mini PC o NAS |
| `SnapClient Pi` | Endpoint di stanza Raspberry Pi | Board Raspberry Pi, modulo audio, storage, alimentazione |
| `Santcasp` | Fork/package layer | Nessun requisito hardware dedicato in questo BOM |

## Note di Acquisto

- Verificare il supporto esatto del profilo hardware nel repository owner
  del prodotto prima dell'acquisto.
- Per gli amplifier HAT, confermare tensione e corrente richieste rispetto
  alla scheda tecnica del board.
- Per i DAC USB, confermare supporto Linux kernel e enumerazione ALSA
  stabile.
- Il networking cablato e' opzionale a livello BOM e va scelto in base ai
  vincoli del sito.

## Host Server

| Classe host | Esempio | CPU / RAM | Storage locale | Rete | Prezzo indicativo |
| --- | --- | --- | --- | --- | --- |
| Host Linux esistente | PC, NAS o VM host gia presente | hardware esistente | hardware esistente | hardware esistente | 0 |
| Raspberry Pi 4 | modello 4 GB | ARM / 4 GB | microSD o SSD | 1 GbE, Wi-Fi | 55-70 |
| Raspberry Pi 5 | modello 4 GB | ARM / 4 GB | microSD o SSD | 1 GbE, Wi-Fi | 70-90 |
| Mini PC | Intel NUC, Beelink, HP Mini | x86 / 8 GB+ | SSD | 1 GbE | 150-350 |
| NAS con Docker | Synology, QNAP, simili | dipende dal NAS | dipende dal NAS | 1 GbE+ | hardware esistente |

## Hardware Core Endpoint

| Board | Memoria | Ethernet | Wi-Fi | Storage | Prezzo indicativo |
| --- | --- | --- | --- | --- | --- |
| Raspberry Pi Zero 2 W | 512 MB | No | Si | microSD | 15-20 |
| Raspberry Pi 3B+ | 1 GB | 100 MbE | Si | microSD | 30-40 |
| Raspberry Pi 4 | 2 GB | 1 GbE | Si | microSD o SSD | 45-55 |
| Raspberry Pi 4 | 4 GB | 1 GbE | Si | microSD o SSD | 55-65 |
| Raspberry Pi 5 | 4 GB | 1 GbE | Si | microSD o SSD | 70-90 |

## Moduli di Uscita Audio

### DAC HAT I2S

| Modello | Classe output | Formato nominale | Prezzo indicativo |
| --- | --- | --- | --- |
| HiFiBerry DAC+ Standard | Analogico RCA | 24-bit / 192 kHz | 35-40 |
| HiFiBerry DAC+ Pro | Analogico RCA | 24-bit / 192 kHz | 45-50 |
| HiFiBerry DAC2 Pro | Analogico RCA | 32-bit / 384 kHz | 60-70 |
| IQaudio DAC+ | Analogico RCA | 24-bit / 192 kHz | 35-40 |
| IQaudio DAC Pro | Analogico RCA | 24-bit / 192 kHz | 45-55 |
| Allo Boss | Analogico RCA | 32-bit / 384 kHz | 60-70 |
| Allo Boss2 | Analogico RCA | 32-bit / 768 kHz | 80-90 |
| JustBoom DAC HAT | Analogico RCA | 24-bit / 192 kHz | 30-40 |

### Schede di Uscita Digitale

| Modello | Uscita | Prezzo indicativo |
| --- | --- | --- |
| HiFiBerry Digi+ Standard | Coassiale + ottica | 30-35 |
| HiFiBerry Digi2 Pro | Coassiale + ottica | 45-50 |
| Allo DigiOne | Coassiale + BNC | 75-85 |
| IQaudio DigiAMP+ | SPDIF + percorso amplificato | 50-60 |

### Amplifier HAT

| Modello | Output nominale | Tipo diffusori | Prezzo indicativo |
| --- | --- | --- | --- |
| HiFiBerry Amp2 | 2 x 30 W | Diffusori passivi | 50-60 |
| IQaudio DigiAMP+ | 2 x 35 W | Diffusori passivi | 50-60 |
| JustBoom Amp HAT | 2 x 30 W | Diffusori passivi | 45-55 |
| HiFiBerry Amp3 | 2 x 60 W | Diffusori passivi | 60-70 |

### DAC USB

| Modello | Classe output | Prezzo indicativo |
| --- | --- | --- |
| DAC USB generico | Analogico / cuffie | 10-20 |
| FiiO E10K | Analogico / cuffie | 70-90 |
| Topping D10s | Line-out analogico | 90-110 |
| SMSL M100 | Line-out analogico | 70-90 |

## Alimentazione, Storage e Accessori

### Alimentatori

| Modello | Uso | Output nominale | Prezzo indicativo |
| --- | --- | --- | --- |
| Alimentatore ufficiale Raspberry Pi | Board Raspberry Pi | 5 V | 10-15 |
| Alimentatore multi-porta Anker | Piu nodi a basso assorbimento | 5 V | 15-25 |
| iFi iPower 5V | Board Raspberry Pi | 5 V | 45-55 |
| Allo Shanti | Doppia rail low-noise | 5 V + 5 V | 75-90 |
| Mean Well GST60A | Deployment con amplifier HAT | 18 V / 3.3 A | 20-30 |
| iFi iPower X | Alimentazione amplifier / DAC | dipende dal modello | 60-80 |
| Allo Nirvana | Alimentazione low-noise | dipende dal modello | 90-110 |

### Storage

| Modello | Capacita | Uso | Prezzo indicativo |
| --- | --- | --- | --- |
| SanDisk Extreme | 32 GB | Boot media endpoint | 10-15 |
| Samsung EVO Plus | 64 GB | Boot media endpoint | 12-18 |
| SanDisk Industrial | 16 GB | Boot media endpoint | 18-25 |
| SSD USB | 120-250 GB | Storage locale server | 20-40 |

### Rete e Case

| Item | Uso | Prezzo indicativo |
| --- | --- | --- |
| Cavo patch Cat6 | Uplink endpoint cablato | 5-10 |
| Switch gigabit 5 porte | Piccolo cluster endpoint | 20-30 |
| Case ufficiale Raspberry Pi | Enclosure standard | 8-12 |
| Argon ONE | Enclosure metallico | 20-30 |
| Flirc case | Enclosure passivo | 15-20 |
| HiFiBerry steel case | Enclosure per HAT HiFiBerry | 18-25 |
| Case acrilico generico | Enclosure HAT generico | 10-15 |

### Display Opzionali

| Modello | Risoluzione / dimensione | Uso | Prezzo indicativo |
| --- | --- | --- | --- |
| Waveshare 3.5" LCD | 480 x 320 | Display locale compatto | 20-30 |
| Pimoroni HyperPixel | 800 x 480 | Display locale a risoluzione maggiore | 45-55 |
| Display HDMI 7" | dipende dal modello | Nodo tabletop con display | 35-50 |

## Assembly di Riferimento

### Assembly A: Solo Server

| Item | Qta | Prezzo unitario | Prezzo esteso |
| --- | --- | --- | --- |
| Raspberry Pi 4 (4 GB) | 1 | 60 | 60 |
| Alimentatore ufficiale Raspberry Pi | 1 | 12 | 12 |
| microSD 32 GB | 1 | 12 | 12 |
| Case | 1 | 10 | 10 |
| **Totale** |  |  | **94** |

### Assembly B: Endpoint Singolo

| Item | Qta | Prezzo unitario | Prezzo esteso |
| --- | --- | --- | --- |
| Raspberry Pi 4 (2 GB) | 1 | 50 | 50 |
| HiFiBerry DAC+ Standard | 1 | 38 | 38 |
| Alimentatore ufficiale Raspberry Pi | 1 | 12 | 12 |
| microSD 32 GB | 1 | 12 | 12 |
| Case compatibile con HAT | 1 | 20 | 20 |
| **Totale** |  |  | **132** |

### Assembly C: Open Platform, Tre Stanze

| Item | Qta | Prezzo unitario | Prezzo esteso |
| --- | --- | --- | --- |
| Host server su hardware Linux esistente | 1 | 0 | 0 |
| Raspberry Pi 4 (2 GB) | 3 | 50 | 150 |
| HiFiBerry DAC+ Standard | 3 | 38 | 114 |
| Alimentatore ufficiale Raspberry Pi | 3 | 12 | 36 |
| microSD 32 GB | 3 | 12 | 36 |
| Case compatibile con HAT | 3 | 20 | 60 |
| Switch gigabit 5 porte | 1 | 25 | 25 |
| **Totale** |  |  | **421** |

### Assembly D: Tre Endpoint Amplificati

| Item | Qta | Prezzo unitario | Prezzo esteso |
| --- | --- | --- | --- |
| Host server su hardware Linux esistente | 1 | 0 | 0 |
| Raspberry Pi 4 (2 GB) | 3 | 50 | 150 |
| HiFiBerry Amp2 | 3 | 55 | 165 |
| Alimentatore 18 V | 3 | 25 | 75 |
| microSD 32 GB | 3 | 12 | 36 |
| Case | 3 | 15 | 45 |
| Switch gigabit 5 porte | 1 | 25 | 25 |
| **Totale** |  |  | **496** |

## Boundary di Ownership Hardware

| Tema | Source of truth |
| --- | --- |
| Deployment server e requisiti runtime | `snapMULTI` |
| Profili hardware endpoint Raspberry Pi | `SnapClient Pi` |
| Packaging binari specifico del fork | `Santcasp` |
| Framing inventariale a livello ecosistema | `snapforge` |
