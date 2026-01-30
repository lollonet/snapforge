# Setup GitHub Project - Prompt per Claude Code

Copia questo prompt in Claude Code per creare il GitHub Project:

---

## Prompt

```
Crea un GitHub Project per l'ecosistema SnapForge con questa configurazione:

## Setup Project

1. Crea un Project (new style, non classic) chiamato "SnapForge Ecosystem"
   - Owner: lollonet
   - Visibility: Public
   - Description: "Roadmap and issue tracking for the SnapForge multiroom audio ecosystem"

2. Linka questi 4 repository al project:
   - lollonet/snapforge
   - lollonet/snapMULTI
   - lollonet/rpi-snapclient-usb
   - lollonet/snapctrl

## Custom Fields da creare

| Field | Type | Options |
|-------|------|---------|
| Component | Single select | snapMULTI, rpi-snapclient, SnapCTRL, snapforge-docs, ecosystem |
| Priority | Single select | P0-Critical, P1-High, P2-Medium, P3-Low |
| Type | Single select | bug, feature, docs, question, enhancement |
| Effort | Single select | XS (1h), S (half-day), M (1-2 days), L (week), XL (multi-week) |

## Views da creare

1. **Kanban** (default):
   - Columns: Triage, Backlog, In Progress, Review, Done
   - Group by: Status

2. **By Component**:
   - Table view
   - Group by: Component field

3. **Roadmap**:
   - Roadmap view
   - Date field: Target date (crea questo field se non esiste)

## Automations

1. Quando una issue viene aggiunta al project → Status = "Triage"
2. Quando una PR viene merged → Status = "Done"
3. Quando una issue viene chiusa → Status = "Done"

## Issue Templates

Crea in ogni repo (.github/ISSUE_TEMPLATE/):

### bug_report.yml

```yaml
name: Bug Report
description: Report a bug or unexpected behavior
title: "[Bug]: "
labels: ["bug"]
body:
  - type: markdown
    attributes:
      value: |
        Thanks for reporting a bug! Please fill out the information below.
  - type: textarea
    id: description
    attributes:
      label: Description
      description: A clear description of the bug
    validations:
      required: true
  - type: textarea
    id: steps
    attributes:
      label: Steps to Reproduce
      description: How can we reproduce this issue?
      placeholder: |
        1. Go to '...'
        2. Click on '...'
        3. See error
    validations:
      required: true
  - type: textarea
    id: expected
    attributes:
      label: Expected Behavior
      description: What did you expect to happen?
    validations:
      required: true
  - type: textarea
    id: environment
    attributes:
      label: Environment
      description: Please provide your environment details
      placeholder: |
        - OS: [e.g., Raspberry Pi OS 64-bit]
        - Hardware: [e.g., Pi 4 4GB + HiFiBerry DAC+]
        - Version: [e.g., v1.0.0]
    validations:
      required: true
  - type: textarea
    id: logs
    attributes:
      label: Relevant Logs
      description: Please paste any relevant log output
      render: shell
```

### feature_request.yml

```yaml
name: Feature Request
description: Suggest a new feature or enhancement
title: "[Feature]: "
labels: ["enhancement"]
body:
  - type: markdown
    attributes:
      value: |
        Thanks for suggesting a feature! Please describe your idea below.
  - type: textarea
    id: problem
    attributes:
      label: Problem or Use Case
      description: What problem does this solve? What's your use case?
    validations:
      required: true
  - type: textarea
    id: solution
    attributes:
      label: Proposed Solution
      description: How would you like this to work?
    validations:
      required: true
  - type: textarea
    id: alternatives
    attributes:
      label: Alternatives Considered
      description: Any alternative solutions you've considered?
  - type: dropdown
    id: component
    attributes:
      label: Component
      description: Which component does this affect?
      options:
        - snapMULTI (server)
        - rpi-snapclient (client)
        - SnapCTRL (desktop app)
        - Documentation
        - Ecosystem-wide
    validations:
      required: true
