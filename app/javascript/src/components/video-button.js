/**
 * Open YouTube video in lightbox
 * Turbo-aware: works with both initial page load and Turbo navigation
 * @requires https://github.com/sachinchoolur/lightGallery
 */

const videoButton = (() => {
  function initialize() {
    // Only initialize video buttons that haven't been initialized yet
    // lightGallery adds data-lg-id attribute when initialized
    const buttons = document.querySelectorAll(
      '[data-bs-toggle="video"]:not([data-lg-id])'
    );

    if (buttons.length) {
      for (let i = 0; i < buttons.length; i++) {
        /* eslint-disable no-undef */
        lightGallery(buttons[i], {
          selector: "this",
          plugins: [lgVideo],
          licenseKey: "D4194FDD-48924833-A54AECA3-D6F8E646",
          download: false,
          youtubePlayerParams: {
            modestbranding: 1,
            showinfo: 0,
            rel: 0,
          },
          vimeoPlayerParams: {
            byline: 0,
            portrait: 0,
            color: "6366f1",
          },
        });
        /* eslint-enable no-undef */
      }
    }
  }

  // Initialize on DOMContentLoaded (initial page load)
  document.addEventListener("DOMContentLoaded", initialize);

  // Initialize on Turbo load (Turbo navigation)
  document.addEventListener("turbo:load", initialize);
})();

export default videoButton;
