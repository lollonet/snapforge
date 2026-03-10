<p align="center">
  <img src="../../branding/logo.svg" alt="SnapForge" width="80">
</p>

# Guida Hardware SnapForge

Bill of Materials e raccomandazioni hardware per costruire un sistema audio multiroom SnapForge.

## Riferimento Rapido: Setup Consigliati

### Setup Economico (~€150 totali)

| Componente | Modello | Prezzo | Note |
|------------|---------|--------|------|
| Server | Qualsiasi PC Linux/NAS | €0 | Usa hardware esistente |
| Client x3 | Raspberry Pi Zero 2 W | €15 cad. | Solo WiFi |
| DAC x3 | DAC USB (generico) | €15 cad. | Qualità base |
| **Totale** | | **~€90** | 3 stanze |

### Setup Raccomandato (~€400 totali)

| Componente | Modello | Prezzo | Note |
|------------|---------|--------|------|
| Server | Raspberry Pi 4 (4GB) | €60 | Server dedicato |
| Client x3 | Raspberry Pi 4 (2GB) | €45 cad. | Affidabile |
| DAC x3 | HiFiBerry DAC+ Standard | €35 cad. | Buona qualità |
| Case x3 | Case ufficiale RPi | €10 cad. | Look pulito |
| **Totale** | | **~€390** | 3 stanze |

### Setup Audiofilo (~€800 totali)

| Componente | Modello | Prezzo | Note |
|------------|---------|--------|------|
| Server | Intel NUC / Mini PC | €200 | Per librerie grandi |
| Client x3 | Raspberry Pi 4 (4GB) | €55 cad. | Margine |
| DAC x3 | HiFiBerry DAC2 Pro | €65 cad. | Qualità eccellente |
| Case x3 | Allo Acrilico | €25 cad. | Look premium |
| Alim. lineare x3 | iFi iPower | €50 cad. | Meno rumore |
| **Totale** | | **~€785** | 3 stanze, grado audiofilo |

## Hardware Server

### Opzione 1: Raspberry Pi (1-5 client)

| Modello | RAM | Prezzo | Adatto Per |
|---------|-----|--------|------------|
| Pi 4 Model B (2GB) | 2GB | €45 | 1-3 client |
| Pi 4 Model B (4GB) | 4GB | €55 | 3-5 client |
| Pi 5 (4GB) | 4GB | €70 | 5+ client, più veloce |

**Pro**: Basso consumo, silenzioso, economico
**Contro**: Limitato per librerie musicali grandi

### Opzione 2: Mini PC (5-15 client)

| Modello | Specifiche | Prezzo | Note |
|---------|------------|--------|------|
| Intel NUC 12 | i3, 8GB, 256GB | €300 | Compatto, potente |
| Beelink Mini S | N5095, 8GB | €150 | Opzione economica |
| HP ProDesk Mini | i5, 8GB | €120 | Usato/ricondizionato |

**Pro**: Più potenza, può fare anche da NAS
**Contro**: Consumo energetico maggiore

### Opzione 3: NAS/Server Esistente

Se hai un Synology, QNAP o altro NAS, puoi eseguire snapMULTI direttamente in Docker.

**Requisiti:**
- Supporto Docker
- 1GB+ RAM libera
- Rete Gigabit

## Hardware Client

### Modelli Raspberry Pi

| Modello | Prezzo | WiFi | Ethernet | Raccomandato |
|---------|--------|------|----------|--------------|
| Pi Zero 2 W | €15 | Sì | No | Budget, solo WiFi |
| Pi 3B+ | €35 | Sì | 100Mbps | Buon equilibrio |
| Pi 4 (2GB) | €45 | Sì | Gigabit | **Raccomandato** |
| Pi 4 (4GB) | €55 | Sì | Gigabit | A prova di futuro |
| Pi 5 (4GB) | €70 | Sì | Gigabit | Eccessivo per audio |

**Raccomandazione**: Raspberry Pi 4 (2GB) offre il miglior rapporto qualità/prezzo per client audio.

### SBC Alternative

| Scheda | Prezzo | Note |
|--------|--------|------|
| Orange Pi Zero 2 | €25 | Economico, funziona |
| ODROID-C4 | €50 | Buon supporto audio |
| Rock Pi 4 | €60 | Alternativa a RPi 4 |

