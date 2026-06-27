import { Controller } from "@hotwired/stimulus";

/**
 * Scroll-linked service journey: draws SVG progress paths and activates stages
 * via IntersectionObserver. Respects prefers-reduced-motion.
 */
export default class extends Controller {
  static targets = ["stage", "track", "progressPath", "heroDrawPath", "floor"];

  connect() {
    this.prefersReducedMotion = window.matchMedia(
      "(prefers-reduced-motion: reduce)"
    ).matches;

    this.measurePaths();
    this.updateActiveStage();

    if (this.prefersReducedMotion) {
      this.completeAll();
      return;
    }

    this.boundOnScroll = this.onScroll.bind(this);
    window.addEventListener("scroll", this.boundOnScroll, { passive: true });
    window.addEventListener("resize", this.boundOnScroll, { passive: true });

    this.stageObserver = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          entry.target.classList.toggle("is-active", entry.isIntersecting);
        });
        this.updateActiveStage();
      },
      { rootMargin: "-12% 0px -40% 0px", threshold: [0, 0.15, 0.4] }
    );

    this.stageTargets.forEach((stage) => this.stageObserver.observe(stage));
    this.onScroll();
  }

  disconnect() {
    window.removeEventListener("scroll", this.boundOnScroll);
    window.removeEventListener("resize", this.boundOnScroll);
    this.stageObserver?.disconnect();
  }

  measurePaths() {
    [...this.progressPathTargets, ...this.heroDrawPathTargets].forEach(
      (path) => {
        const length = path.getTotalLength();
        path.dataset.pathLength = String(length);
        path.style.strokeDasharray = `${length}`;
        if (!this.prefersReducedMotion) {
          path.style.strokeDashoffset = `${length}`;
        }
      }
    );
  }

  completeAll() {
    this.element.classList.add("service-journey--complete");
    this.stageTargets.forEach((stage) => stage.classList.add("is-active"));
    this.element.style.setProperty("--journey-progress", "1");
    this.setActiveStageIndex(this.stageTargets.length - 1);

    this.progressPathTargets.forEach((path) => {
      path.style.strokeDashoffset = "0";
    });
    this.heroDrawPathTargets.forEach((path) => {
      path.style.strokeDashoffset = "0";
    });
    this.floorTargets.forEach((floor) => floor.classList.add("is-built"));
    this.element.querySelectorAll("[data-stage-node]").forEach((node) => {
      node.classList.add("is-lit");
    });
  }

  onScroll() {
    this.updateScrollProgress();
    this.updateHeroDraw();
  }

  updateScrollProgress() {
    const track = this.hasTrackTarget ? this.trackTarget : this.element;
    const rect = track.getBoundingClientRect();
    const viewportHeight = window.innerHeight;
    const scrolled = viewportHeight * 0.28 - rect.top;
    const span = Math.max(rect.height - viewportHeight * 0.45, 1);
    const progress = Math.min(Math.max(scrolled / span, 0), 1);

    this.element.style.setProperty("--journey-progress", progress.toFixed(4));

    this.progressPathTargets.forEach((path) => {
      const length =
        parseFloat(path.dataset.pathLength) || path.getTotalLength();
      path.style.strokeDashoffset = `${length * (1 - progress)}`;
    });
  }

  updateHeroDraw() {
    this.heroDrawPathTargets.forEach((path) => {
      const hero = path.closest(
        ".pharma-page__hero, .realestate-page__hero"
      );
      if (!hero) return;

      const rect = hero.getBoundingClientRect();
      const length =
        parseFloat(path.dataset.pathLength) || path.getTotalLength();
      const drawProgress = Math.min(
        Math.max(1 - rect.bottom / (rect.height + window.innerHeight * 0.15), 0),
        1
      );
      path.style.strokeDashoffset = `${length * (1 - drawProgress)}`;
    });
  }

  updateActiveStage() {
    let maxIndex = -1;
    this.stageTargets.forEach((stage, index) => {
      if (!stage.classList.contains("is-active")) return;
      const stageIndex = Number.parseInt(
        stage.dataset.stageIndex ?? String(index),
        10
      );
      maxIndex = Math.max(maxIndex, stageIndex);
    });

    if (maxIndex >= 0) {
      this.setActiveStageIndex(maxIndex);
    }
  }

  setActiveStageIndex(index) {
    this.element.dataset.activeStage = String(index);
    this.element.style.setProperty("--active-stage", String(index));

    this.floorTargets.forEach((floor, floorIndex) => {
      floor.classList.toggle("is-built", floorIndex <= index);
    });

    this.element.querySelectorAll("[data-stage-node]").forEach((node) => {
      const nodeIndex = Number.parseInt(node.dataset.stageNode, 10);
      node.classList.toggle("is-lit", nodeIndex <= index);
    });
  }
}
