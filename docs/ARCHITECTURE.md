<!-- markdownlint-disable MD013 MD033 MD041 -->

<p align="center">
  <img src="../branding/logo.svg" alt="SnapForge" width="80">
</p>

# SnapForge Architecture

This document describes the architecture of the SnapForge ecosystem.

It is intentionally an ecosystem document, not a product manual. Its job is to explain roles, boundaries, runtime relationships, and source-of-truth ownership across the stack.

## Scope

This document covers:

- the boundary between upstream `Snapcast`, `Santcasp`, `snapMULTI`, the `SnapClient` family, and `SnapCTRL`
- how the components relate at runtime
- what belongs in `snapforge` versus in the product repositories

This document does not try to replace:

- `snapMULTI` deployment and server internals
- `SnapClient Pi` hardware and install details
- `Santcasp` fork/package implementation details
- product-specific release notes or setup guides

## Ecosystem Layers

SnapForge should be understood as a layered system.

```text
Upstream layer
  Snapcast
      |
      v
Fork / package layer
  Santcasp
      |
      v
Open platform layer
  snapMULTI
  SnapClient Pi
      |
      v
Native client and control layer
  SnapClient iOS
  SnapClient Android
  SnapCTRL
      |
      v
Ecosystem documentation layer
  snapforge
```

The key design rule is simple:

- `Snapcast` is the upstream project.
- `Santcasp` is the SnapForge fork/package layer around Snapcast.
- `snapMULTI` and `SnapClient Pi` are the core open platform products.
- `SnapClient iOS`, `SnapClient Android`, and `SnapCTRL` extend the ecosystem.
- `snapforge` documents how everything fits together, but does not own product internals.

## Component Roles

| Component | Primary role | Owns |
| --- | --- | --- |
| `Snapcast` | Upstream synchronized-audio protocol and reference codebase | Upstream protocol and upstream implementation |
| `Santcasp` | Fork/package layer for Snapcast binaries and fork-specific runtime work | Fork delta, packaging, binary distribution |
| `snapMULTI` | Server product for synchronized playback, sources, and home deployment | Server behavior, sources, deployment model, web UI |
| `SnapClient Pi` | Raspberry Pi endpoint product in the `SnapClient` family | Pi endpoint behavior, HAT/USB DAC support, device UX |
| `SnapClient iOS` | Native endpoint/control client for Apple devices | App behavior, mobile UX, Apple platform integration |
| `SnapClient Android` | Native endpoint/control client for Android devices | App behavior, mobile UX, Android platform integration |
| `SnapCTRL` | Desktop controller for system state, grouping, and volume management | Desktop control UX and desktop platform packaging |
| `snapforge` | Ecosystem map and governance layer | Cross-repo boundaries, positioning, compatibility, roadmap |

## Runtime Relationships

The runtime picture is centered on the open platform.

```text
Audio sources
  MPD / AirPlay / Spotify / Tidal / TCP
                  |
                  v
          snapMULTI (server)
                  |
                  | synchronized Snapcast-compatible streams
                  v
   +--------------+---------------+------------------+
   |                              |                  |
   v                              v                  v
SnapClient Pi                SnapClient iOS    SnapClient Android

Control surfaces:
- snapMULTI web UI
- SnapCTRL desktop controller

Binary / fork foundation:
- Santcasp provides the fork/package layer for snapclient/snapserver binaries
```

In practice:

- `snapMULTI` is the server-side orchestration point.
- `SnapClient Pi` is the room endpoint implementation for Raspberry Pi hardware.
- `SnapClient iOS` and `SnapClient Android` belong to the same client family, but are not Pi-specific.
- `SnapCTRL` is a controller, not a server and not the canonical endpoint implementation.
- `Santcasp` should be treated as an infrastructure layer, not as a user-facing product homepage.

## Source Of Truth Boundaries

Each repository should own only the material that matches its role.

