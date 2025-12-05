import { Controller } from "@hotwired/stimulus";

/**
 * Google Map Controller
 *
 * Implements Google Maps JavaScript API with:
 * - Lazy loading with IntersectionObserver
 * - Custom styling for light/dark themes
 * - Automatic theme switching
 * - Marker with info window
 */
export default class extends Controller {
  static targets = ["mapContainer"];
  static values = {
    lat: Number,
    lng: Number,
    address: String,
    zoom: { type: Number, default: 8 },
    apiKey: { type: String, default: "" },
  };

  lightModeStyle = [
    {
      featureType: "all",
      elementType: "geometry",
      stylers: [{ color: "#f3f6ff" }],
    },
    {
      featureType: "all",
      elementType: "labels.text.fill",
      stylers: [{ color: "#565973" }],
    },
    {
      featureType: "all",
      elementType: "labels.text.stroke",
      stylers: [{ color: "#ffffff" }],
    },
    {
      featureType: "administrative",
      elementType: "geometry.stroke",
      stylers: [{ color: "#d4d7e5" }],
    },
    {
      featureType: "landscape",
      elementType: "geometry",
      stylers: [{ color: "#eff2fc" }],
    },
    {
      featureType: "poi",
      elementType: "geometry",
      stylers: [{ color: "#e2e5f1" }],
    },
    {
      featureType: "poi.park",
      elementType: "geometry",
      stylers: [{ color: "#dee7df" }],
    },
    {
      featureType: "road",
      elementType: "geometry",
      stylers: [{ color: "#ffffff" }],
    },
    {
      featureType: "road",
      elementType: "geometry.stroke",
      stylers: [{ color: "#e2e5f1" }],
    },
    {
      featureType: "road.highway",
      elementType: "geometry",
      stylers: [{ color: "#d4d7e5" }],
    },
    {
      featureType: "road.highway",
      elementType: "geometry.stroke",
      stylers: [{ color: "#b4b7c9" }],
    },
    {
      featureType: "water",
      elementType: "geometry",
      stylers: [{ color: "#c9d6f7" }],
    },
    {
      featureType: "water",
      elementType: "labels.text.fill",
      stylers: [{ color: "#529fcb" }],
    },
    {
      featureType: "administrative.country",
      elementType: "geometry.stroke",
      stylers: [{ color: "#ef4646" }, { weight: 2.5 }],
    },
    {
      featureType: "administrative.province",
      elementType: "geometry.stroke",
      stylers: [{ color: "#ef4646" }, { weight: 1.5 }],
    },
  ];

