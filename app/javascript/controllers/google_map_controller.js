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
    zoom: { type: Number, default: 16 },
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
      stylers: [{ color: "#6366f1" }],
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
      stylers: [{ color: "#f17060" }],
    },
    {
      featureType: "administrative.locality",
      elementType: "labels.text.fill",
      stylers: [{ color: "#e85c47" }],
    },
    {
      featureType: "administrative.locality",
      elementType: "labels.text.stroke",
      stylers: [{ color: "#0e0d0a" }],
    },
    {
      featureType: "administrative.neighborhood",
      elementType: "labels.text.fill",
      stylers: [{ color: "#f98575" }],
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
      stylers: [{ color: "#df4732" }],
    },
    {
      featureType: "road.arterial",
      elementType: "geometry",
      stylers: [{ color: "#4f4e49" }, { weight: 0.36 }],
    },
    {
      featureType: "road.arterial",
      elementType: "labels.text.fill",
      stylers: [{ color: "#ff9a8b" }],
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
      stylers: [{ color: "#ffb3a7" }],
    },
    {
      featureType: "transit",
      elementType: "geometry",
      stylers: [{ color: "#000000" }, { lightness: 19 }],
    },
    {
      featureType: "water",
      elementType: "geometry",
      stylers: [{ color: "#0f252e" }, { lightness: 17 }],
    },
    {
      featureType: "water",
      elementType: "geometry.fill",
      stylers: [{ color: "#080808" }, { gamma: 3.14 }, { weight: 1.07 }],
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
        script.src = `https://maps.googleapis.com/maps/api/js?key=${apiKey}&loading=async&callback=initGoogleMaps&v=weekly`;
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
      zoomControl: true,
      mapTypeControl: false,
      scaleControl: true,
      streetViewControl: false,
      rotateControl: false,
      fullscreenControl: true,
      gestureHandling: "auto",
    };

    this.map = new google.maps.Map(this.mapContainerTarget, mapOptions);

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
}
