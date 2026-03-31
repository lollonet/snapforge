<!-- markdownlint-disable MD013 MD033 MD041 -->

<p align="center">
  <img src="../branding/logo.svg" alt="SnapForge" width="80">
</p>

# Quickstart

> Start with the right component, not with the whole ecosystem at once.

This guide is intentionally short. Its job is to route you to the correct repository and get you to a working first step without duplicating product-specific setup instructions.

If you want the ecosystem overview first, read [README.md](../README.md).
If you want boundaries and runtime relationships first, read [Architecture](ARCHITECTURE.md).

## Choose Your Starting Point

| If you want to... | Start here | Why |
| --- | --- | --- |
| Run the server and audio sources | [`snapMULTI`](https://github.com/lollonet/snapMULTI) | This is the server product and the canonical setup path |
| Add a Raspberry Pi room endpoint | [`SnapClient Pi`](https://github.com/lollonet/snapclient-pi) | This is the Pi endpoint product and the canonical hardware path |
| Use the Snapcast fork/package layer directly | [`Santcasp`](https://github.com/lollonet/santcasp) | This owns the fork rationale, packaging, and binary distribution |
| Understand how everything fits together | [Architecture](ARCHITECTURE.md) | This explains the ecosystem boundaries and runtime roles |

## Recommended First Setup

For most people, the best first experience is:

1. start with `snapMULTI`
2. confirm the server is running and reachable
3. add one `SnapClient Pi` room endpoint
4. only then expand to more rooms, native clients, or controller apps

This keeps the first install small and makes failures easier to diagnose.

## Fastest Path To First Sound

### Path A: Server first

Use this if your priority is to get the core system online.

Go to:

- [`snapMULTI`](https://github.com/lollonet/snapMULTI)

Follow the server setup there until you have:

- a running server
- a reachable web UI
- at least one working audio source

Stop here if you are only validating the server side.

### Path B: Add one room endpoint

Use this once the server is alive.

Go to:

- [`SnapClient Pi`](https://github.com/lollonet/snapclient-pi)

Follow the Pi client setup there until you have:

- one Raspberry Pi endpoint online
- one verified audio output path
- successful playback from the server to that room

Do not try to optimize for multiple rooms before one room works end to end.

### Path C: Work directly with the fork/package layer

Use this only if you specifically need the Snapcast fork/package layer itself.

Go to:

- [`Santcasp`](https://github.com/lollonet/santcasp)

This path is for:

- binary packaging
- fork-specific runtime work
- direct consumption of fork artifacts

It is not the recommended first path for typical SnapForge users.

## What A Successful First Milestone Looks Like

Your first milestone is complete when all of these are true:

- `snapMULTI` is running
- the server is reachable on your local network
- one endpoint can connect and play audio
- you can control the system from the web UI

At that point, the open platform is working. Everything else is an extension of that baseline.

## Native Clients And Controller

The ecosystem also includes:

- `SnapCTRL`
- `SnapClient iOS`
- `SnapClient Android`

These belong to the broader SnapForge client/control family, but they are not required for the first successful deployment of the open platform.

Treat them as second-step components after the server and one room endpoint are working.

## Common Mistakes To Avoid

- starting with multiple rooms instead of proving one room first
- treating `snapforge` as the source of truth for product setup
- treating `Santcasp` as the main onboarding path for normal users
- mixing ecosystem docs with product docs when troubleshooting

## Where To Go Next

| If you want to... | Read |
| --- | --- |
| Understand the ecosystem boundaries | [Architecture](ARCHITECTURE.md) |
| See the ecosystem overview again | [README.md](../README.md) |
| Set up the server | [`snapMULTI`](https://github.com/lollonet/snapMULTI) |
| Set up the Raspberry Pi endpoint | [`SnapClient Pi`](https://github.com/lollonet/snapclient-pi) |
| Work on the fork/package layer | [`Santcasp`](https://github.com/lollonet/santcasp) |
| Review recommended hardware | [Hardware BOM](HARDWARE-BOM.md) |
| See higher-level deployment guidance | [Deployment Guide](DEPLOYMENT-GUIDE.md) |

## Summary

The quickstart rule is simple:

- start with `snapMULTI`
- prove one `SnapClient Pi`
- expand only after the open-platform baseline works

That keeps the SnapForge onboarding path clear, consistent, and aligned with the real source of truth for each component.
