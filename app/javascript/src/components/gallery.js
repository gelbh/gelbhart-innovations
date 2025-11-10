/**
 * Gallery like styled lightbox component for presenting various types of media
 * @requires https://github.com/sachinchoolur/lightGallery
 * Turbo-aware: works with both initial page load and Turbo navigation
*/

const gallery = (() => {

  function initialize() {
    // Only initialize galleries that haven't been initialized yet
    // Lightgallery adds data-lg-id attribute when initialized
    let galleries = document.querySelectorAll('.gallery:not([data-lg-id])');

    if (galleries.length) {
      for (let i = 0; i < galleries.length; i++) {

        const thumbnails = galleries[i].dataset.thumbnails ? true : false,
              video = galleries[i].dataset.video ? true : false,
              defaultPlugins = [lgZoom, lgFullscreen],
              videoPlugin = video ? [lgVideo] : [],
              thumbnailPlugin = thumbnails ? [lgThumbnail] : [],
              plugins = [...defaultPlugins, ...videoPlugin, ...thumbnailPlugin]

        lightGallery(galleries[i], {
          selector: '.gallery-item',
          plugins: plugins,
          licenseKey: 'D4194FDD-48924833-A54AECA3-D6F8E646',
          download: false,
          autoplayVideoOnSlide: true,
          zoomFromOrigin: false,
          youtubePlayerParams: {
            modestbranding: 1,
            showinfo: 0,
            rel: 0
          },
          vimeoPlayerParams: {
            byline: 0,
            portrait: 0,
            color: '6366f1'
          }
        });
      }
    }
  }

  // Initialize on DOMContentLoaded (initial page load)
  document.addEventListener('DOMContentLoaded', initialize);

  // Initialize on Turbo load (Turbo navigation)
  document.addEventListener('turbo:load', initialize);

})();

export default gallery;
