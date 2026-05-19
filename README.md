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
app is thin; the brain is the reasoner and the memory. Standalone it shows that
context; installed in a brain (from v0.2.0, once the postMessage bridge is
wired) it is answered over the brain's curriculum, and your progress persists.

## Install

Paste this repo's GitHub URL into a brain's Apps page and Approve. v0.1.0
declares no permissions in `brain-app.yaml` — it touches no memory and invokes
no model; every room runs inside the iframe.

## License

AGPL-3.0. See `LICENSE`.
