import { Controller } from "@hotwired/stimulus";

/**
 * Google Map Controller
 *
 * Implements Google Maps JavaScript API with:
 * - Lazy loading with IntersectionObserver
 * - Cloud-Based Map Styling (CBMS v2) via Map ID
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
    window.mapController = this;
    this.lastWidth = 0;
    this.lastHeight = 0;
    this.resizeTimeout = null;

    if (!("IntersectionObserver" in window)) {
      this.loadMap();
      return;
    }

    this.observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            this.loadMap();
            this.observer.unobserve(entry.target);
          }
        });
      },
      { rootMargin: "100px", threshold: 0.1 }
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

    this.observer = null;
    this.resizeObserver = null;
  }

  async loadMap() {
    try {
      if (typeof google !== "undefined" && google.maps) {
        this.initializeMap();
        return;
      }

      await this.loadGoogleMapsAPI();
      this.initializeMap();
    } catch (error) {
      console.error("Failed to load Google Maps:", error);
      this.showError();
    }
  }

  loadGoogleMapsAPI() {
    return new Promise((resolve, reject) => {
      if (window.googleMapsLoading) {
        window.googleMapsLoading.then(resolve).catch(reject);
        return;
      }

      window.googleMapsLoading = new Promise((res, rej) => {
        const apiKey = this.getApiKey();

        if (!apiKey) {
          const error = new Error("Google Maps API key is required");
          rej(error);
          reject(error);
          return;
        }

        window.initGoogleMaps = () => {
          delete window.initGoogleMaps;
          res();
          resolve();
        };

        const script = document.createElement("script");
        script.src = `https://maps.googleapis.com/maps/api/js?key=${apiKey}&loading=async&callback=initGoogleMaps&v=weekly&libraries=geometry`;
        script.async = true;
        script.defer = true;

        script.onerror = () => {
          delete window.initGoogleMaps;
          const error = new Error("Failed to load Google Maps API");
          rej(error);
          reject(error);
        };

        document.head.appendChild(script);
      });
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

  initializeMap() {
    const center = { lat: this.latValue, lng: this.lngValue };
    const mapId = this.getMapId();

    const mapOptions = {
      center,
      zoom: this.zoomValue,
      mapId,
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
    };

    this.map = new google.maps.Map(this.mapContainerTarget, mapOptions);

    this.marker = new google.maps.Marker({
      map: this.map,
      position: center,
    });

    this.element.classList.add("map-loaded");
    this.setupResizeObserver(center);
    this.setupSatelliteModeToggle(center);

    google.maps.event.addListenerOnce(this.map, "tilesloaded", () => {
      this.forceCenterMap(center);
    });

    this.dispatch("loaded", { detail: { map: this.map } });
  }

  setupResizeObserver(center) {
    if (!("ResizeObserver" in window)) {
      this.fallbackRecenter(center);
      return;
    }

    this.resizeObserver = new ResizeObserver((entries) => {
      for (const entry of entries) {
        const { width, height } = entry.contentRect;

        if (width !== this.lastWidth || height !== this.lastHeight) {
          this.lastWidth = width;
          this.lastHeight = height;

          if (this.resizeTimeout) clearTimeout(this.resizeTimeout);

          this.resizeTimeout = setTimeout(() => {
            this.forceCenterMap(center);
          }, 150);
        }
      }
    });

    this.resizeObserver.observe(this.mapContainerTarget);

    setTimeout(() => {
      this.forceCenterMap(center);
    }, 450);
  }

  fallbackRecenter(center) {
    [100, 300, 600, 1000].forEach((delay) => {
      setTimeout(() => {
        if (this.map) this.forceCenterMap(center);
      }, delay);
    });
  }

  forceCenterMap(center) {
    if (!this.map) return;

    google.maps.event.trigger(this.map, "resize");

    requestAnimationFrame(() => {
      if (this.map) {
        this.map.setCenter(center);
        this.map.setZoom(this.zoomValue);
      }
    });
  }

  showError() {
    const placeholder = this.element.querySelector(".contact-map-placeholder");
    if (placeholder) {
      placeholder.innerHTML = `
        <div class="text-center text-danger">
          <i class="bx bx-error fs-1 mb-2 d-block"></i>
          <span class="fs-sm">Failed to load map</span>
        </div>
      `;
    }
  }

  recenter() {
    if (!this.map) {
      console.warn("Map not initialized yet");
      return;
    }

    const center = { lat: this.latValue, lng: this.lngValue };
    console.log("Recentering map to:", center);
    this.forceCenterMap(center);
  }

  setupSatelliteModeToggle(targetPosition) {
    if (!this.map) return;

    // Threshold zoom level to switch to satellite (17 = close-up view)
    const SATELLITE_ZOOM_THRESHOLD = 17;
    // Maximum distance in meters from target to show satellite view
    const MAX_DISTANCE_METERS = 500;

    const checkAndToggleSatellite = () => {
      if (!this.map) return;

      const currentZoom = this.map.getZoom();
      const currentCenter = this.map.getCenter();
      const currentMapType = this.map.getMapTypeId();

      if (!currentCenter) return;

      // Calculate distance from map center to target
      let distance = 0;
      if (
        google.maps.geometry &&
        google.maps.geometry.spherical &&
        google.maps.geometry.spherical.computeDistanceBetween
      ) {
        // Use geometry library if available
        distance = google.maps.geometry.spherical.computeDistanceBetween(
          currentCenter,
          targetPosition
        );
      } else {
        // Fallback: simple distance calculation using Haversine formula
        const R = 6371000; // Earth's radius in meters
        const lat1 = currentCenter.lat() * (Math.PI / 180);
        const lat2 = targetPosition.lat * (Math.PI / 180);
        const deltaLat =
          (targetPosition.lat - currentCenter.lat()) * (Math.PI / 180);
        const deltaLng =
          (targetPosition.lng - currentCenter.lng()) * (Math.PI / 180);

        const a =
          Math.sin(deltaLat / 2) * Math.sin(deltaLat / 2) +
          Math.cos(lat1) *
            Math.cos(lat2) *
            Math.sin(deltaLng / 2) *
            Math.sin(deltaLng / 2);
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        distance = R * c;
      }

      // Check if we should show satellite view
      const shouldShowSatellite =
        currentZoom >= SATELLITE_ZOOM_THRESHOLD &&
        distance <= MAX_DISTANCE_METERS;

      if (
        shouldShowSatellite &&
        currentMapType !== google.maps.MapTypeId.HYBRID
      ) {
        // Switch to hybrid (satellite with labels) when zoomed in on target
        this.map.setMapTypeId(google.maps.MapTypeId.HYBRID);
      } else if (
        !shouldShowSatellite &&
        currentMapType === google.maps.MapTypeId.HYBRID
      ) {
        // Switch back to roadmap when zoomed out or panned away
        this.map.setMapTypeId(google.maps.MapTypeId.ROADMAP);
      }
    };

    // Listen to zoom changes
    this.map.addListener("zoom_changed", checkAndToggleSatellite);

    // Listen to center changes (panning)
    this.map.addListener("center_changed", checkAndToggleSatellite);

    // Check initial state
    checkAndToggleSatellite();
  }
}
