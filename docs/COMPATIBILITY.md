<!-- markdownlint-disable MD013 MD033 MD041 -->

<p align="center">
  <img src="../branding/logo.svg" alt="SnapForge" width="80">
</p>

# SnapForge Compatibility

This document provides an ecosystem-level compatibility view for SnapForge.

It is intended to answer three questions:

- which components are part of the ecosystem
- how the components relate to each other
- where the source of truth lives for each compatibility topic

It does not replace product-level documentation, release notes, or setup
guides.

## Scope

| Included here | Out of scope |
| --- | --- |
| Component roles | Product-level setup procedures |
| Ecosystem boundaries | Troubleshooting steps |
| Cross-repo dependencies | Detailed version-by-version support matrices |
| Support model and source of truth | Hardware-profile implementation details |

## Component Matrix

| Component | Role | Model | Status | Source of truth | Boundary note |
| --- | --- | --- | --- | --- | --- |
| `snapMULTI` | Server and source runtime | Open | Active | `snapMULTI` repo | Owns server deployment and service behavior |
| `SnapClient Pi` | Raspberry Pi endpoint | Open | Active | `snapclient-pi` repo | Owns Pi hardware profiles and endpoint UX |
| `Santcasp` | Snapcast fork/package layer | Open | Active | `santcasp` repo | Owns fork rationale, packaging, and binary distribution |
| `SnapCTRL` | Desktop controller | Closed | Planned / evolving | Product owner | Does not belong in `snapforge` implementation docs |
| `SnapClient iOS` | Mobile endpoint/control client | Closed | Planned / evolving | Product owner | Companion layer, not the server source of truth |
| `SnapClient Android` | Mobile endpoint/control client | Closed | Planned / evolving | Product owner | Companion layer, not the server source of truth |

## Relationship Matrix

| From | To | Relationship | Compatibility scope |
| --- | --- | --- | --- |
| `snapMULTI` | `Santcasp` | Server-side runtime depends on Snapcast-compatible binaries and behavior | Runtime and packaging compatibility |
| `SnapClient Pi` | `snapMULTI` | Endpoint consumes synchronized playback and control surfaces from the server | Playback and control-path compatibility |
| `SnapClient Pi` | `Santcasp` | Endpoint behavior depends on Snapcast-compatible client/runtime expectations | Stream and protocol compatibility |
| `SnapCTRL` | `snapMULTI` | Controller consumes server-side control/state interfaces | Control-surface compatibility |
| `SnapClient iOS` | `snapMULTI` | Mobile client depends on compatible endpoint/control behavior from the server | Endpoint and control compatibility |
| `SnapClient Android` | `snapMULTI` | Mobile client depends on compatible endpoint/control behavior from the server | Endpoint and control compatibility |

## Support Model

| Topic | Source of truth |
| --- | --- |
| Server deployment, sources, and runtime behavior | `snapMULTI` |
| Raspberry Pi endpoint setup and hardware support | `SnapClient Pi` |
| Snapcast fork delta, packaging, and binary artifacts | `Santcasp` |
| Ecosystem framing, repo boundaries, and support ownership | `snapforge` |
| Proprietary mobile and desktop product behavior | Product owner / product-specific surface |

## Compatibility Scope

In this repository, `compatible` means:

- the component roles are consistent
- the intended integration path is defined
- ownership boundaries are explicit
- the ecosystem narrative does not contradict product-repo documentation

In this repository, `compatible` does not mean:

- guaranteed feature parity across every client surface
- a complete protocol or API changelog
- a promise that every proprietary surface is released or maintained at the
  same cadence
- substitution for product-level testing and release validation

## Change Triggers

Update this matrix when one of these changes:

- component naming
- component role
- open vs closed model
- ownership boundary
- cross-repo dependency shape
- source-of-truth location

Do not update this matrix for:

- routine product fixes
- internal implementation refactors
- hardware additions that remain fully owned by one product repo
- release cadence changes that do not affect ecosystem boundaries

## Summary

This page exists to keep the ecosystem model stable:

- `snapMULTI` owns the server
- `SnapClient Pi` owns the Raspberry Pi endpoint
- `Santcasp` owns the fork/package layer
- `snapforge` owns the compatibility framing and cross-repo boundaries
