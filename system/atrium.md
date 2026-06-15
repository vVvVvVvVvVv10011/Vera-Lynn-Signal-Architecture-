# Atrium

## Role
Atrium is the processing layer of the Vera-Lynn Signal Architecture.

It consumes signals and produces structured state interpretations.

---

## Input
- Receives signals defined in `signal-model.md`

## Process
Atrium:
- validates signal structure
- classifies signal type
- updates system state representation
- logs derived interpretations

---

## Output
- interpreted state snapshots
- behavioral summaries
- optional routing decisions

---

## Rule
Atrium does not generate raw signals.

It only interprets them.
