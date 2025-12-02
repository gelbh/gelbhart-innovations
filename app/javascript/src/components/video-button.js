/**
 * Video Button Component
 * @requires lightGallery
 * Turbo-aware YouTube/Vimeo video lightbox
 */

const videoButton = (() => {
  const LICENSE_KEY = "D4194FDD-48924833-A54AECA3-D6F8E646";

  const initialize = () => {
    for (const button of document.querySelectorAll(
      '[data-bs-toggle="video"]:not([data-lg-id])'
    )) {
      lightGallery(button, {
        selector: "this",
        plugins: [lgVideo],
        licenseKey: LICENSE_KEY,
        download: false,
        youtubePlayerParams: { modestbranding: 1, showinfo: 0, rel: 0 },
        vimeoPlayerParams: { byline: 0, portrait: 0, color: "6366f1" },
      });
    }
  };

  document.addEventListener("DOMContentLoaded", initialize);
  document.addEventListener("turbo:load", initialize);
})();

export default videoButton;
