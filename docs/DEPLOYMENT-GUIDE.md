<!-- markdownlint-disable MD013 MD033 MD041 -->

<p align="center">
  <img src="../branding/logo.svg" alt="SnapForge" width="80">
</p>

# Deployment Guide

This guide describes how to deploy the SnapForge ecosystem at a high level.

It is intentionally not a product installation manual. Its purpose is to help you choose a deployment shape, roll it out in the right order, and verify success without duplicating the setup instructions that belong in the product repositories.

## Scope

This guide covers:

- recommended deployment order
- common deployment topologies
- verification milestones
- network and environment assumptions
- production-oriented guidance at the ecosystem level

This guide does not replace:

- `snapMULTI` installation and service configuration
- `SnapClient Pi` hardware setup and device provisioning
- `Santcasp` packaging and fork-specific runtime instructions

## Source Of Truth

Use the correct repository for the actual implementation work:

| Need | Source of truth |
| --- | --- |
| Server deployment | [`snapMULTI`](https://github.com/lollonet/snapMULTI) |
| Raspberry Pi endpoint deployment | [`SnapClient Pi`](https://github.com/lollonet/snapclient-pi) |
| Fork/package-layer deployment | [`Santcasp`](https://github.com/lollonet/santcasp) |
| Ecosystem boundaries and topology | [Architecture](ARCHITECTURE.md) |

## Recommended Rollout Order

Deploy in this order:

1. bring up `snapMULTI`
2. prove one working audio source
3. add one `SnapClient Pi` endpoint
4. verify end-to-end playback
5. add more rooms only after one room is stable
6. layer in native clients or controller apps later

This rollout order is the most important deployment rule in the ecosystem. It keeps troubleshooting local and prevents multi-variable failures.

## Deployment Topologies

### 1. Baseline open-platform deployment

```text
snapMULTI server
    |
    +--> one SnapClient Pi room endpoint
```

Use this for:

- first deployment
- validation of the open platform
- early troubleshooting

This is the safest default.

### 2. Multi-room open-platform deployment

```text
snapMULTI server
    |
    +--> SnapClient Pi room 1
    +--> SnapClient Pi room 2
    +--> SnapClient Pi room 3
```

Use this after the baseline deployment is already stable.

### 3. Open platform plus native control layer

```text
snapMULTI server
    |
    +--> SnapClient Pi endpoints
    +--> SnapClient iOS
    +--> SnapClient Android
    +--> SnapCTRL
```

Use this when the open platform is already proven and you are expanding control surfaces or endpoint types.

### 4. Direct Santcasp consumption

```text
Santcasp binaries
    |
    +--> consumed directly where fork/package artifacts are needed
```

This is valid, but it is not the primary SnapForge deployment path for most users.

## Environment Assumptions

The deployment model assumes:

- a trusted local network
- stable local connectivity between server and endpoints
- service discovery that works on the local network, or a documented manual fallback
- enough storage and CPU for the chosen `snapMULTI` host
- hardware-appropriate audio output on each `SnapClient Pi` device

For product-specific hardware and runtime requirements, use the owning repositories.

## First Production Milestone

Treat the deployment as successful only when all of these are true:

- `snapMULTI` is running
- the server is reachable from your local network
- at least one audio source is working
- one `SnapClient Pi` endpoint is online
- end-to-end playback works from server to endpoint
- the system can be controlled from the built-in web UI

Do not expand the topology until this milestone is solid.

## Verification Flow

Use this sequence after each deployment step:

### Server verification

Confirm:

- the server is up
- the expected services are reachable
- the control surface responds
- at least one source path is functional

The detailed commands for that verification belong in `snapMULTI`.

### Endpoint verification

Confirm:

- the Raspberry Pi endpoint is online
- the selected audio output is valid
- the endpoint can connect to the server
- audio playback works in that room

The detailed commands for that verification belong in `SnapClient Pi`.

### Expansion verification

When adding more rooms, confirm:

- each new endpoint joins cleanly
- existing rooms still behave correctly
- synchronization remains acceptable
- control operations still behave consistently

## Production Guidance

### Keep the topology simple first

The safest production path is:

- one stable server
- one validated room endpoint
- expand one room at a time

Do not treat multi-room rollout as the place to discover basic server or endpoint problems.

### Keep boundaries clear

Use `snapforge` for:

- deployment strategy
- topology choices
- ecosystem-level guidance

Use the product repos for:

- installation
- runtime configuration
- troubleshooting commands
- hardware-specific fixes

### Keep the network local and predictable

At the ecosystem level, the main operational risks are:

- weak or noisy Wi-Fi
- discovery issues
- inconsistent network segmentation
- trying to expose local-only control surfaces too broadly

The system is best treated as a local-network-first platform.

### Expand in controlled increments

Each time you add:

- a new room
- a new endpoint type
- a new controller surface
- a new deployment host

re-run the same milestone checks instead of assuming the rest of the system remains correct.

## Troubleshooting Boundaries

When something fails, start by classifying where the failure lives.

| Symptom | Start in |
| --- | --- |
| Server is not reachable or sources do not work | `snapMULTI` |
| Raspberry Pi endpoint does not connect or play | `SnapClient Pi` |
| Fork/package artifact issue or binary behavior divergence | `Santcasp` |
| Cross-repo confusion about topology or ownership | `snapforge` |

This prevents the ecosystem repo from becoming a duplicate troubleshooting manual.

## Common Deployment Mistakes

- deploying multiple rooms before proving one room end to end
- using `snapforge` as the canonical install guide
- treating `Santcasp` as the normal user onboarding path
- mixing ecosystem architecture with product setup steps
- trying to solve network problems with documentation rewrites instead of verifying the actual server and endpoint owners

## What To Read Next

| If you want to... | Read |
| --- | --- |
| Understand boundaries and topology | [Architecture](ARCHITECTURE.md) |
| Route the first deployment correctly | [Quickstart](QUICKSTART.md) |
| Deploy the server | [`snapMULTI`](https://github.com/lollonet/snapMULTI) |
| Deploy the Pi endpoint | [`SnapClient Pi`](https://github.com/lollonet/snapclient-pi) |
| Work on fork/package-layer deployment | [`Santcasp`](https://github.com/lollonet/santcasp) |
| Review hardware planning | [Hardware BOM](HARDWARE-BOM.md) |

## Summary

The deployment rule for SnapForge is straightforward:

- deploy `snapMULTI` first
- prove one `SnapClient Pi`
- scale out only after the baseline is stable
- keep implementation detail in the repo that owns it

That is the cleanest way to deploy the ecosystem without letting `snapforge` drift back into a product-doc duplicate.
