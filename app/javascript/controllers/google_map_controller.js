import { Controller } from "@hotwired/stimulus";

const CONFIG = {
  SATELLITE_ZOOM_THRESHOLD: 17,
  MAX_DISTANCE_METERS: 500,
  RESIZE_DEBOUNCE_MS: 150,
  INITIAL_CENTER_DELAY_MS: 450,
  FALLBACK_RECENTER_DELAYS_MS: [100, 300, 600, 1000],
  INTERSECTION_ROOT_MARGIN: "100px",
  INTERSECTION_THRESHOLD: 0.1,
  EARTH_RADIUS_METERS: 6371000,
};

const THEME = {
  STORAGE_KEY: "theme",
  DARK: "dark",
  LIGHT: "light",
};

export default class extends Controller {
  static targets = ["mapContainer"];
  static values = {
    lat: Number,
    lng: Number,
    zoom: { type: Number, default: 8 },
    apiKey: { type: String, default: "" },
    mapId: { type: String, default: "" },
  };

  connect() {
    this.lastWidth = 0;
    this.lastHeight = 0;
    this.resizeTimeout = null;
    this.mapEventListeners = [];
    this.isInitializing = false;

    if (!("IntersectionObserver" in window)) {
      this.loadMap();
      return;
    }

    this.observer = new IntersectionObserver(
      (entries) => {
        const entry = entries.find((e) => e.isIntersecting);
        if (entry) {
          this.loadMap();
          this.observer.unobserve(entry.target);
        }
      },
      {
        rootMargin: CONFIG.INTERSECTION_ROOT_MARGIN,
        threshold: CONFIG.INTERSECTION_THRESHOLD,
      }
    );

    this.observer.observe(this.element);
  }

  disconnect() {
    this.cleanupMap();
    this.observer?.disconnect();
    this.themeObserver?.disconnect();
    this.observer = null;
    this.themeObserver = null;
    this.ColorScheme = null;
    this.MapClass = null;
    this.isInitializing = false;
  }

  cleanupMap() {
    this.resizeObserver?.disconnect();
    this.resizeObserver = null;

    if (this.resizeTimeout) {
      clearTimeout(this.resizeTimeout);
      this.resizeTimeout = null;
    }

    this.mapEventListeners.forEach((listener) => listener?.remove());
    this.mapEventListeners = [];

    if (this.marker) {
      this.marker.map = null;
      this.marker = null;
    }

    this.map = null;

    if (this.hasMapContainerTarget) {
      this.mapContainerTarget.innerHTML = "";
    }
  }

  async loadMap() {
    try {
      await this.ensureGoogleMapsLoaded();
      await this.initializeMap();
    } catch (error) {
      console.error("Failed to load Google Maps:", error);
      this.showError();
    }
  }

  async ensureGoogleMapsLoaded() {
    if (typeof google !== "undefined" && google.maps) {
      return;
    }

    if (window.googleMapsLoading) {
      return window.googleMapsLoading;
    }

    window.googleMapsLoading = this.loadGoogleMapsAPI();
    return window.googleMapsLoading;
  }

  loadGoogleMapsAPI() {
    return new Promise((resolve, reject) => {
      const apiKey = this.getApiKey();

      if (!apiKey) {
        reject(new Error("Google Maps API key is required"));
        return;
      }

      const callbackName = `initGoogleMaps_${Date.now()}`;
      window[callbackName] = () => {
        delete window[callbackName];
        resolve();
      };

      const script = document.createElement("script");
      script.src = `https://maps.googleapis.com/maps/api/js?key=${apiKey}&loading=async&callback=${callbackName}&v=weekly&libraries=geometry,marker`;
      script.async = true;
      script.defer = true;

      script.onerror = () => {
        delete window[callbackName];
        reject(new Error("Failed to load Google Maps API"));
      };

      document.head.appendChild(script);
    });
  }

  getApiKey() {
    if (this.apiKeyValue) return this.apiKeyValue;

    const metaTag = document.querySelector('meta[name="google-maps-api-key"]');
    if (metaTag) return metaTag.content;

    if (window.GOOGLE_MAPS_API_KEY) return window.GOOGLE_MAPS_API_KEY;

    console.warn(
      "Google Maps API key not found. Add data-google-map-api-key-value or <meta name='google-maps-api-key' content='YOUR_KEY'>"
    );
    return "";
  }

