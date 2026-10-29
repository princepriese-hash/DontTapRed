# Don't Tap Red — Stage 1 GDD

## Scope

Stage 1 is a minimal playable Classic reaction game. One wave is one level: safe targets are tapped for points, red targets are never tapped. It intentionally has no audio, ads, analytics, save system, post-MVP modes, or menu flow beyond Start/Retry.

## Rules

Each wave spawns the level's target count over 0–400 ms. Safe taps remove a target and score using reaction speed, streak, difficulty, and proximity risk. Red taps remove one of three lives and halve the streak. From level 4, safe targets remaining at expiry cost one life each; levels 1–3 wait indefinitely. Clearing safe targets advances after 400 ms. One life is restored every ten cleared levels, up to three. Empty taps are ignored. Same-position taps are debounced for 80 ms.

## Presentation and architecture

The portrait 1080×1920 Compatibility project uses a #0B0F1A background, code-drawn safe shapes and red octagons with white X marks and pulsing outlines. HUD occupies the top 12%; targets stay above it and below the bottom 8%. Gameplay is split among the systems in `scripts/game`, `scripts/systems`, and `scripts/util`; constants are in `data/balance.json`.

## Verification

Headless tests cover difficulty bounds, scoring including the 135-point maximum, combo milestones/halving, and deterministic PRNG output. The project must parse and launch with Godot headless.

