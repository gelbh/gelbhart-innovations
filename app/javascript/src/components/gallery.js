/**
 * Gallery Component
 * @requires lightGallery
 * Turbo-aware gallery lightbox
 */

const gallery = (() => {
  const LICENSE_KEY = "D4194FDD-48924833-A54AECA3-D6F8E646";

  const initialize = () => {
    for (const el of document.querySelectorAll(".gallery:not([data-lg-id])")) {
      const plugins = [
        lgZoom,
        lgFullscreen,
        ...(el.dataset.video ? [lgVideo] : []),
        ...(el.dataset.thumbnails ? [lgThumbnail] : []),
      ];

      lightGallery(el, {
        selector: ".gallery-item",
        plugins,
        licenseKey: LICENSE_KEY,
        download: false,
        autoplayVideoOnSlide: true,
        zoomFromOrigin: false,
        youtubePlayerParams: { modestbranding: 1, showinfo: 0, rel: 0 },
        vimeoPlayerParams: { byline: 0, portrait: 0, color: "6366f1" },
      });
    }
  };

  document.addEventListener("DOMContentLoaded", initialize);
  document.addEventListener("turbo:load", initialize);
})();

export default gallery;
