<!-- markdownlint-disable MD013 MD033 MD041 -->

<p align="center">
  <img src="../../branding/logo.svg" alt="SnapForge" width="80">
</p>

# Guida al Deployment

Questa guida descrive come fare il deployment dell'ecosistema SnapForge a livello alto.

Non e' volutamente un manuale di installazione di prodotto. Il suo scopo e' aiutarti a scegliere una forma di deployment, eseguire il rollout nell'ordine giusto e verificare il risultato senza duplicare le istruzioni di setup che appartengono ai repository di prodotto.

## Scope

Questa guida copre:

- ordine di rollout consigliato
- topologie di deployment piu comuni
- milestone di verifica
- assunzioni di rete e di ambiente
- guidance di produzione a livello ecosistema

Questa guida non sostituisce:

- installazione e configurazione servizi di `snapMULTI`
- setup hardware e provisioning device di `SnapClient Pi`
- packaging e istruzioni runtime specifiche del fork per `Santcasp`

## Source Of Truth

Usa il repository giusto per il lavoro implementativo vero e proprio:

| Esigenza | Source of truth |
| --- | --- |
| Deployment del server | [`snapMULTI`](https://github.com/lollonet/snapMULTI) |
| Deployment endpoint Raspberry Pi | [`SnapClient Pi`](https://github.com/lollonet/snapclient-pi) |
| Deployment del fork/package layer | [`Santcasp`](https://github.com/lollonet/santcasp) |
| Boundary ecosistema e topologia | [Architettura](ARCHITECTURE.md) |

## Ordine di Rollout Consigliato

Fai il deployment in quest'ordine:

1. porta su `snapMULTI`
2. dimostra che almeno una sorgente audio funziona
3. aggiungi un endpoint `SnapClient Pi`
4. verifica il playback end-to-end
5. aggiungi altre stanze solo dopo che una stanza e' stabile
6. stratifica piu avanti client nativi o app di controllo

Questo ordine di rollout e' la regola di deployment piu importante dell'ecosistema. Tiene il troubleshooting locale ed evita failure con troppe variabili insieme.

## Topologie di Deployment

### 1. Deployment open-platform di base

```text
server snapMULTI
    |
    +--> un endpoint di stanza SnapClient Pi
```

Usalo per:

- primo deployment
- validazione della open platform
- troubleshooting iniziale

E' il default piu sicuro.

### 2. Deployment open-platform multi-room

```text
server snapMULTI
    |
    +--> SnapClient Pi stanza 1
    +--> SnapClient Pi stanza 2
    +--> SnapClient Pi stanza 3
```

Usalo solo dopo che il deployment base e' gia stabile.

### 3. Open platform piu layer di controllo nativo

```text
server snapMULTI
    |
    +--> endpoint SnapClient Pi
    +--> SnapClient iOS
    +--> SnapClient Android
    +--> SnapCTRL
```

Usalo quando la open platform e' gia provata e stai espandendo superfici di controllo o tipi di endpoint.

### 4. Consumo diretto di Santcasp

```text
binari Santcasp
    |
    +--> consumati direttamente dove servono artifact del fork/package layer
```

Questo e' valido, ma non e' il percorso di deployment principale di SnapForge per la maggior parte degli utenti.

## Assunzioni di Ambiente

Il modello di deployment assume:

- una rete locale fidata
- connettivita stabile tra server ed endpoint
- service discovery funzionante sulla rete locale, o un fallback manuale documentato
- storage e CPU sufficienti per l'host scelto per `snapMULTI`
- un output audio appropriato all'hardware su ogni device `SnapClient Pi`

Per requisiti hardware e runtime specifici di prodotto, usa i repository owner.

## Prima Milestone di Produzione

Tratta il deployment come riuscito solo quando tutte queste condizioni sono vere:

- `snapMULTI` e' in esecuzione
- il server e' raggiungibile dalla rete locale
- almeno una sorgente audio funziona
- un endpoint `SnapClient Pi` e' online
- il playback end-to-end funziona da server a endpoint
- il sistema si controlla dalla web UI integrata

Non espandere la topologia finche questa milestone non e' solida.

## Flusso di Verifica

Usa questa sequenza dopo ogni step di deployment:

### Verifica del server

Conferma:

- che il server sia su
- che i servizi attesi siano raggiungibili
- che la superficie di controllo risponda
- che almeno un path sorgente funzioni

I comandi dettagliati per questa verifica appartengono a `snapMULTI`.

### Verifica dell'endpoint

Conferma:

- che l'endpoint Raspberry Pi sia online
- che l'output audio selezionato sia valido
- che l'endpoint riesca a collegarsi al server
- che il playback audio funzioni in quella stanza

I comandi dettagliati per questa verifica appartengono a `SnapClient Pi`.

### Verifica dell'espansione

Quando aggiungi altre stanze, conferma:

- che ogni nuovo endpoint entri pulitamente
- che le stanze gia esistenti continuino a comportarsi bene
- che la sincronizzazione resti accettabile
- che le operazioni di controllo restino coerenti

## Guidance di Produzione

### Mantieni la topologia semplice all'inizio

Il percorso di produzione piu sicuro e':

- un server stabile
- un endpoint di stanza validato
- espansione una stanza alla volta

Non trattare il rollout multi-room come il posto in cui scoprire problemi basilari del server o dell'endpoint.

### Mantieni chiari i boundary

Usa `snapforge` per:

- strategia di deployment
- scelte di topologia
- guidance a livello ecosistema

Usa i repository di prodotto per:

- installazione
- configurazione runtime
- comandi di troubleshooting
- fix hardware-specifici

### Mantieni la rete locale e prevedibile

A livello ecosistema, i rischi operativi principali sono:

- Wi-Fi debole o rumoroso
- problemi di discovery
- segmentazione di rete incoerente
- tentativo di esporre troppo superfici di controllo pensate per la LAN

Il sistema va trattato come piattaforma local-network-first.

### Espandi per incrementi controllati

Ogni volta che aggiungi:

- una nuova stanza
- un nuovo tipo di endpoint
- una nuova superficie di controllo
- un nuovo host di deployment

riesegui le stesse milestone di verifica invece di assumere che il resto del sistema resti corretto da solo.

## Boundary di Troubleshooting

Quando qualcosa fallisce, parti classificando dove vive il problema.

| Sintomo | Parti da |
| --- | --- |
| Il server non e' raggiungibile o le sorgenti non funzionano | `snapMULTI` |
| L'endpoint Raspberry Pi non si collega o non riproduce | `SnapClient Pi` |
| Problema di artifact fork/package o divergenza di comportamento dei binari | `Santcasp` |
| Confusione cross-repo su topologia o ownership | `snapforge` |

Questo evita che il repo ecosistema torni a essere un manuale di troubleshooting duplicato.

## Errori Comuni di Deployment

- fare il deployment di piu stanze prima di avere una stanza funzionante end-to-end
- usare `snapforge` come guida installativa canonica
- trattare `Santcasp` come il normale percorso di onboarding
- mischiare architettura ecosistema e setup di prodotto
- provare a risolvere problemi di rete riscrivendo docs invece di verificare i repo owner reali di server ed endpoint

## Cosa Leggere Dopo

| Se vuoi... | Leggi |
| --- | --- |
| Capire boundary e topologia | [Architettura](ARCHITECTURE.md) |
| Instradare correttamente il primo deployment | [Quickstart](../QUICKSTART.md) |
| Fare il deployment del server | [`snapMULTI`](https://github.com/lollonet/snapMULTI) |
| Fare il deployment dell'endpoint Pi | [`SnapClient Pi`](https://github.com/lollonet/snapclient-pi) |
| Lavorare sul fork/package-layer | [`Santcasp`](https://github.com/lollonet/santcasp) |
| Rivedere la pianificazione hardware | [Hardware BOM](HARDWARE-BOM.md) |

## Sintesi

La regola di deployment per SnapForge e' semplice:

- deploy prima `snapMULTI`
- prova un `SnapClient Pi`
- scala solo dopo che la baseline e' stabile
- tieni il dettaglio implementativo nel repo che lo possiede

Questo e' il modo piu pulito di fare il deployment dell'ecosistema senza lasciare che `snapforge` torni a essere un duplicato delle product docs.