## DAC Audio

### HAT I2S (Migliore Qualità)

| Modello | Prezzo | Bit/kHz | THD+N | Note |
|---------|--------|---------|-------|------|
| **HiFiBerry DAC+ Standard** | €35 | 24/192 | -93dB | **Miglior valore** |
| HiFiBerry DAC+ Pro | €45 | 24/192 | -100dB | Clock migliorato |
| HiFiBerry DAC2 Pro | €65 | 32/384 | -112dB | Audiofilo |
| IQaudio DAC+ | €35 | 24/192 | -96dB | Buona alternativa |
| IQaudio DAC Pro | €50 | 24/192 | -102dB | Uscita RCA |
| Allo Boss | €65 | 32/384 | -112dB | Eccellente |
| Allo Boss2 | €85 | 32/768 | -120dB | Top di gamma |
| JustBoom DAC HAT | €35 | 24/192 | -94dB | Economico |

**Raccomandazione**: HiFiBerry DAC+ Standard per la maggior parte degli utenti. DAC2 Pro o Allo Boss per audiofili.

### Uscita Digitale (S/PDIF)

Per connessione a DAC esterni:

| Modello | Prezzo | Uscita | Note |
|---------|--------|--------|------|
| HiFiBerry Digi+ Standard | €30 | Coax + Ottico | Buono |
| HiFiBerry Digi2 Pro | €45 | Coax + Ottico | Clock migliore |
| Allo DigiOne | €80 | Coax + BNC | Audiofilo |
| IQaudio DigiAMP+ | €55 | + Amplificatore | All-in-one |

### DAC USB

Per semplicità o quando I2S non è disponibile:

| Modello | Prezzo | Qualità | Note |
|---------|--------|---------|------|
| DAC USB generico | €10-20 | Base | Funziona |
| FiiO E10K | €80 | Buona | Anche amplificatore cuffie |
| Topping D10s | €100 | Eccellente | Re delle misurazioni |
| SMSL M100 | €80 | Molto buona | Compatto |

### HAT Amplificatore

Soluzioni all-in-one con amplificazione integrata:

| Modello | Prezzo | Potenza | Diffusori |
|---------|--------|---------|-----------|
| HiFiBerry Amp2 | €55 | 2x30W | Passivi |
| IQaudio DigiAMP+ | €55 | 2x35W | Passivi |
| JustBoom Amp HAT | €50 | 2x30W | Passivi |
| HiFiBerry Amp3 | €65 | 2x60W | Passivi |

**Caso d'uso**: Cucina, bagno, laboratorio dove vuoi diffusori passivi semplici.

## Alimentatori

### Standard (5V per RPi)

| Tipo | Prezzo | Note |
|------|--------|------|
| Alimentatore ufficiale RPi | €10 | Adeguato |
| Anker PowerPort | €15 | Multi-dispositivo |
| iFi iPower 5V | €50 | Basso rumore, audiofilo |
| Allo Shanti | €80 | Doppio rail, eccellente |

**Raccomandazione**: Alimentatore ufficiale va bene per la maggior parte. iFi iPower per setup esigenti.

### Per HAT Amplificatore (Potenza Maggiore)

| Modello | Prezzo | Output | Note |
|---------|--------|--------|------|
| Mean Well GST60A | €25 | 18V/3.3A | Economico |
| iFi iPower X | €70 | Vari | Basso rumore |
| Allo Nirvana | €100 | 5V+5V | Audiofilo |

## Case

### Funzionali

| Modello | Prezzo | Note |
|---------|--------|------|
| Case ufficiale RPi | €8 | Base |
| Argon ONE | €25 | Alluminio, raffreddamento passivo |
| Flirc Case | €15 | Raffreddamento passivo |

### Con Supporto HAT

| Modello | Prezzo | Compatibilità |
|---------|--------|---------------|
| HiFiBerry Steel Case | €20 | HAT HiFiBerry |
| Allo Acrylic Case | €25 | DAC Allo |
| Acrilico generico | €10 | La maggior parte degli HAT |

### Premium

