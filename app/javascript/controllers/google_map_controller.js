import { Controller } from "@hotwired/stimulus";

// Configuration constants
const SATELLITE_ZOOM_THRESHOLD = 17;
const MAX_DISTANCE_METERS = 500;
const RESIZE_DEBOUNCE_MS = 150;
const INITIAL_CENTER_DELAY_MS = 450;
const FALLBACK_RECENTER_DELAYS_MS = [100, 300, 600, 1000];
const INTERSECTION_OBSERVER_ROOT_MARGIN = "100px";
const INTERSECTION_OBSERVER_THRESHOLD = 0.1;
const EARTH_RADIUS_METERS = 6371000;

/**
 * Google Map Controller
 *
 * Implements Google Maps JavaScript API with:
 * - Lazy loading via IntersectionObserver
 * - Cloud-Based Map Styling (CBMS v2) via Map ID
 * - AdvancedMarkerElement for modern marker rendering
 */
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
        rootMargin: INTERSECTION_OBSERVER_ROOT_MARGIN,
        threshold: INTERSECTION_OBSERVER_THRESHOLD,
      }
    );

    this.observer.observe(this.element);
  }

  disconnect() {
    this.observer?.disconnect();
    this.resizeObserver?.disconnect();

    if (this.resizeTimeout) {
      clearTimeout(this.resizeTimeout);
      this.resizeTimeout = null;
    }

    this.mapEventListeners.forEach((listener) => listener?.remove());
    this.mapEventListeners = [];

    this.observer = null;
    this.resizeObserver = null;
    this.map = null;
    this.marker = null;
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
    const center = { lat: this.latValue, lng: this.lngValue };

    this.map = new google.maps.Map(this.mapContainerTarget, {
      center,
      zoom: this.zoomValue,
      mapId: this.getMapId(),
      colorScheme: google.maps.ColorScheme.FOLLOW_SYSTEM,
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

    const tilesLoadedListener = google.maps.event.addListenerOnce(
      this.map,
      "tilesloaded",
      () => this.forceCenterMap(center)
    );
    this.mapEventListeners.push(tilesLoadedListener);

    this.dispatch("loaded", { detail: { map: this.map } });
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

        this.resizeTimeout = setTimeout(() => {
          this.forceCenterMap(center);
        }, RESIZE_DEBOUNCE_MS);
      }
    });

    this.resizeObserver.observe(this.mapContainerTarget);

    setTimeout(() => this.forceCenterMap(center), INITIAL_CENTER_DELAY_MS);
  }

  fallbackRecenter(center) {
    FALLBACK_RECENTER_DELAYS_MS.forEach((delay) => {
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

  setupSatelliteModeToggle(targetPosition) {
    if (!this.map) return;

    const checkAndToggleSatellite = () => {
      if (!this.map) return;

      const currentZoom = this.map.getZoom();
      const currentCenter = this.map.getCenter();
      if (!currentCenter) return;

      const distance = this.calculateDistance(currentCenter, targetPosition);
      const shouldShowSatellite =
        currentZoom >= SATELLITE_ZOOM_THRESHOLD &&
        distance <= MAX_DISTANCE_METERS;

      const currentMapType = this.map.getMapTypeId();
      const isHybrid = currentMapType === google.maps.MapTypeId.HYBRID;

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

    return EARTH_RADIUS_METERS * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  }
}
