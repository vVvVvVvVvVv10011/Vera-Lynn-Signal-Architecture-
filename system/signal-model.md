# Signal Model

## Overview
This file defines the structure and meaning of a "signal" within the Vera-Lynn Signal Architecture system.

A signal is a recorded unit of state change. It represents an event, decision, or observation that has been captured for later interpretation.

Signals are immutable once written.

---

## Signal Structure

Each signal should follow this schema:

```json
{
  "id": "unique-signal-id",
  "timestamp": "ISO-8601 UTC time",
  "source": "system | user | ci | manual",
  "type": "event | decision | observation | error | state",
  "context": {
    "module": "system component name",
    "action": "what triggered the signal",
    "data": {}
  },
  "state": {
    "before": {},
    "after": {}
  },
  "tags": ["optional", "labels"],
  "priority": "low | medium | high | critical"
}
