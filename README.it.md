<p align="center">
  <img src="branding/hero.svg" alt="SnapForge — Audio multiroom self-hosted" width="100%">
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

> **Audio multiroom self-hosted.** Streaming della tua musica in ogni stanza in perfetto sync — dalla tua libreria, AirPlay, Spotify o qualsiasi sorgente. Gira sull'hardware che gia' possiedi.

## L'Ecosistema

### Piattaforma Open — gratuita e self-hosted

| Componente | Cosa fa | Repository |
|------------|---------|------------|
| **snapMULTI** | Server — sorgenti Spotify, AirPlay, Tidal, MPD e TCP in Docker | [snapMULTI](https://github.com/lollonet/snapMULTI) |
| **rpi-snapclient-usb** | Altoparlante — endpoint audio Raspberry Pi con 11 opzioni di DAC HAT | [rpi-snapclient-usb](https://github.com/lollonet/rpi-snapclient-usb) |
| **santcasp** | Engine — binari Snapcast precompilati per Linux, macOS e Windows | [santcasp](https://github.com/lollonet/santcasp) |

### App Native — disponibili presto

| App | Cosa fa | Disponibilita' |
|-----|---------|----------------|
| **SnapClient iOS** | iPhone e iPad — riproduzione sincronizzata, controllo server, in riproduzione | App Store — disponibile presto |
| **SnapClient Android** | Android — riproduzione sincronizzata, controllo server, UI Material 3 | Play Store — disponibile presto |
| **SnapCTRL** | Controller desktop — volume, gruppi, copertine · gratuito su Linux, a pagamento su macOS/Windows | Mac App Store e Microsoft Store — disponibile presto |

## Architettura

```
                    ┌─────────────────────────────────────────┐
                    │          SORGENTI AUDIO                 │
                    │  MPD │ AirPlay │ Spotify │ Tidal │ TCP  │
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

              ┌─────────────────────────────────────────────────┐
              │         App SnapForge (disponibili presto)      │
              │  ┌───────────────────┐  ┌──────────────────┐   │
              │  │  SnapClient iOS   │  │SnapClient Android│   │
              │  │  iPhone · iPad    │  │  Dispositivo Android│ │
              │  └───────────────────┘  └──────────────────┘   │
              └─────────────────────────────────────────────────┘

                    ┌─────────────────────────────────────────┐
                    │      SnapCTRL (disponibile presto)      │
                    │  Controller desktop — gruppi, volume    │
                    │  gratuito su Linux · a pagamento su macOS/Windows │
                    └─────────────────────────────────────────┘
```

## Funzionalita'

### Piattaforma Open

- **[snapMULTI](https://github.com/lollonet/snapMULTI)** — server audio con Spotify (librespot), AirPlay (shairport-sync), Tidal, MPD e sorgenti TCP; basato su Docker; autodiscovery mDNS
- **[rpi-snapclient-usb](https://github.com/lollonet/rpi-snapclient-usb)** — endpoint audio Raspberry Pi; 11 profili HAT audio, visualizzazione copertine, analizzatore spettro, installazione zero-touch
- **[santcasp](https://github.com/lollonet/santcasp)** — pacchetti snapclient/snapserver precompilati per Ubuntu, Debian, macOS e Windows

### App Native (disponibili presto)

- **SnapClient iOS** — riproduzione audio sincronizzata per iPhone e iPad; controllo completo del server dalla tasca
- **SnapClient Android** — riproduzione audio sincronizzata per Android; UI Material 3 con copertine e controllo gruppi
- **SnapCTRL** — controller desktop per macOS, Windows e Linux; gruppi, volume, copertine, in riproduzione; **gratuito su Linux**

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

# 3. Controllo — apri l'interfaccia web integrata
open http://<server-ip>:1780   # volume, gruppi, selezione stream in qualsiasi browser
```

I client trovano il server automaticamente via mDNS. Nessun indirizzo IP da configurare.

> **SnapCTRL** (app desktop nativa) e **SnapClient iOS/Android** (mobile) sono disponibili presto — vedi [App Native](#app-native--disponibili-presto) sopra.

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
Costruisci un multiroom di grado audiofilo a una frazione del costo delle soluzioni commerciali.

## Confronto

| Funzionalita' | SnapForge | Chromecast Audio | AirPlay 2 | Sistemi commerciali |
|---------------|-----------|------------------|-----------|---------------------|
| Open Source | ✅ | ❌ | ❌ | ❌ |
| Self-hosted | ✅ | ❌ | ❌ | ❌ |
| Hardware agnostico | ✅ | ❌ | ❌ | ❌ |
| Precisione sync | <1ms | ~30ms | ~50ms | ~30ms |
| Costo per stanza | ~€50 | Discontinuato | €100+ | €200+ |
| Solo rete locale | ✅ | ❌ (cloud) | ✅ | ❌ (cloud) |

## Roadmap

- [ ] SnapClient iOS — lancio su App Store
- [ ] SnapClient Android — lancio su Play Store
- [ ] SnapCTRL — lancio su Mac App Store e Microsoft Store
- [ ] Controller web-based (integrazione snapweb)
- [ ] Integrazione Home Assistant
- [ ] Immagini Raspberry Pi pre-configurate

## Contribuire

I componenti della piattaforma open accettano contributi — ognuno ha il proprio repository e le proprie linee guida:

- [Issue snapMULTI](https://github.com/lollonet/snapMULTI/issues) — server e sorgenti audio
- [Issue rpi-snapclient-usb](https://github.com/lollonet/rpi-snapclient-usb/issues) — client Raspberry Pi
- [Issue santcasp](https://github.com/lollonet/santcasp/issues) — binari del motore Snapcast

Le app native (SnapClient iOS, SnapClient Android, SnapCTRL) sono proprietarie e non accettano contributi esterni al momento.

Per discussioni sull'intero ecosistema, apri una issue in questo repository o visita il [project board](https://github.com/users/lollonet/projects/3).

## Licenza

I componenti della piattaforma open (snapMULTI, rpi-snapclient-usb) sono rilasciati sotto Licenza MIT — vedi [LICENSE](LICENSE) per i dettagli.

[santcasp](https://github.com/lollonet/santcasp) e' un fork di [Snapcast](https://github.com/badaix/snapcast) ed e' rilasciato sotto Licenza GPLv3+.

Le app native (SnapClient iOS, SnapClient Android, SnapCTRL) sono software proprietario con licenze commerciali separate.

---

**SnapForge** — audio multiroom self-hosted. [github.com/lollonet/snapforge](https://github.com/lollonet/snapforge)
