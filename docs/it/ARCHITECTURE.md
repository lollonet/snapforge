<!-- markdownlint-disable MD013 MD033 MD041 -->

<p align="center">
  <img src="../../branding/logo.svg" alt="SnapForge" width="80">
</p>

# Architettura di SnapForge

Questo documento descrive l'architettura dell'ecosistema SnapForge.

E' volutamente un documento di ecosistema, non un manuale di prodotto. Il suo compito e' spiegare ruoli, boundary, relazioni runtime e source of truth tra i componenti dello stack.

## Scope

Questo documento copre:

- il boundary tra upstream `Snapcast`, `Santcasp`, `snapMULTI`, la famiglia `SnapClient` e `SnapCTRL`
- come i componenti si relazionano a runtime
- cosa appartiene a `snapforge` e cosa appartiene ai repository di prodotto

Questo documento non prova a sostituire:

- il deployment e gli internals server di `snapMULTI`
- i dettagli hardware e di installazione di `SnapClient Pi`
- i dettagli implementativi del fork/package layer `Santcasp`
- le release note o le setup guide specifiche di prodotto

## Layer dell'Ecosistema

SnapForge va letto come un sistema a layer.

```text
Layer upstream
  Snapcast
      |
      v
Layer fork / package
  Santcasp
      |
      v
Layer open platform
  snapMULTI
  SnapClient Pi
      |
      v
Layer client nativi e controllo
  SnapClient iOS
  SnapClient Android
  SnapCTRL
      |
      v
Layer documentazione ecosistema
  snapforge
```

La regola chiave e' semplice:

- `Snapcast` e' il progetto upstream
- `Santcasp` e' il fork/package layer di SnapForge attorno a Snapcast
- `snapMULTI` e `SnapClient Pi` sono i prodotti core della open platform
- `SnapClient iOS`, `SnapClient Android` e `SnapCTRL` estendono l'ecosistema
- `snapforge` documenta come tutto sta insieme, ma non possiede gli internals dei prodotti

## Ruoli dei Componenti

| Componente | Ruolo primario | Possiede |
| --- | --- | --- |
| `Snapcast` | Protocollo audio sincronizzato upstream e codebase di riferimento | Protocollo upstream e implementazione upstream |
| `Santcasp` | Fork/package layer per i binari Snapcast e runtime work specifico del fork | Delta del fork, packaging, distribuzione binari |
| `snapMULTI` | Prodotto server per playback sincronizzato, sorgenti e deployment domestico | Comportamento server, sorgenti, modello di deployment, web UI |
| `SnapClient Pi` | Prodotto endpoint Raspberry Pi nella famiglia `SnapClient` | Comportamento endpoint Pi, supporto HAT/USB DAC, device UX |
| `SnapClient iOS` | Client endpoint/control nativo per dispositivi Apple | Comportamento app, mobile UX, integrazione Apple |
| `SnapClient Android` | Client endpoint/control nativo per Android | Comportamento app, mobile UX, integrazione Android |
| `SnapCTRL` | Controller desktop per stato del sistema, gruppi e volume | UX di controllo desktop e packaging desktop |
| `snapforge` | Mappa ecosistema e layer di governance | Boundary cross-repo, posizionamento, compatibilita, roadmap |

## Relazioni Runtime

La vista runtime e' centrata sulla open platform.

```text
Sorgenti audio
  MPD / AirPlay / Spotify / Tidal / TCP
                  |
                  v
          snapMULTI (server)
                  |
                  | stream compatibili con Snapcast
                  v
   +--------------+---------------+------------------+
   |                              |                  |
   v                              v                  v
SnapClient Pi                SnapClient iOS    SnapClient Android

Superfici di controllo:
- web UI di snapMULTI
- controller desktop SnapCTRL

Fondazione binaria / fork:
- Santcasp fornisce il fork/package layer per i binari snapclient/snapserver
```

In pratica:

- `snapMULTI` e' il punto di orchestrazione lato server
- `SnapClient Pi` e' l'implementazione endpoint di stanza per hardware Raspberry Pi
- `SnapClient iOS` e `SnapClient Android` appartengono alla stessa famiglia client, ma non sono Pi-specifici
- `SnapCTRL` e' un controller, non un server e non l'endpoint canonico
- `Santcasp` va trattato come layer infrastrutturale, non come homepage di prodotto user-facing

## Boundary di Source Of Truth

Ogni repository dovrebbe possedere solo il materiale coerente col proprio ruolo.