| Modello | Prezzo | Note |
|---------|--------|------|
| Allo USBridge Sig. | €250 | Soluzione completa |
| Pro-Ject Stream Box | €400 | Qualità commerciale |

## Accessori

### Schede SD

| Modello | Dimensione | Prezzo | Note |
|---------|------------|--------|------|
| SanDisk Extreme | 32GB | €12 | **Raccomandato** |
| Samsung EVO Plus | 64GB | €15 | Buona durata |
| SanDisk Industrial | 16GB | €20 | Massima affidabilità |

### Rete

| Articolo | Prezzo | Note |
|----------|--------|------|
| Cavo Cat6 | €5/5m | Per client cablati |
| Switch TP-Link | €20 | Gigabit 5 porte |
| Bridge Ethernet-WiFi | €30 | Per punti difficili da cablare |

### Display (Opzionale)

Per visualizzazione copertine album:

| Modello | Prezzo | Dimensione | Note |
|---------|--------|------------|------|
| Waveshare 3.5" LCD | €25 | 480x320 | Base |
| Pimoroni HyperPixel | €50 | 800x480 | Alta qualità |
| Display HDMI mini | €40 | 7" | Per tavolo |

## Configurazioni di Esempio

### Configurazione A: Soggiorno (Hi-Fi)

```
Raspberry Pi 4 (4GB)        €55
HiFiBerry DAC2 Pro          €65
Allo Acrylic Case           €25
iFi iPower 5V               €50
SanDisk Extreme 32GB        €12
───────────────────────────────
Totale                     €207
```

Connetti all'amplificatore/diffusori esistenti via RCA.

### Configurazione B: Cucina (All-in-one)

```
Raspberry Pi 4 (2GB)        €45
HiFiBerry Amp2              €55
Diffusori passivi (coppia)  €50
Case ufficiale (modificato) €10
Alimentatore ufficiale 15W  €12
SanDisk Extreme 32GB        €12
───────────────────────────────
Totale                     €184
```

Sistema autocontenuto, basta aggiungere corrente.

### Configurazione C: Camera da Letto (Economica)

```
Raspberry Pi Zero 2 W       €15
DAC USB (generico)          €15
Casse attive (2.0)          €40
Case generico               €5
Alimentatore 5V 2A          €8
SanDisk 16GB                €8
───────────────────────────────
Totale                      €91
```

Setup funzionale più economico.

### Configurazione D: Studio/Ufficio (Desktop)

```
Raspberry Pi 4 (2GB)        €45
Topping D10s DAC USB       €100
(connetti ad amplificatore esistente)
Argon ONE case              €25
Alimentatore ufficiale      €10
SanDisk Extreme 32GB        €12
───────────────────────────────
Totale                     €192
```

DAC di alta qualità per ascolto critico.

## Dove Comprare

### Europa

| Negozio | Paese | Note |
|---------|-------|------|
| [BerryBase](https://www.berrybase.de) | DE | Ampia selezione |
| [The Pi Hut](https://thepihut.com) | UK | Rivenditore ufficiale |
| [Kubii](https://kubii.com) | FR | Buoni prezzi |
| [Melopero](https://melopero.com) | IT | Rivenditore italiano |
| [HiFiBerry](https://hifiberry.com) | CH | Diretto |
| [Allo](https://allo.com) | Vari | Diretto |

### Mondo

| Negozio | Note |
|---------|------|
| [Amazon](https://amazon.it) | Tutto |
| [AliExpress](https://aliexpress.com) | Opzioni economiche |
| [Audiophonics](https://audiophonics.fr) | Gear audiofilo |

## Confronto Costi vs Commerciale

| Sistema | 3 Stanze | 5 Stanze | Note |
|---------|----------|----------|------|
| **SnapForge (economico)** | €150 | €230 | DIY |
| **SnapForge (raccomandato)** | €400 | €600 | DIY |
| **SnapForge (audiofilo)** | €800 | €1200 | DIY |
| Sistemi commerciali | €600+ | €1000+ | Ecosistema chiuso |
| Bluesound | €900+ | €1500+ | Qualità migliore |
| Bose SoundTouch | €700+ | €1100+ | Discontinuato |

**Vantaggio SnapForge**: Open source, aggiornabile, riparabile, nessun abbonamento.