| Repository | What belongs there | What should stay out |
| --- | --- | --- |
| `snapforge` | Ecosystem map, public roadmap, compatibility framing, component boundaries, OSS vs proprietary model | Deep product setup docs, implementation details, hardware-specific procedures |
| `snapMULTI` | Server setup, server internals, service composition, validation and deployment | Broad ecosystem governance, product-family positioning |
| `snapclient-pi` | Pi endpoint setup, hardware matrix, DAC/HAT support, local UX | Ecosystem-level architecture or proprietary app narrative |
| `santcasp` | Fork rationale, fork-specific changes, packaging, release artifacts | Product onboarding for the full SnapForge stack |
| `snapclient-ios` | iOS app behavior and distribution | General ecosystem architecture |
| `snapclient-android` | Android app behavior and distribution | General ecosystem architecture |
| `snapctrl` | Desktop controller behavior and packaging | General ecosystem architecture |

This is the main governance rule behind the repo structure:

- if a page explains one product deeply, it should live in that product repo
- if a page explains how multiple products fit together, it should live in `snapforge`

## Open Platform First

SnapForge should present the open platform first.

That means the primary architectural story is:

1. `snapMULTI` provides the server and source layer
2. `SnapClient Pi` provides the first-class room endpoint
3. `Santcasp` provides the fork/package foundation that supports the runtime stack

The native apps and desktop controller matter, but they are secondary in the architecture story. They extend the ecosystem rather than define its core.

## Deployment Patterns

The ecosystem supports different deployment shapes, but the main patterns are intentionally simple.

### 1. Open platform only

```text
snapMULTI server
    |
    +--> SnapClient Pi endpoints
```

This is the baseline self-hosted setup and the main open-platform story.

### 2. Open platform plus native clients

```text
snapMULTI server
    |
    +--> SnapClient Pi
    +--> SnapClient iOS
    +--> SnapClient Android
    +--> SnapCTRL
```

This adds native control and mobile/desktop endpoints without changing the core ecosystem boundaries.

### 3. Fork/package layer consumed directly

```text
Santcasp binaries
    |
    +--> used by open-platform components
    +--> or consumed independently where needed
```

This is valid, but it is not the primary onboarding story for most users.

## Interface Boundaries

SnapForge components should interact through explicit, stable interfaces.

Examples:

- Snapcast-compatible streaming and control behavior
- documented server endpoints and control surfaces
- documented installation and packaging contracts per repo

The ecosystem should avoid hidden coupling such as:

- undocumented assumptions between repos
- duplicated architecture claims drifting across product docs
- naming that blurs the line between upstream, fork, server, and clients

## Naming Model

The architecture assumes a role-based naming system:

- `SnapForge` is the ecosystem brand
- `snapMULTI` is the server product
- `Santcasp` is the fork/package layer
- `SnapClient <Platform>` is the endpoint family
- `SnapCTRL` is the desktop controller

This naming model is part of the architecture because it reduces conceptual ambiguity across open and proprietary components.

## Documentation Flow

Readers should move through the docs in this order:

1. `README.md` for the ecosystem overview
2. `ARCHITECTURE.md` for boundaries and runtime shape
3. `QUICKSTART.md` to choose the right component path
4. product-repo documentation for implementation and setup detail

## Design Constraints

The ecosystem should continue to optimize for:

- self-hosted operation
- clear separation between ecosystem and product docs
- explicit boundary between upstream `Snapcast` and `Santcasp`
- clear distinction between open platform components and proprietary extensions
- minimal duplication of technical detail across repositories

## Summary

SnapForge is not the runtime center of the system. It is the documentation and coordination layer around a multi-repo ecosystem.

Architecturally, the system works only if these distinctions stay clear:

- upstream `Snapcast` is not the same thing as `Santcasp`
- `Santcasp` is not the same thing as `snapMULTI`
- `snapMULTI` is not the same thing as the `SnapClient` family
- `snapforge` is not the same thing as the product repositories
