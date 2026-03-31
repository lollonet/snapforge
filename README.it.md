<!-- markdownlint-disable MD013 MD033 MD041 -->

<p align="center">
  <img src="branding/hero.svg" alt="SnapForge — ecosistema audio multiroom self-hosted" width="100%">
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/licenza-MIT-blue.svg" alt="Licenza"></a>
  <a href="docs/QUICKSTART.md"><img src="https://img.shields.io/badge/parti-in%205%20min-brightgreen.svg" alt="Quickstart"></a>
</p>

<p align="center">
  <em><a href="README.md">English</a> | Italiano</em>
</p>

---

> **SnapForge e' un ecosistema audio multiroom self-hosted costruito attorno a una piattaforma open.** Combina server, client endpoint e controller nativi in un sistema coerente, restando esplicito su cosa e' open, cosa e' proprietario e cosa si basa su upstream Snapcast.

## Cos'e SnapForge

`SnapForge` e' il layer ecosistema, non un singolo prodotto.

Il suo compito e' spiegare come i componenti stanno insieme:

- `snapMULTI` e' il prodotto server.
- `SnapClient` e' la famiglia endpoint.
- `Santcasp` e' il fork/package layer di Snapcast.
- `SnapCTRL` e' il controller desktop.

SnapForge non sostituisce upstream `Snapcast`. Documenta e coordina come la piattaforma open e le app companion si incastrano tra loro.

## Piattaforma Open

La piattaforma open e' la storia principale.

| Componente | Ruolo | Source of truth |
| --- | --- | --- |
| [`snapMULTI`](https://github.com/lollonet/snapMULTI) | Server per playback sincronizzato, sorgenti e deployment domestico | repo `snapMULTI` |
| [`SnapClient Pi`](https://github.com/lollonet/snapclient-pi) | Endpoint Raspberry Pi con supporto audio HAT / USB DAC, cover display e playback di stanza | repo `snapclient-pi` |
| [`Santcasp`](https://github.com/lollonet/santcasp) | Fork/package layer Snapcast che fornisce binari prebuilt e runtime work specifico del fork | repo `santcasp` |

## Client Nativi E Controller

Questi estendono l'ecosistema attorno alla piattaforma open.

| Componente | Ruolo | Disponibilita |
| --- | --- | --- |
| `SnapCTRL` | Controller desktop per gruppi, volume, metadati e stato del sistema | La disponibilita varia per piattaforma |
| `SnapClient iOS` | Client endpoint/control nativo per iPhone e iPad | La disponibilita varia per piattaforma |
| `SnapClient Android` | Client endpoint/control nativo per Android | La disponibilita varia per piattaforma |

## Mappa Ecosistema

```text
Sorgenti Audio
  MPD / AirPlay / Spotify / Tidal / TCP
                  |
                  v
          snapMULTI (server)
                  |
                  |  stream Snapcast sincronizzati
                  v
   +--------------+---------------+------------------+
   |                              |                  |
   v                              v                  v
SnapClient Pi                SnapClient iOS    SnapClient Android
   ^
   |
   +---- Santcasp fornisce il fork/package layer per i binari snapclient/snapserver

Superfici di controllo:
- Web UI integrata in snapMULTI
- Controller desktop SnapCTRL
```

## Scegli Il Tuo Percorso

| Se vuoi... | Parti da qui |
| --- | --- |
| Avviare server e sorgenti | [`snapMULTI`](https://github.com/lollonet/snapMULTI) |
| Aggiungere un endpoint Raspberry Pi | [`SnapClient Pi`](https://github.com/lollonet/snapclient-pi) |
| Usare direttamente il fork/package layer | [`Santcasp`](https://github.com/lollonet/santcasp) |
| Capire come l'ecosistema sta insieme | [Architettura](docs/it/ARCHITECTURE.md) |

## Cosa E Open E Cosa No

| Componente | Stato | Licenza / modello |
| --- | --- | --- |
| `snapMULTI` | Open | MIT |
| `SnapClient Pi` | Open | MIT |
| `Santcasp` | Fork open | GPLv3+ |
| `SnapCTRL` | Closed / proprietario | Licensing commerciale separato |
| `SnapClient iOS` | Closed / proprietario | Licensing commerciale separato |
| `SnapClient Android` | Closed / proprietario | Licensing commerciale separato |

## Roadmap Pubblica

Questa roadmap e' volutamente high-level. Serve a mostrare la direzione, non a sostituire una task board o una promessa di release.

### Now

- Stabilizzare naming e boundary dell'ecosistema.
- Tenere accurata e coerente la documentazione della piattaforma open.
- Rafforzare il rapporto tra `snapMULTI`, `SnapClient Pi` e `Santcasp`.

### Next

- Migliorare la visibilita della compatibilita a livello ecosistema.
- Maturare la narrativa della famiglia client tra Pi, iOS e Android.
- Chiarire il posizionamento di controller e app companion.

### Later

- Aggiungere integrazioni piu ampie dove rafforzano la piattaforma open.
- Espandere la comodita dell'ecosistema senza trasformare `snapforge` in un duplicato delle product docs.

## Documentazione

| Documento | Descrizione |
| --- | --- |
| [Quickstart](docs/QUICKSTART.md) | Guida rapida che instrada verso il componente giusto |
| [Architettura](docs/it/ARCHITECTURE.md) | Struttura dell'ecosistema e boundary tra componenti |
| [Deployment Guide](docs/it/DEPLOYMENT-GUIDE.md) | Flusso di deployment e verifica a livello alto |
| [Hardware BOM](docs/it/HARDWARE-BOM.md) | Hardware consigliato e ordine di grandezza dei costi |
| [Contributing](CONTRIBUTING.md) | Dove devono vivere i contributi nell'ecosistema |

## Contribuire

I contributi open-source dovrebbero andare nel repo che possiede il codice:

- [`snapMULTI`](https://github.com/lollonet/snapMULTI/issues) per il lavoro server
- [`snapclient-pi`](https://github.com/lollonet/snapclient-pi/issues) per l'endpoint Raspberry Pi
- [`santcasp`](https://github.com/lollonet/santcasp/issues) per il fork/package layer
- [`snapforge`](https://github.com/lollonet/snapforge/issues) per docs ecosistema, mappe e posizionamento cross-repo

Le app native e `SnapCTRL` non sono aperte a contributi esterni sul codice in questo momento.

## Licenza

I componenti della piattaforma open hanno licenze separate nei rispettivi repository.

- `snapMULTI` e `SnapClient Pi` sono rilasciati sotto MIT.
- `Santcasp` e' un fork Snapcast sotto GPLv3+.
- Le app native e `SnapCTRL` usano licensing proprietario separato.

---

**SnapForge** — ecosistema audio multiroom self-hosted. [github.com/lollonet/snapforge](https://github.com/lollonet/snapforge)
