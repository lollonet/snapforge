<!-- markdownlint-disable MD013 MD033 MD041 -->

<p align="center">
  <img src="../../branding/logo.svg" alt="SnapForge" width="80">
</p>

# Compatibilita SnapForge

Questo documento fornisce una vista di compatibilita a livello ecosistema per
SnapForge.

Serve a rispondere a tre domande:

- quali componenti fanno parte dell'ecosistema
- come si relazionano tra loro
- dove vive la source of truth per ciascun tema di compatibilita

Non sostituisce la documentazione di prodotto, le release notes o le guide di
setup.

## Scope

| Incluso qui | Fuori scope |
| --- | --- |
| Ruoli dei componenti | Procedure di setup a livello prodotto |
| Boundary di ecosistema | Passi di troubleshooting |
| Dipendenze cross-repo | Matrici dettagliate versione per versione |
| Modello di supporto e source of truth | Dettagli implementativi dei profili hardware |

## Matrice Componenti

| Componente | Ruolo | Modello | Stato | Source of truth | Nota di boundary |
| --- | --- | --- | --- | --- | --- |
| `snapMULTI` | Runtime server e sorgenti | Open | Active | repo `snapMULTI` | Possiede deployment server e comportamento dei servizi |
| `SnapClient Pi` | Endpoint Raspberry Pi | Open | Active | repo `snapclient-pi` | Possiede profili hardware Pi ed endpoint UX |
| `Santcasp` | Fork/package layer di Snapcast | Open | Active | repo `santcasp` | Possiede razionale del fork, packaging e distribuzione binari |
| `SnapCTRL` | Controller desktop | Closed | Planned / evolving | Product owner | Non appartiene alle docs implementative di `snapforge` |
| `SnapClient iOS` | Client mobile endpoint/control | Closed | Planned / evolving | Product owner | Layer companion, non source of truth del server |
| `SnapClient Android` | Client mobile endpoint/control | Closed | Planned / evolving | Product owner | Layer companion, non source of truth del server |

## Matrice Relazioni

| Da | A | Relazione | Scope di compatibilita |
| --- | --- | --- | --- |
| `snapMULTI` | `Santcasp` | Il runtime server dipende da binari e comportamento Snapcast-compatible | Compatibilita di runtime e packaging |
| `SnapClient Pi` | `snapMULTI` | L'endpoint consuma playback sincronizzato e superfici di controllo del server | Compatibilita playback e control path |
| `SnapClient Pi` | `Santcasp` | Il comportamento endpoint dipende da aspettative client/runtime Snapcast-compatible | Compatibilita stream e protocollo |
| `SnapCTRL` | `snapMULTI` | Il controller consuma interfacce di controllo e stato lato server | Compatibilita control surface |
| `SnapClient iOS` | `snapMULTI` | Il client mobile dipende da comportamento endpoint/control compatibile lato server | Compatibilita endpoint e controllo |
| `SnapClient Android` | `snapMULTI` | Il client mobile dipende da comportamento endpoint/control compatibile lato server | Compatibilita endpoint e controllo |

## Modello di Supporto

| Tema | Source of truth |
| --- | --- |
| Deployment server, sorgenti e comportamento runtime | `snapMULTI` |
| Setup endpoint Raspberry Pi e supporto hardware | `SnapClient Pi` |
| Delta del fork Snapcast, packaging e artifact binari | `Santcasp` |
| Framing ecosistema, boundary tra repo e ownership del supporto | `snapforge` |
| Comportamento dei prodotti desktop e mobile proprietari | Product owner / superficie specifica di prodotto |

## Scope della Compatibilita

In questo repository, `compatibile` significa:

- i ruoli dei componenti sono coerenti
- il percorso di integrazione atteso e' definito
- i boundary di ownership sono espliciti
- la narrativa ecosistema non contraddice la documentazione dei repo prodotto

In questo repository, `compatibile` non significa:

- feature parity garantita tra tutte le superfici client
- changelog completo di protocollo o API
- promessa che tutte le superfici proprietarie siano rilasciate o mantenute
  con la stessa cadenza
- sostituzione del testing di prodotto e della validazione di release

## Trigger di Aggiornamento

Aggiorna questa matrice quando cambia uno di questi elementi:

- naming dei componenti
- ruolo dei componenti
- modello open vs closed
- boundary di ownership
- forma delle dipendenze cross-repo
- posizione della source of truth

Non aggiornare questa matrice per:

- fix di prodotto ordinari
- refactor implementativi interni
- aggiunte hardware che restano completamente possedute da un singolo repo
  prodotto
- cambi di release cadence che non modificano i boundary di ecosistema

## Sintesi

Questa pagina esiste per mantenere stabile il modello ecosistema:

- `snapMULTI` possiede il server
- `SnapClient Pi` possiede l'endpoint Raspberry Pi
- `Santcasp` possiede il fork/package layer
- `snapforge` possiede il framing di compatibilita e i boundary cross-repo
