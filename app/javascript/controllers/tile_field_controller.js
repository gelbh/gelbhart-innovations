import { Controller } from "@hotwired/stimulus";

/**
 * Pointer-reactive service tiles: a soft light tracks the cursor and the tile
 * tilts gently toward it. Pure progressive enhancement — without JS the tiles
 * keep their CSS hover/focus states. Honors prefers-reduced-motion (no tilt).
 */
export default class extends Controller {
  static targets = ["tile"];

  connect() {
    this.reducedMotion = window.matchMedia(
      "(prefers-reduced-motion: reduce)"
    ).matches;

    this.cleanups = this.tileTargets.map((tile) => this.bindTile(tile));
  }

  disconnect() {
    this.cleanups?.forEach((fn) => fn());
  }

  bindTile(tile) {
    // Shared-element morph: tag only the clicked tile so exactly one matched
    // pair animates into the destination hero (no orphan-name artifacts).
    const onActivate = () => {
      this.tileTargets.forEach((t) =>
        t.style.removeProperty("view-transition-name")
      );
      tile.style.setProperty("view-transition-name", "practice-shared");
    };

    const onMove = (event) => {
      const rect = tile.getBoundingClientRect();
      const px = (event.clientX - rect.left) / rect.width;
      const py = (event.clientY - rect.top) / rect.height;

      tile.style.setProperty("--ptr-x", `${(px * 100).toFixed(2)}%`);
      tile.style.setProperty("--ptr-y", `${(py * 100).toFixed(2)}%`);

      if (!this.reducedMotion) {
        const max = 4; // degrees
        tile.style.setProperty("--ry", `${((px - 0.5) * 2 * max).toFixed(2)}deg`);
        tile.style.setProperty("--rx", `${((0.5 - py) * 2 * max).toFixed(2)}deg`);
      }
    };

    const onLeave = () => {
      tile.style.removeProperty("--rx");
      tile.style.removeProperty("--ry");
    };

    tile.addEventListener("pointermove", onMove, { passive: true });
    tile.addEventListener("pointerleave", onLeave);
    tile.addEventListener("pointerdown", onActivate);
    tile.addEventListener("click", onActivate);

    return () => {
      tile.removeEventListener("pointermove", onMove);
      tile.removeEventListener("pointerleave", onLeave);
      tile.removeEventListener("pointerdown", onActivate);
      tile.removeEventListener("click", onActivate);
    };
  }
}
