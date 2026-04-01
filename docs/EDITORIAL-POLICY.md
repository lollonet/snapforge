<!-- markdownlint-disable MD013 MD033 MD041 -->

<p align="center">
  <img src="../branding/logo.svg" alt="SnapForge" width="80">
</p>

# SnapForge Editorial Policy

This page is the admission filter for new content in `snapforge`.

## Core Rule

If a document explains one product deeply, it does not belong here.

If a document explains how multiple parts of the ecosystem fit together, it may belong here.

## Keep Content Here Only If

- it explains more than one repo
- it defines ecosystem boundaries or ownership
- it improves cross-repo routing or compatibility clarity
- it documents naming, topology, or open-vs-closed framing
- it remains useful even if product repos continue to evolve independently

## Move Content Elsewhere If

- it is a setup guide for one product
- it is implementation detail owned by one repo
- it duplicates a source of truth that already exists elsewhere
- it will go stale unless maintained with product code
- it is speculative material with no clear ecosystem role

## Maintainer Checklist

Before merging content into `snapforge`, ask:

1. Does this explain more than one repo?
2. Does it increase ecosystem clarity?
3. Is the source of truth already elsewhere?
4. Would it become stale outside the owning repo?
5. Is this really ecosystem narrative rather than product truth?

If the answer fails on most of these, the content should not land in `snapforge`.

## Scope Reminder

`snapforge` should stay focused on:

- landing and orientation
- architecture and boundaries
- compatibility framing
- cross-repo routing
- high-level roadmap language

It should not drift back into:

- product manuals
- troubleshooting dumps
- embedded product assets
- research notes without ecosystem value
- presentation material unless it is truly part of the public ecosystem surface

## Related

- [Architecture](ARCHITECTURE.md)
- [Compatibility](COMPATIBILITY.md)
- [Contributing](../CONTRIBUTING.md)
