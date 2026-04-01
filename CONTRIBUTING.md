<!-- markdownlint-disable MD013 -->

# Contributing to SnapForge

SnapForge is a multi-repo ecosystem.

This repository does not own the product code for the whole stack. It owns the ecosystem-level documentation and coordination layer.

If you want the architecture boundaries behind this rule, read [Architecture](docs/ARCHITECTURE.md).
If you want the short admission filter for new content, read [Editorial Policy](docs/EDITORIAL-POLICY.md).

## What This Repository Is For

Contributions to `snapforge` are welcome when they improve:

- ecosystem documentation
- architecture and boundary clarity
- compatibility framing
- roadmap wording
- onboarding and routing docs
- translations
- cross-repo maps and positioning

This repository is the right place when the change explains how the ecosystem fits together.

## What Does Not Belong Here

Do not use `snapforge` for deep product changes that belong in the owning repository, such as:

- server implementation changes
- Raspberry Pi endpoint setup fixes
- fork/package-layer implementation changes
- mobile app implementation changes
- desktop controller implementation changes

If a contribution is mostly about one product, it should go to that product repository instead.

## Where To Contribute

| If your change is about... | Go here |
| --- | --- |
| Ecosystem docs, maps, and cross-repo positioning | [`snapforge`](https://github.com/lollonet/snapforge) |
| Server behavior, deployment, or source integration | [`snapMULTI`](https://github.com/lollonet/snapMULTI) |
| Raspberry Pi endpoint behavior, hardware support, or device UX | [`snapclient-pi`](https://github.com/lollonet/snapclient-pi) |
| Snapcast fork, packaging, or binary distribution | [`santcasp`](https://github.com/lollonet/santcasp) |

The following components are currently not open for external code contributions:

- `SnapCTRL`
- `SnapClient iOS`
- `SnapClient Android`

## Before You Open A Pull Request

Please make sure the change really belongs in `snapforge`.

Good reasons to open a PR here:

- you found a wrong ecosystem boundary
- the docs route users to the wrong repository
- the public roadmap wording is misleading
- the architecture docs drifted from the real repo model
- the content passes the editorial filter in [Editorial Policy](docs/EDITORIAL-POLICY.md)
- an English or Italian translation needs correction

Weak reasons to open a PR here:

- you want to patch product behavior from the ecosystem repo
- you want to add product-specific troubleshooting that belongs elsewhere
- you want `snapforge` to duplicate the setup steps from another repo

## Contribution Flow

1. Open an issue first if the change affects architecture, positioning, repo boundaries, or public roadmap wording.
2. Fork the repository and create a focused branch.
3. Keep the patch minimal and specific to the ecosystem-docs layer.
4. Update both English and Italian docs when the change affects both surfaces.
5. Run the relevant checks before opening the PR.

## Pull Request Expectations

A good PR to `snapforge` should:

- stay within the scope of this repository
- improve clarity instead of adding noise
- avoid duplicating product documentation
- keep naming and boundaries consistent across docs
- explain why the change belongs in `snapforge`

If a PR is correct but belongs in another repository, the expected outcome is redirection, not merge.

## Style

Keep documentation:

- direct
- technically accurate
- explicit about ownership and boundaries
- consistent with the current naming model

Current naming model:

- `SnapForge` = ecosystem brand
- `snapMULTI` = server product
- `Santcasp` = fork/package layer
- `SnapClient <Platform>` = endpoint family
- `SnapCTRL` = desktop controller

## Checks

At minimum:

- verify links you changed
- run Markdown lint on the files you touched
- read the surrounding document so the change stays consistent

Do not assume `snapforge` is the place to invent new product-level rules for other repositories.

## Questions

Use `snapforge` issues when the question is about:

- ecosystem boundaries
- cross-repo confusion
- naming consistency
- roadmap phrasing
- documentation ownership

Use the product repository when the question is about that product's behavior or setup.

## Italian Summary

`snapforge` e' il repo giusto per:

- documentazione di ecosistema
- mappe cross-repo
- chiarimenti su boundary e ownership
- naming e posizionamento
- traduzioni

`snapforge` non e' il repo giusto per:

- fix implementativi di `snapMULTI`
- setup hardware o runtime di `SnapClient Pi`
- modifiche al fork/package layer `Santcasp`
- codice delle app proprietarie

Se una modifica spiega un prodotto in profondita, deve vivere nel repo di quel prodotto.
Se una modifica spiega come i prodotti stanno insieme, allora appartiene a `snapforge`.
