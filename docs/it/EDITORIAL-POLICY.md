<!-- markdownlint-disable MD013 MD033 MD041 -->

<p align="center">
  <img src="../../branding/logo.svg" alt="SnapForge" width="80">
</p>

# Policy Editoriale SnapForge

Questa pagina e' il filtro di ammissione per i nuovi contenuti in `snapforge`.

## Regola Centrale

Se un documento spiega in profondita un solo prodotto, non appartiene qui.

Se un documento spiega come piu parti dell'ecosistema stanno insieme, allora puo appartenere qui.

## Tieni Qui Il Contenuto Solo Se

- spiega piu di un repo
- definisce boundary di ecosistema o ownership
- migliora la chiarezza su routing o compatibilita cross-repo
- documenta naming, topologia o framing open-vs-closed
- resta utile anche se i repo prodotto continuano a evolvere in autonomia

## Sposta Altrove Il Contenuto Se

- e' una guida di setup di un solo prodotto
- e' dettaglio implementativo posseduto da un solo repo
- duplica una source of truth che esiste gia altrove
- invecchia rapidamente se non e' mantenuto insieme al codice prodotto
- e' materiale speculativo senza un ruolo chiaro nell'ecosistema

## Checklist Per I Maintainer

Prima di far entrare contenuto in `snapforge`, chiediti:

1. Questo spiega piu di un repo?
2. Aumenta davvero la chiarezza dell'ecosistema?
3. La source of truth esiste gia altrove?
4. Diventa stantio se resta fuori dal repo che lo possiede?
5. Questo e' davvero narrative di ecosistema, o e' product truth?

Se la risposta fallisce su gran parte di queste domande, il contenuto non dovrebbe entrare in `snapforge`.

## Promemoria di Scope

`snapforge` dovrebbe restare focalizzato su:

- landing e orientamento
- architettura e boundary
- framing della compatibilita
- routing cross-repo
- linguaggio roadmap ad alto livello

Non dovrebbe tornare a essere:

- manuale di prodotto
- dump di troubleshooting
- contenitore di asset di prodotto incorporati
- raccolta di note di ricerca senza valore ecosistema
- contenitore di presentation material salvo che faccia davvero parte della superficie pubblica dell'ecosistema

## Collegamenti

- [Architettura](ARCHITECTURE.md)
- [Compatibilita](COMPATIBILITY.md)
- [Contributing](../../CONTRIBUTING.md)
