import { Controller } from "@hotwired/stimulus";

/**
 * Map Lazy Load Controller
 *
 * Implements lazy loading for embedded maps with theme-aware styling.
 * The map iframe only loads when scrolled into the viewport.
 */
export default class extends Controller {
  static targets = ["iframe"];
  static values = {
    rootMargin: { type: String, default: "100px" },
    threshold: { type: Number, default: 0.1 },
  };

  connect() {
    if (!("IntersectionObserver" in window)) {
      this.loadMap();
      return;
    }

    this.iframe = this.hasIframeTarget
      ? this.iframeTarget
      : this.element.querySelector("iframe[data-src]");

    if (!this.iframe) {
      console.warn("Map lazy load: No iframe with data-src found");
      return;
    }

    this.observer = new IntersectionObserver(
      this.handleIntersection.bind(this),
      { rootMargin: this.rootMarginValue, threshold: this.thresholdValue }
    );

    this.observer.observe(this.element);
    this.setupThemeListener();
  }

  disconnect() {
    this.observer?.disconnect();
    this.themeObserver?.disconnect();
    this.observer = null;
    this.themeObserver = null;
  }

  setupThemeListener() {
    this.themeObserver = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        if (
          mutation.type === "attributes" &&
          mutation.attributeName === "data-bs-theme"
        ) {
          this.updateMapTheme();
        }
      });
    });

    this.themeObserver.observe(document.documentElement, {
      attributes: true,
      attributeFilter: ["data-bs-theme"],
    });
  }

  handleIntersection(entries) {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        this.loadMap();
        this.observer.unobserve(entry.target);
      }
    });
  }

  loadMap() {
    if (!this.iframe) return;

    const src = this.iframe.dataset.src;
    if (!src) {
      this.markAsLoaded();
      return;
    }

    this.iframe.addEventListener("load", this.handleLoad.bind(this), {
      once: true,
    });
    this.iframe.src = src;
    delete this.iframe.dataset.src;
  }

  handleLoad() {
    this.markAsLoaded();
  }

  markAsLoaded() {
    this.element.classList.add("map-loaded");
    this.dispatch("loaded", { detail: { iframe: this.iframe } });
  }

  updateMapTheme() {
    if (!this.iframe) return;

    const lightUrl = this.iframe.dataset.mapUrlLight;
    const darkUrl = this.iframe.dataset.mapUrlDark;

    if (!lightUrl || !darkUrl) return;

    const currentTheme =
      document.documentElement.getAttribute("data-bs-theme") || "light";
    const newUrl = currentTheme === "dark" ? darkUrl : lightUrl;

    if (this.iframe.src && this.iframe.src !== newUrl) {
      this.iframe.src = newUrl;
      this.dispatch("theme-changed", {
        detail: { theme: currentTheme, iframe: this.iframe },
      });
    } else if (!this.iframe.src && this.iframe.dataset.src) {
      this.iframe.dataset.src = newUrl;
    }
  }

  refreshTheme() {
    this.updateMapTheme();
  }
}