  getMapId() {
    if (this.mapIdValue) return this.mapIdValue;

    const metaTag = document.querySelector('meta[name="google-maps-map-id"]');
    if (metaTag) return metaTag.content;

    if (window.GOOGLE_MAPS_MAP_ID) return window.GOOGLE_MAPS_MAP_ID;

    console.warn(
      "Google Maps Map ID not found. Add data-google-map-map-id-value or <meta name='google-maps-map-id' content='YOUR_MAP_ID'>."
    );
    return "";
  }

  async initializeMap() {
    // Prevent multiple simultaneous initializations
    if (this.isInitializing) return;
    this.isInitializing = true;

    try {
      const center = { lat: this.latValue, lng: this.lngValue };

      // Import the maps library to ensure ColorScheme is available
      // Store Map and ColorScheme for reuse when recreating map on theme change
      if (!this.MapClass || !this.ColorScheme) {
        const { Map } = await google.maps.importLibrary("maps");
        this.MapClass = Map;
        // ColorScheme is on google.maps namespace, not exported from importLibrary
        this.ColorScheme = google.maps.ColorScheme;
      }

      const colorScheme = this.getMapColorScheme();

      this.map = new this.MapClass(this.mapContainerTarget, {
        center,
        zoom: this.zoomValue,
        mapId: this.getMapId(),
        colorScheme,
        disableDefaultUI: false,
        zoomControl: false,
        mapTypeControl: false,
        scaleControl: true,
        streetViewControl: false,
        rotateControl: false,
        fullscreenControl: true,
        gestureHandling: "greedy",
        draggable: true,
      });

      await this.createMarker(center);

      this.element.classList.add("map-loaded");
      this.setupResizeObserver(center);
      this.setupSatelliteModeToggle(center);

      // Only set up theme observer once (on first initialization)
      if (!this.themeObserver) {
        this.setupThemeObserver();
      }

      const tilesLoadedListener = google.maps.event.addListenerOnce(
        this.map,
        "tilesloaded",
        () => this.forceCenterMap(center)
      );
      this.mapEventListeners.push(tilesLoadedListener);

      this.dispatch("loaded", { detail: { map: this.map } });
    } finally {
      this.isInitializing = false;
    }
  }

  async createMarker(position) {
    const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");

    this.marker = new AdvancedMarkerElement({
      map: this.map,
      position,
    });
  }

  setupResizeObserver(center) {
    if (!("ResizeObserver" in window)) {
      this.fallbackRecenter(center);
      return;
    }

    this.resizeObserver = new ResizeObserver((entries) => {
      for (const entry of entries) {
        const { width, height } = entry.contentRect;
        if (width === this.lastWidth && height === this.lastHeight) continue;

        this.lastWidth = width;
        this.lastHeight = height;

        if (this.resizeTimeout) clearTimeout(this.resizeTimeout);
        this.resizeTimeout = setTimeout(
          () => this.forceCenterMap(center),
          CONFIG.RESIZE_DEBOUNCE_MS
        );
      }
    });

    this.resizeObserver.observe(this.mapContainerTarget);
    setTimeout(
      () => this.forceCenterMap(center),
      CONFIG.INITIAL_CENTER_DELAY_MS
    );
  }

  fallbackRecenter(center) {
    CONFIG.FALLBACK_RECENTER_DELAYS_MS.forEach((delay) => {
      setTimeout(() => {
        if (this.map) this.forceCenterMap(center);
      }, delay);
    });
  }

  forceCenterMap(center) {
    if (!this.map) return;

    google.maps.event.trigger(this.map, "resize");

    requestAnimationFrame(() => {
      this.map?.setCenter(center);
      this.map?.setZoom(this.zoomValue);
    });
  }

