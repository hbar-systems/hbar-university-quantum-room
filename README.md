# The Quantum Room

An interactive instrument for understanding quantum mechanics — not watching
numbers change. Education tool, art tool. A brain-app for BrainFoundry,
published by hbar.systems for hbar.university.

## What it is

A self-contained brain-app: one `bundle/index.html`, zero dependencies, zero
build step, no CDN calls — which is also the point. It installs into a
BrainFoundry brain via the Apps page, or runs standalone: open
`bundle/index.html` in any browser.

## Five rooms and a map

1. **The Qubit** — a luminous Bloch sphere; gates as animated rotations; the
   state vector precesses in real time and leaves a trail.
2. **Interference** — Feynman phasor arrows; bright and dark ports trading
   brightness while the total stays conserved.
3. **Entanglement** — two Bloch spheres losing their individual definiteness
   as the link between them tightens.
4. **Measurement** — the Born rule, collapse, the tally converging on the law.
5. **Map** — all 27 concepts as one force-directed graph; the structure of
   quantum mechanics, not a list of rooms.

Each room carries concept chips that peel open level by level — plain language
down to real physics (Hilbert space, the Hopf fibration, the measurement
problem). Angles display in terms of π; a symbol key explains the notation;
Web Audio sonifies gates and outcomes.

## Brain integration

The "Ask the brain" panel sends what you are looking at — room, concept, depth,
state, and the concepts you have explored — to the host brain as context. The
app is thin; the brain is the reasoner and the memory.

**From v0.2.0** the postMessage bridge is wired:

- Standalone (open the file in a browser) — the app runs fully; the side-chat
  shows the context it *would* send and the rest is quiet.
- Installed in a brain — questions go through the `llm.complete` bridge intent
  and are answered over the brain's curriculum (semantic layer, BYOK model);
  each concept you open at a new depth appends an event to episodic memory so
  the brain remembers what you have explored. The map also remembers locally
  via `localStorage`, so the lit concepts survive across browser sessions.

## Install

Paste this repo's GitHub URL into a brain's Apps page and Approve. v0.2.0
declares `llm.invoke` + `memory.write` permissions, with `semantic` read and
`episodic` append layers — the operator approves the scope on install.

## License

AGPL-3.0. See `LICENSE`.
