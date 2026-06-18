from pathlib import Path
import json


class SignalWeaver:
    """
    Deterministic graph compiler for SIGIL ledger signals.

    Contract:
    - load() -> reads ledger JSON signals
    - build_graph() -> deterministic node/edge graph (REPLAY SAFE)
    - heal_graph() -> optional post-processing layer (non-breaking)
    - export() -> writes VISIL-compatible graph output
    """

    def __init__(self, ledger_path="ledger/signals"):
        self.ledger_path = Path(ledger_path)

    # ----------------------------
    # LOAD LEDGER
    # ----------------------------
    def load(self):
        signals = []

        if not self.ledger_path.exists():
            return signals

        for f in sorted(self.ledger_path.glob("*.json")):
            try:
                with open(f, "r") as file:
                    signals.append(json.load(file))
            except Exception as e:
                print(f"SKIP CORRUPT SIGNAL: {f} -> {e}")

        return signals

    # ----------------------------
    # CORE GRAPH COMPILER (REQUIRED)
    # ----------------------------
    def build_graph(self, signals):
        nodes = {}
        edges = []

        for s in signals:
            # required identity field
            node_id = s.get("id")
            if not node_id:
                continue

            nodes[node_id] = s

            # deterministic transition edge
            nxt = s.get("next_state")
            if nxt:
                edges.append({
                    "from": node_id,
                    "to": nxt,
                    "type": "transition"
                })

        return {
            "nodes": nodes,
            "edges": edges
        }

    # ----------------------------
    # OPTIONAL INTELLIGENCE LAYER (SAFE EXTENSION)
    # ----------------------------
    def heal_graph(self, graph):
        """
        Future layer:
        - cleanup
        - validation
        - normalization
        - enrichment

        MUST NOT change structure meaning.
        """
        return graph

    # ----------------------------
    # EXPORT VISIL READ MODEL
    # ----------------------------
    def export(self, graph, out="visil/outputs/graph.json"):
        Path(out).parent.mkdir(parents=True, exist_ok=True)

        with open(out, "w") as f:
            json.dump(graph, f, indent=2)


# ----------------------------
# ENTRY POINT FOR ATRIUM.PY
# ----------------------------
def run_weaver():
    weaver = SignalWeaver()

    signals = weaver.load()
    graph = weaver.build_graph(signals)
    graph = weaver.heal_graph(graph)

    weaver.export(graph)

    print("WEAVER BUILD COMPLETE")


# backward compatibility if called directly
if __name__ == "__main__":
    run_weaver()