  showError() {
    const placeholder = this.element.querySelector(".contact-map-placeholder");
    if (!placeholder) return;

    placeholder.innerHTML = `
      <div class="text-center text-danger">
        <i class="bx bx-error fs-1 mb-2 d-block"></i>
        <span class="fs-sm">Failed to load map</span>
      </div>
    `;
  }

  recenter() {
    if (!this.map) {
      console.warn("Map not initialized yet");
      return;
    }

    const center = { lat: this.latValue, lng: this.lngValue };
    this.forceCenterMap(center);
  }

  getWebsiteTheme() {
    const htmlTheme = document.documentElement.getAttribute("data-bs-theme");
    if (htmlTheme === THEME.DARK || htmlTheme === THEME.LIGHT) return htmlTheme;

    try {
      const savedTheme = localStorage.getItem(THEME.STORAGE_KEY);
      if (savedTheme === THEME.DARK || savedTheme === THEME.LIGHT)
        return savedTheme;
    } catch {
      /* localStorage unavailable */
    }

    try {
      if (window.matchMedia?.("(prefers-color-scheme: dark)").matches)
        return THEME.DARK;
    } catch {
      /* matchMedia unavailable */
    }

    return THEME.LIGHT;
  }

  getMapColorScheme() {
    if (!this.ColorScheme) return undefined;
    return this.getWebsiteTheme() === THEME.DARK
      ? this.ColorScheme.DARK
      : this.ColorScheme.LIGHT;
  }

  setupThemeObserver() {
    if (!("MutationObserver" in window)) return;

    this.themeObserver = new MutationObserver((mutations) => {
      for (const mutation of mutations) {
        if (
          mutation.type === "attributes" &&
          mutation.attributeName === "data-bs-theme"
        ) {
          this.updateMapTheme();
          break;
        }
      }
    });

    this.themeObserver.observe(document.documentElement, {
      attributes: true,
      attributeFilter: ["data-bs-theme"],
    });
  }

  async updateMapTheme() {
    if (!this.MapClass || !this.ColorScheme) return;
    this.cleanupMap();
    await this.initializeMap();
  }

  setupSatelliteModeToggle(targetPosition) {
    if (!this.map) return;

    const checkAndToggleSatellite = () => {
      if (!this.map) return;

      const currentZoom = this.map.getZoom();
      const currentCenter = this.map.getCenter();
      if (!currentCenter) return;

      const distance = this.calculateDistance(currentCenter, targetPosition);
      const shouldShowSatellite =
        currentZoom >= CONFIG.SATELLITE_ZOOM_THRESHOLD &&
        distance <= CONFIG.MAX_DISTANCE_METERS;

      const isHybrid = this.map.getMapTypeId() === google.maps.MapTypeId.HYBRID;

      if (shouldShowSatellite && !isHybrid) {
        this.map.setMapTypeId(google.maps.MapTypeId.HYBRID);
      } else if (!shouldShowSatellite && isHybrid) {
        this.map.setMapTypeId(google.maps.MapTypeId.ROADMAP);
      }
    };

    const zoomListener = this.map.addListener(
      "zoom_changed",
      checkAndToggleSatellite
    );
    const centerListener = this.map.addListener(
      "center_changed",
      checkAndToggleSatellite
    );

    this.mapEventListeners.push(zoomListener, centerListener);
    checkAndToggleSatellite();
  }

  calculateDistance(from, to) {
    if (google.maps.geometry?.spherical?.computeDistanceBetween) {
      return google.maps.geometry.spherical.computeDistanceBetween(from, to);
    }
    return this.haversineDistance({ lat: from.lat(), lng: from.lng() }, to);
  }

  haversineDistance(point1, point2) {
    const toRadians = (deg) => deg * (Math.PI / 180);
    const lat1 = toRadians(point1.lat);
    const lat2 = toRadians(point2.lat);
    const deltaLat = toRadians(point2.lat - point1.lat);
    const deltaLng = toRadians(point2.lng - point1.lng);

    const a =
      Math.sin(deltaLat / 2) ** 2 +
      Math.cos(lat1) * Math.cos(lat2) * Math.sin(deltaLng / 2) ** 2;
    return (
      CONFIG.EARTH_RADIUS_METERS *
      2 *
      Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    );
  }
}
