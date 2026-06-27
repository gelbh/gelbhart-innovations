import { Controller } from "@hotwired/stimulus";

/**
 * "Atelier field": a restrained generative backdrop for the services hub —
 * fine brand-tinted threads drifting along a slow vector field. Four crafts,
 * one firm. Lazy-initialised, paused when off-screen or the tab is hidden,
 * and rendered as a single static frame under prefers-reduced-motion.
 */
export default class extends Controller {
  static targets = ["canvas"];

  // Brand hues: signal red, deep teal, coastal blue, eco green.
  PALETTE = [
    [239, 70, 70],
    [0, 111, 151],
    [82, 159, 203],
    [14, 165, 164]
  ];

  connect() {
    if (!this.hasCanvasTarget) return;
    this.ctx = this.canvasTarget.getContext("2d", { alpha: true });
    if (!this.ctx) return;

    this.reducedMotion = window.matchMedia(
      "(prefers-reduced-motion: reduce)"
    ).matches;
    this.running = false;
    this.time = 0;

    this.onResize = this.resize.bind(this);
    this.onVisibility = () => {
      if (document.hidden) this.stop();
      else if (this.onScreen) this.start();
    };

    window.addEventListener("resize", this.onResize, { passive: true });
    document.addEventListener("visibilitychange", this.onVisibility);

    this.resize();

    this.observer = new IntersectionObserver(
      ([entry]) => {
        this.onScreen = entry.isIntersecting;
        if (this.onScreen) this.start();
        else this.stop();
      },
      { rootMargin: "120px" }
    );
    this.observer.observe(this.element);
  }

  disconnect() {
    this.stop();
    this.observer?.disconnect();
    window.removeEventListener("resize", this.onResize);
    document.removeEventListener("visibilitychange", this.onVisibility);
  }

  resize() {
    const rect = this.element.getBoundingClientRect();
    this.dpr = Math.min(window.devicePixelRatio || 1, 2);
    this.width = Math.max(rect.width, 1);
    this.height = Math.max(rect.height, 1);
    this.canvasTarget.width = Math.round(this.width * this.dpr);
    this.canvasTarget.height = Math.round(this.height * this.dpr);
    this.ctx.setTransform(this.dpr, 0, 0, this.dpr, 0, 0);

    this.seed();
    if (this.reducedMotion) this.renderStatic();
  }

  seed() {
    const density = Math.round((this.width * this.height) / 16000);
    this.count = Math.max(28, Math.min(90, density));
    this.particles = Array.from({ length: this.count }, () => this.spawn());
  }

  spawn(fromEdge = false) {
    return {
      x: Math.random() * this.width,
      y: fromEdge ? -10 : Math.random() * this.height,
      speed: 0.15 + Math.random() * 0.35,
      len: 8 + Math.random() * 22,
      color: this.PALETTE[(Math.random() * this.PALETTE.length) | 0]
    };
  }

  flowAngle(x, y, t) {
    return (
      Math.sin(x * 0.0016 + t * 0.0002) +
      Math.cos(y * 0.0018 - t * 0.00015)
    ) * 0.9;
  }

  start() {
    if (this.running || this.reducedMotion) return;
    this.running = true;
    this.frame = requestAnimationFrame(this.tick.bind(this));
  }

  stop() {
    this.running = false;
    if (this.frame) cancelAnimationFrame(this.frame);
  }

  tick() {
    if (!this.running) return;
    this.time += 16;
    this.ctx.clearRect(0, 0, this.width, this.height);
    this.ctx.lineCap = "round";

    for (const p of this.particles) {
      const a = this.flowAngle(p.x, p.y, this.time);
      const vx = Math.cos(a) * p.speed;
      const vy = Math.sin(a) * p.speed + p.speed * 0.6;

      const x2 = p.x + vx * p.len;
      const y2 = p.y + vy * p.len;

      const [r, g, b] = p.color;
      this.ctx.strokeStyle = `rgba(${r}, ${g}, ${b}, 0.16)`;
      this.ctx.lineWidth = 1;
      this.ctx.beginPath();
      this.ctx.moveTo(p.x, p.y);
      this.ctx.lineTo(x2, y2);
      this.ctx.stroke();

      p.x += vx;
      p.y += vy;

      if (p.y > this.height + 12 || p.x < -12 || p.x > this.width + 12) {
        Object.assign(p, this.spawn(true));
      }
    }

    this.frame = requestAnimationFrame(this.tick.bind(this));
  }

  renderStatic() {
    this.ctx.clearRect(0, 0, this.width, this.height);
    this.ctx.lineCap = "round";
    for (const p of this.particles) {
      const a = this.flowAngle(p.x, p.y, 0);
      const [r, g, b] = p.color;
      this.ctx.strokeStyle = `rgba(${r}, ${g}, ${b}, 0.12)`;
      this.ctx.lineWidth = 1;
      this.ctx.beginPath();
      this.ctx.moveTo(p.x, p.y);
      this.ctx.lineTo(p.x + Math.cos(a) * p.len, p.y + Math.sin(a) * p.len);
      this.ctx.stroke();
    }
  }
}
