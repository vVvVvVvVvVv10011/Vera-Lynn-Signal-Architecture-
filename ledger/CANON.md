VISIL CANONICAL RULESET

1. STRUCTURE MODEL
- One file = one state node
- One timestamp per node
- Exactly one logical event per file

2. REQUIRED FIELDS (STRICT)
Every node MUST contain:

timestamp:
type:
context:
change:
result:
next_state:

No additional fields are allowed.

3. FIELD INTEGRITY RULES
- timestamp: single, immutable event time
- type: must be one of [signal, decision, event]
- context: pre-state condition (before change)
- change: action taken (system modification or decision)
- result: observed outcome (not intention)
- next_state: forward-facing transition target

4. VALIDATION RULES
- Missing any field = INVALID
- Empty field value = INVALID
- Multiple timestamps = INVALID
- Multi-event content per file = INVALID

5. SYSTEM BOUNDARY RULE
- Only validated nodes enter graph pipeline
- Unvalidated files must not be rendered or analyzed

6. PIPELINE AUTHORITY
All outputs must originate from:
tools/sync.sh → validation → normalization → render → graph

No direct file-to-output paths allowed.