  darkModeStyle = [
    {
      featureType: "all",
      elementType: "labels.text.fill",
      stylers: [{ saturation: 36 }, { color: "#000000" }, { lightness: 40 }],
    },
    {
      featureType: "all",
      elementType: "labels.text.stroke",
      stylers: [{ visibility: "on" }, { color: "#000000" }, { lightness: 16 }],
    },
    {
      featureType: "all",
      elementType: "labels.icon",
      stylers: [{ visibility: "off" }],
    },
    {
      featureType: "administrative",
      elementType: "geometry.fill",
      stylers: [{ lightness: 20 }],
    },
    {
      featureType: "administrative",
      elementType: "geometry.stroke",
      stylers: [{ color: "#000000" }, { lightness: 17 }, { weight: 1.2 }],
    },
    {
      featureType: "administrative.province",
      elementType: "labels.text.fill",
      stylers: [{ color: "#ef4646" }],
    },
    {
      featureType: "administrative.locality",
      elementType: "labels.text.fill",
      stylers: [{ color: "#ef4646" }],
    },
    {
      featureType: "administrative.locality",
      elementType: "labels.text.stroke",
      stylers: [{ color: "#0e0d0a" }],
    },
    {
      featureType: "administrative.neighborhood",
      elementType: "labels.text.fill",
      stylers: [{ color: "#ef4646" }],
    },
    {
      featureType: "landscape",
      elementType: "geometry",
      stylers: [{ color: "#000000" }, { lightness: 20 }],
    },
    {
      featureType: "poi",
      elementType: "geometry",
      stylers: [{ color: "#000000" }, { lightness: 21 }],
    },
    {
      featureType: "road",
      elementType: "labels.text.stroke",
      stylers: [{ color: "#12120f" }],
    },
    {
      featureType: "road.highway",
      elementType: "geometry.fill",
      stylers: [
        { lightness: -77 },
        { gamma: 4.48 },
        { saturation: 24 },
        { weight: 0.65 },
      ],
    },
    {
      featureType: "road.highway",
      elementType: "geometry.stroke",
      stylers: [{ lightness: 29 }, { weight: 0.2 }],
    },
    {
      featureType: "road.highway.controlled_access",
      elementType: "geometry.fill",
      stylers: [{ color: "#ef4646" }],
    },
    {
      featureType: "road.arterial",
      elementType: "geometry",
      stylers: [{ color: "#4f4e49" }, { weight: 0.36 }],
    },
    {
      featureType: "road.arterial",
      elementType: "labels.text.fill",
      stylers: [{ color: "#ef4646" }],
    },
    {
      featureType: "road.arterial",
      elementType: "labels.text.stroke",
      stylers: [{ color: "#262307" }],
    },
    {
      featureType: "road.local",
      elementType: "geometry",
      stylers: [{ color: "#a4875a" }, { lightness: 16 }, { weight: 0.16 }],
    },
    {
      featureType: "road.local",
      elementType: "labels.text.fill",
      stylers: [{ color: "#ef4646" }],
    },
    {
      featureType: "transit",
      elementType: "geometry",
      stylers: [{ color: "#000000" }, { lightness: 19 }],
    },
    {
      featureType: "water",
      elementType: "geometry",
      stylers: [{ color: "#529fcb" }, { lightness: 20 }],
    },
    {
      featureType: "water",
      elementType: "geometry.fill",
      stylers: [{ color: "#529fcb" }, { lightness: 15 }],
    },
    {
      featureType: "water",
      elementType: "labels.text.fill",
      stylers: [{ color: "#529fcb" }, { lightness: 30 }],
    },
    {
      featureType: "administrative.country",
      elementType: "geometry.stroke",
      stylers: [{ color: "#ef4646" }, { weight: 2.5 }],
    },
    {
      featureType: "administrative.province",
      elementType: "geometry.stroke",
      stylers: [{ color: "#ef4646" }, { weight: 1.5 }],
    },
  ];

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
    this.setupThemeListener();
  }

  disconnect() {
    this.observer?.disconnect();
    this.themeObserver?.disconnect();
    this.resizeObserver?.disconnect();

    if (this.resizeTimeout) {
      clearTimeout(this.resizeTimeout);
      this.resizeTimeout = null;
    }

    // Clean up zoom controls
    const zoomControls = this.mapContainerTarget?.querySelector(
      ".custom-zoom-control"
    );
    if (zoomControls) {
      zoomControls.remove();
    }

    this.observer = null;
    this.themeObserver = null;
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

  initializeMap() {
    const currentTheme = this.getCurrentTheme();
    const styles =
      currentTheme === "dark" ? this.darkModeStyle : this.lightModeStyle;
    const center = { lat: this.latValue, lng: this.lngValue };

    const mapOptions = {
      center,
      zoom: this.zoomValue,
      styles,
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

    this.createZoomControls();

    this.marker = new google.maps.Marker({
      map: this.map,
      position: center,
      title: this.addressValue,
      animation: google.maps.Animation.DROP,
    });

    this.infoWindow = new google.maps.InfoWindow({
      content: `<div style="padding: 10px; font-family: inherit;"><strong style="font-size: 14px;">Gelbhart Innovations</strong><br><span style="font-size: 13px; color: #666;">${this.addressValue}</span></div>`,
    });

    this.marker.addListener("click", () => {
      this.infoWindow.open(this.map, this.marker);
    });

    this.element.classList.add("map-loaded");
    this.setupResizeObserver(center);
    this.setupSatelliteModeToggle(center);

    google.maps.event.addListenerOnce(this.map, "tilesloaded", () => {
      this.forceCenterMap(center);
    });

    this.dispatch("loaded", { detail: { map: this.map, marker: this.marker } });
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

  updateMapTheme() {
    if (!this.map) return;

    const currentTheme = this.getCurrentTheme();
    const styles =
      currentTheme === "dark" ? this.darkModeStyle : this.lightModeStyle;

    this.map.setOptions({ styles });
    this.dispatch("theme-changed", {
      detail: { theme: currentTheme, map: this.map },
    });
  }

  getCurrentTheme() {
    return document.documentElement.getAttribute("data-bs-theme") || "light";
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

  createZoomControls() {
    if (!this.map) return;

    // Create a custom control class
    class ZoomControl {
      constructor(controller) {
        this.controller = controller;
      }

      onAdd(map) {
        this.map = map;
        const zoomControlDiv = document.createElement("div");
        zoomControlDiv.className = "custom-zoom-control";

        const zoomInButton = document.createElement("button");
        zoomInButton.className = "custom-zoom-button custom-zoom-in";
        zoomInButton.setAttribute("type", "button");
        zoomInButton.setAttribute("aria-label", "Zoom in");
        zoomInButton.innerHTML =
          '<i class="bx bx-plus" aria-hidden="true"></i>';
        zoomInButton.addEventListener("click", (e) => {
          e.stopPropagation();
          this.controller.zoomIn();
        });

        const zoomOutButton = document.createElement("button");
        zoomOutButton.className = "custom-zoom-button custom-zoom-out";
        zoomOutButton.setAttribute("type", "button");
        zoomOutButton.setAttribute("aria-label", "Zoom out");
        zoomOutButton.innerHTML =
          '<i class="bx bx-minus" aria-hidden="true"></i>';
        zoomOutButton.addEventListener("click", (e) => {
          e.stopPropagation();
          this.controller.zoomOut();
        });

        zoomControlDiv.appendChild(zoomInButton);
        zoomControlDiv.appendChild(zoomOutButton);

        this.zoomControlDiv = zoomControlDiv;
        return zoomControlDiv;
      }

      onRemove() {
        if (this.zoomControlDiv && this.zoomControlDiv.parentNode) {
          this.zoomControlDiv.parentNode.removeChild(this.zoomControlDiv);
        }
      }
    }

    // Add the control to the map
    const zoomControl = new ZoomControl(this);
    this.map.controls[google.maps.ControlPosition.TOP_RIGHT].push(zoomControl);

    this.updateZoomButtons();
    this.map.addListener("zoom_changed", () => this.updateZoomButtons());
  }

  zoomIn() {
    if (!this.map) return;
    const currentZoom = this.map.getZoom();
    if (currentZoom < 21) {
      this.map.setZoom(currentZoom + 1);
    }
  }

  zoomOut() {
    if (!this.map) return;
    const currentZoom = this.map.getZoom();
    if (currentZoom > 0) {
      this.map.setZoom(currentZoom - 1);
    }
  }

  updateZoomButtons() {
    if (!this.map) return;
    const currentZoom = this.map.getZoom();
    const zoomInButton = document.querySelector(".custom-zoom-in");
    const zoomOutButton = document.querySelector(".custom-zoom-out");

    if (zoomInButton) {
      zoomInButton.disabled = currentZoom >= 21;
      zoomInButton.setAttribute("aria-disabled", currentZoom >= 21);
    }
    if (zoomOutButton) {
      zoomOutButton.disabled = currentZoom <= 0;
      zoomOutButton.setAttribute("aria-disabled", currentZoom <= 0);
    }
  }

  setupSatelliteModeToggle(markerPosition) {
    if (!this.map) return;

    // Threshold zoom level to switch to satellite (17 = close-up view)
    const SATELLITE_ZOOM_THRESHOLD = 17;
    // Maximum distance in meters from marker to show satellite view
    const MAX_DISTANCE_METERS = 500;

    const checkAndToggleSatellite = () => {
      if (!this.map) return;

      const currentZoom = this.map.getZoom();
      const currentCenter = this.map.getCenter();
      const currentMapType = this.map.getMapTypeId();

      if (!currentCenter) return;

      // Calculate distance from map center to marker
      let distance = 0;
      if (
        google.maps.geometry &&
        google.maps.geometry.spherical &&
        google.maps.geometry.spherical.computeDistanceBetween
      ) {
        // Use geometry library if available
        distance = google.maps.geometry.spherical.computeDistanceBetween(
          currentCenter,
          markerPosition
        );
      } else {
        // Fallback: simple distance calculation using Haversine formula
        const R = 6371000; // Earth's radius in meters
        const lat1 = currentCenter.lat() * (Math.PI / 180);
        const lat2 = markerPosition.lat * (Math.PI / 180);
        const deltaLat =
          (markerPosition.lat - currentCenter.lat()) * (Math.PI / 180);
        const deltaLng =
          (markerPosition.lng - currentCenter.lng()) * (Math.PI / 180);

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
        // Switch to hybrid (satellite with labels) when zoomed in on marker
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