```

## Labels standard (da creare in tutti e 4 i repo)

| Label | Color | Description |
|-------|-------|-------------|
| bug | d73a4a | Something isn't working |
| enhancement | a2eeef | New feature or request |
| documentation | 0075ca | Documentation improvements |
| good first issue | 7057ff | Good for newcomers |
| help wanted | 008672 | Extra attention needed |
| question | d876e3 | Further information requested |
| wontfix | ffffff | This will not be worked on |
| duplicate | cfd3d7 | This issue already exists |
| priority:critical | b60205 | Must fix immediately |
| priority:high | d93f0b | Important |
| priority:medium | fbca04 | Normal priority |
| priority:low | 0e8a16 | Nice to have |
| component:server | 1d76db | snapMULTI server |
| component:client | 5319e7 | rpi-snapclient |
| component:ctrl | 0052cc | SnapCTRL desktop |
| component:docs | 006b75 | Documentation |

Esegui tutti i comandi gh necessari. Per ogni step, mostra il comando e il risultato.
Alla fine mostrami l'URL del project.
```

---

## Comandi Manuali (se preferisci)

Se vuoi eseguire manualmente:

```bash
# 1. Crea il project
gh project create --owner lollonet --title "SnapForge Ecosystem"
# Nota il PROJECT_NUMBER dall'output

# 2. Linka i repository (sostituisci PROJECT_NUMBER)
gh project link PROJECT_NUMBER --owner lollonet --repo lollonet/snapforge
gh project link PROJECT_NUMBER --owner lollonet --repo lollonet/snapMULTI
gh project link PROJECT_NUMBER --owner lollonet --repo lollonet/rpi-snapclient-usb
gh project link PROJECT_NUMBER --owner lollonet --repo lollonet/snapctrl

# 3. Crea custom fields
gh project field-create PROJECT_NUMBER --owner lollonet \
  --name "Component" --data-type "SINGLE_SELECT" \
  --single-select-options "snapMULTI,rpi-snapclient,SnapCTRL,snapforge-docs,ecosystem"

gh project field-create PROJECT_NUMBER --owner lollonet \
  --name "Priority" --data-type "SINGLE_SELECT" \
  --single-select-options "P0-Critical,P1-High,P2-Medium,P3-Low"

gh project field-create PROJECT_NUMBER --owner lollonet \
  --name "Type" --data-type "SINGLE_SELECT" \
  --single-select-options "bug,feature,docs,question,enhancement"

gh project field-create PROJECT_NUMBER --owner lollonet \
  --name "Effort" --data-type "SINGLE_SELECT" \
  --single-select-options "XS (1h),S (half-day),M (1-2 days),L (week),XL (multi-week)"

# 4. Crea labels (ripeti per ogni repo)
REPOS="snapforge snapMULTI rpi-snapclient-usb snapctrl"
for repo in $REPOS; do
  gh label create "bug" -c "d73a4a" -d "Something isn't working" -R lollonet/$repo --force
  gh label create "enhancement" -c "a2eeef" -d "New feature or request" -R lollonet/$repo --force
  gh label create "documentation" -c "0075ca" -d "Documentation improvements" -R lollonet/$repo --force
  gh label create "good first issue" -c "7057ff" -d "Good for newcomers" -R lollonet/$repo --force
  gh label create "help wanted" -c "008672" -d "Extra attention needed" -R lollonet/$repo --force
  gh label create "priority:critical" -c "b60205" -d "Must fix immediately" -R lollonet/$repo --force
  gh label create "priority:high" -c "d93f0b" -d "Important" -R lollonet/$repo --force
  gh label create "priority:medium" -c "fbca04" -d "Normal priority" -R lollonet/$repo --force
  gh label create "priority:low" -c "0e8a16" -d "Nice to have" -R lollonet/$repo --force
  gh label create "component:server" -c "1d76db" -d "snapMULTI server" -R lollonet/$repo --force
  gh label create "component:client" -c "5319e7" -d "rpi-snapclient" -R lollonet/$repo --force
  gh label create "component:ctrl" -c "0052cc" -d "SnapCTRL desktop" -R lollonet/$repo --force
  gh label create "component:docs" -c "006b75" -d "Documentation" -R lollonet/$repo --force
done
```

---

## Dopo il Setup

1. Vai su https://github.com/users/lollonet/projects/
2. Apri "SnapForge Ecosystem"
3. Configura le Views manualmente (Kanban, By Component, Roadmap)
4. Imposta le automazioni dal menu "..." → "Workflows"
