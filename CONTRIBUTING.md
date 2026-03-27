# Contributing to SnapForge / Contribuire a SnapForge

Thank you for your interest in contributing to SnapForge!

Grazie per il tuo interesse a contribuire a SnapForge!

## Project Structure / Struttura del Progetto

SnapForge is an ecosystem of related but independent projects:

SnapForge è un ecosistema di progetti correlati ma indipendenti:

| Repository | Purpose / Scopo |
|------------|-----------------|
| [snapforge](https://github.com/lollonet/snapforge) | Meta-repo, documentation / Meta-repo, documentazione |
| [snapMULTI](https://github.com/lollonet/snapMULTI) | Server component / Componente server |
| [rpi-snapclient-usb](https://github.com/lollonet/rpi-snapclient-usb) | Raspberry Pi client / Client Raspberry Pi |
| [santcasp](https://github.com/lollonet/santcasp) | Snapcast engine binaries / Binari del motore Snapcast |
| snapctrl | Desktop controller (proprietary) / Controller desktop (proprietario) |

## Where to Contribute / Dove Contribuire

### This Repository (snapforge)

- Documentation improvements / Miglioramenti documentazione
- New example configurations / Nuove configurazioni di esempio
- Hardware recommendations / Raccomandazioni hardware
- Translation improvements / Miglioramenti traduzioni

### Component Repositories

For code contributions, please contribute to the specific component repository:

Per contributi di codice, contribuisci al repository del componente specifico:

- **Server issues/features**: [snapMULTI](https://github.com/lollonet/snapMULTI/issues)
- **Client issues/features**: [rpi-snapclient-usb](https://github.com/lollonet/rpi-snapclient-usb/issues)
- **Snapcast engine issues/features**: [santcasp](https://github.com/lollonet/santcasp/issues)

The native apps (SnapClient iOS, SnapClient Android, SnapCTRL) are proprietary and not open for external contributions at this time.

Le app native (SnapClient iOS, SnapClient Android, SnapCTRL) sono proprietarie e non accettano contributi esterni al momento.

## How to Contribute / Come Contribuire

### 1. Report Issues / Segnala Problemi

- Use the issue tracker of the relevant repository
- Include: OS version, hardware details, logs, steps to reproduce

### 2. Suggest Features / Suggerisci Funzionalità

- Open a discussion or issue first
- Describe the use case and expected behavior

### 3. Submit Pull Requests / Invia Pull Request

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make your changes
4. Test your changes
5. Commit with clear messages: `git commit -m "feat: add X feature"`
6. Push to your fork: `git push origin feature/my-feature`
7. Open a Pull Request

### Commit Message Format

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add new feature
fix: fix bug in X
docs: update documentation
chore: update dependencies
refactor: refactor X module
test: add tests for Y
```

## Code Style / Stile del Codice

### Python (snapctrl)

- Follow PEP 8
- Use type hints
- Run `ruff check` and `ruff format` before committing

### Shell Scripts (rpi-snapclient-usb)

- Use `shellcheck` for linting
- Use POSIX-compatible syntax where possible

### Docker (snapMULTI)

- Use `hadolint` for Dockerfile linting
- Prefer Alpine-based images for size

## Testing / Test

Each repository has its own testing requirements. See the README of each project.

Ogni repository ha i propri requisiti di test. Vedi il README di ogni progetto.

## Questions / Domande

- Open a discussion in the relevant repository
- For general ecosystem questions, use this repository's discussions

## Code of Conduct / Codice di Condotta

Be respectful and constructive. We're all here to build something useful together.

Sii rispettoso e costruttivo. Siamo tutti qui per costruire qualcosa di utile insieme.

---

Thank you for contributing! / Grazie per il tuo contributo!