| Repository | Cosa deve viverci | Cosa deve restarne fuori |
| --- | --- | --- |
| `snapforge` | Mappa ecosistema, roadmap pubblica, framing di compatibilita, boundary tra componenti, modello OSS vs proprietario | Setup profondi di prodotto, dettagli implementativi, procedure hardware-specifiche |
| `snapMULTI` | Setup server, internals server, composizione servizi, validazione e deployment | Governance ecosistema ampia, posizionamento della product family |
| `snapclient-pi` | Setup endpoint Pi, matrice hardware, supporto DAC/HAT, UX locale | Architettura ecosistema o narrativa delle app proprietarie |
| `santcasp` | Razionale del fork, cambi specifici del fork, packaging, artifact di release | Onboarding del full stack SnapForge |
| `snapclient-ios` | Comportamento e distribuzione app iOS | Architettura generale dell'ecosistema |
| `snapclient-android` | Comportamento e distribuzione app Android | Architettura generale dell'ecosistema |
| `snapctrl` | Comportamento controller desktop e packaging | Architettura generale dell'ecosistema |

Questa e' la regola di governance principale dietro la struttura dei repo:

- se una pagina spiega un prodotto in profondita, deve vivere nel repo di quel prodotto
- se una pagina spiega come piu prodotti stanno insieme, allora deve vivere in `snapforge`

## Open Platform First

SnapForge deve presentare prima di tutto la open platform.

Questo significa che la storia architetturale primaria e':

1. `snapMULTI` fornisce il layer server e sorgenti
2. `SnapClient Pi` fornisce il room endpoint di prima classe
3. `Santcasp` fornisce il foundation layer di fork/package che supporta lo stack runtime

Le app native e il controller desktop contano, ma sono secondari nella narrativa architetturale. Estendono l'ecosistema invece di definirne il core.

## Pattern di Deployment

L'ecosistema supporta forme di deployment diverse, ma i pattern principali restano volutamente semplici.

### 1. Solo open platform

```text
server snapMULTI
    |
    +--> endpoint SnapClient Pi
```

Questo e' il setup self-hosted di base e la storia principale della open platform.

### 2. Open platform piu client nativi

```text
server snapMULTI
    |
    +--> SnapClient Pi
    +--> SnapClient iOS
    +--> SnapClient Android
    +--> SnapCTRL
```

Questo aggiunge controllo nativo ed endpoint mobile/desktop senza cambiare i boundary core dell'ecosistema.

### 3. Consumo diretto del fork/package layer

```text
binari Santcasp
    |
    +--> usati dai componenti open-platform
    +--> oppure consumati direttamente dove serve
```

Questo e' valido, ma non e' il percorso di onboarding principale per la maggior parte degli utenti SnapForge.

## Boundary di Interfaccia

I componenti SnapForge dovrebbero interagire tramite interfacce esplicite e stabili.

Esempi:

- comportamento di streaming e controllo compatibile con Snapcast
- endpoint server e superfici di controllo documentate
- contratti di installazione e packaging documentati per repo

L'ecosistema dovrebbe evitare coupling nascosto come:

- assunzioni non documentate tra repo
- claim architetturali duplicati che driftano nelle product docs
- naming che sfoca il confine tra upstream, fork, server e client

## Modello di Naming

L'architettura assume un sistema di naming role-based:

- `SnapForge` e' il brand ecosistema
- `snapMULTI` e' il prodotto server
- `Santcasp` e' il fork/package layer
- `SnapClient <Platform>` e' la famiglia endpoint
- `SnapCTRL` e' il controller desktop

Questo modello di naming e' parte dell'architettura perché riduce l'ambiguita concettuale tra componenti open e proprietari.

## Flusso della Documentazione

Chi legge dovrebbe muoversi nei docs in quest'ordine:

1. `README.it.md` per la panoramica ecosistema
2. `ARCHITECTURE.md` per boundary e forma runtime
3. `QUICKSTART.md` per scegliere il percorso giusto
4. documentazione dei repo prodotto per setup e dettaglio implementativo

## Vincoli di Design

L'ecosistema dovrebbe continuare a ottimizzare per:

- funzionamento self-hosted
- separazione chiara tra docs ecosistema e docs di prodotto
- boundary esplicito tra upstream `Snapcast` e `Santcasp`
- distinzione netta tra componenti open platform ed estensioni proprietarie
- minima duplicazione del dettaglio tecnico tra repository

## Sintesi

SnapForge non e' il centro runtime del sistema. E' il layer di documentazione e coordinamento attorno a un ecosistema multi-repo.

Architetturalmente, il sistema funziona solo se queste distinzioni restano chiare:

- upstream `Snapcast` non e' la stessa cosa di `Santcasp`
- `Santcasp` non e' la stessa cosa di `snapMULTI`
- `snapMULTI` non e' la stessa cosa della famiglia `SnapClient`
- `snapforge` non e' la stessa cosa dei repository di prodotto
