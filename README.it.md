<p align="center">
  <img src="branding/hero.svg" alt="SnapForge — L'alternativa open-source a Sonos" width="100%">
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/licenza-MIT-blue.svg" alt="Licenza"></a>
  <a href="https://github.com/users/lollonet/projects/3"><img src="https://img.shields.io/badge/project-board-orange.svg" alt="Project Board"></a>
  <a href="docs/QUICKSTART.md"><img src="https://img.shields.io/badge/parti-in%205%20min-brightgreen.svg" alt="Quickstart"></a>
</p>

<p align="center">
  <em><a href="README.md">English</a> | Italiano</em>
</p>

---

> **L'alternativa open-source a Sonos.** Streaming della musica dalla tua libreria, AirPlay o qualsiasi sorgente verso ogni stanza in perfetto sync. Gira su hardware Raspberry Pi che gia' possiedi.

## L'Ecosistema

| Componente | Cosa fa | Repository |
|------------|---------|------------|
| **snapMULTI** | Server — sorgenti audio MPD, AirPlay e TCP in Docker | [snapMULTI](https://github.com/lollonet/snapMULTI) |
| **rpi-snapclient-usb** | Client — trasforma un Raspberry Pi in un altoparlante (11 DAC HAT) | [rpi-snapclient-usb](https://github.com/lollonet/rpi-snapclient-usb) |
| **SnapCTRL** | Controller — app desktop per volume, gruppi, in riproduzione (Qt6) | [snapctrl](https://github.com/lollonet/snapctrl) |
| **santcasp** | Engine — fork di Snapcast mantenuto da SnapForge | [santcasp](https://github.com/lollonet/santcasp) |

## Architettura

```
                    ┌─────────────────────────────────────────┐
                    │          SORGENTI AUDIO                 │
                    │  MPD │ AirPlay │ Stream TCP │ Spotify   │
                    └──────────────────┬──────────────────────┘
                                       │
                                       ▼
                    ┌─────────────────────────────────────────┐
                    │         snapMULTI (Server)              │
                    │  Snapserver + MPD + Shairport-sync      │
                    │  Docker │ autodiscovery mDNS            │
                    └──────────────────┬──────────────────────┘
                                       │
              ┌────────────────────────┼────────────────────────┐
              │                        │                        │
              ▼                        ▼                        ▼
    ┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
    │ rpi-snapclient  │      │ rpi-snapclient  │      │ rpi-snapclient  │
    │ Soggiorno       │      │ Camera          │      │ Cucina          │
    │ HiFiBerry DAC+  │      │ IQaudio DigiAMP │      │ DAC USB         │
    └─────────────────┘      └─────────────────┘      └─────────────────┘

                    ┌─────────────────────────────────────────┐
                    │            SnapCTRL                     │
                    │  App desktop per volume, gruppi,        │
                    │  selezione stream (Windows/Mac/Linux)   │
                    └─────────────────────────────────────────┘
```

## Funzionalita'

### Server (snapMULTI)
- Tre sorgenti audio: MPD (libreria locale), AirPlay, input TCP
- Deployment basato su Docker con networking host
- Autodiscovery mDNS/Avahi
- Streaming FLAC a 48kHz/16bit

### Client (rpi-snapclient-usb)
- Supporto per 11 HAT audio (HiFiBerry, IQaudio, Allo, JustBoom, USB)
- Servizio visualizzazione copertine album
- Script di setup automatizzato
- Installazione Docker o nativa

### Controller (SnapCTRL)
- Applicazione desktop Qt6 nativa
- Controllo in tempo reale via JSON-RPC
- Controllo volume gruppi e client
- Selezione sorgente stream

## Quick Start

**[Guida quickstart completa (5 minuti)](docs/QUICKSTART.md)** — da zero a musica in ogni stanza.

```bash
# 1. Server (qualsiasi macchina Linux)
git clone https://github.com/lollonet/snapMULTI.git && cd snapMULTI
cp .env.example .env          # modifica i percorsi della tua musica
docker compose up -d           # server attivo

# 2. Client (ogni Raspberry Pi)
git clone https://github.com/lollonet/rpi-snapclient-usb.git && cd rpi-snapclient-usb
./scripts/setup.sh             # scegli il DAC, imposta il nome stanza, fatto

# 3. Controller (il tuo laptop)
git clone https://github.com/lollonet/snapctrl.git && cd snapctrl
uv pip install -e . && python -m snapctrl
```

I client trovano il server automaticamente via mDNS. Nessun indirizzo IP da configurare.

## Documentazione

### Italiano

| Documento | Descrizione |
|-----------|-------------|
| [Architettura](docs/it/ARCHITECTURE.md) | Design del sistema e interazione componenti |
| [Guida al Deployment](docs/it/DEPLOYMENT-GUIDE.md) | Istruzioni di setup passo-passo |
| [BOM Hardware](docs/it/HARDWARE-BOM.md) | Hardware consigliato e costi |

### English

| Document | Description |
|----------|-------------|
| **[5-Minute Quickstart](docs/QUICKSTART.md)** | **Get running fast — start here** |
| [Architecture](docs/ARCHITECTURE.md) | System design and component interaction |
| [Deployment Guide](docs/DEPLOYMENT-GUIDE.md) | Full setup with verification and troubleshooting |
| [Hardware BOM](docs/HARDWARE-BOM.md) | Recommended hardware and costs |

## Casi d'Uso

### Audio Domestico
Streaming della tua libreria musicale in ogni stanza. Controlla tutto dal telefono (app MPD) o desktop (SnapCTRL).

### Modalita' Festa
Una sorgente, sync perfetto su tutti i diffusori. Niente piu' eco da una stanza all'altra.

### Musica di Sottofondo per Business
Ristoranti, uffici, negozi — audio sincronizzato con controllo per zone.

### Hi-Fi DIY
Costruisci un multiroom di grado audiofilo a una frazione delle soluzioni commerciali (Sonos, HEOS, BluOS).

## Confronto

| Funzionalita' | SnapForge | Sonos | Chromecast Audio | AirPlay 2 |
|---------------|-----------|-------|------------------|-----------|
| Open Source | ✅ | ❌ | ❌ | ❌ |
| Self-hosted | ✅ | ❌ | ❌ | ❌ |
| Hardware agnostico | ✅ | ❌ | ❌ | ❌ |
| Precisione sync | <1ms | ~30ms | ~30ms | ~50ms |
| Costo per stanza | ~€50 | ~€200+ | Discontinuato | €100+ |
| Solo rete locale | ✅ | ❌ (cloud) | ❌ (cloud) | ✅ |

## Roadmap

- [ ] Controller web-based (integrazione snapweb)
- [ ] Integrazione Home Assistant
- [ ] Sorgente Spotify Connect
- [ ] Immagini Raspberry Pi pre-configurate
- [ ] Opzioni di supporto commerciale

## Contribuire

Ogni componente ha il proprio repository con linee guida per i contributi. Inizia con il componente che vuoi migliorare:

- [Issue snapMULTI](https://github.com/lollonet/snapMULTI/issues) — server e sorgenti audio
- [Issue rpi-snapclient-usb](https://github.com/lollonet/rpi-snapclient-usb/issues) — client Raspberry Pi
- [Issue snapctrl](https://github.com/lollonet/snapctrl/issues) — controller desktop
- [Issue santcasp](https://github.com/lollonet/santcasp/issues) — fork del motore Snapcast

Per discussioni sull'intero ecosistema, apri una issue in questo repository o visita il [project board](https://github.com/users/lollonet/projects/3).

## Licenza

Licenza MIT — vedi [LICENSE](LICENSE) per i dettagli.

Tutti i componenti di SnapForge sono rilasciati sotto Licenza MIT.

---

**SnapForge** fa parte dell'ecosistema software [Forge](https://github.com/lollonet).
