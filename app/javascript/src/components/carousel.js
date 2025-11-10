/**
 * Content carousel with extensive options to control behaviour and appearance
 * @requires https://github.com/nolimits4web/swiper
 * Turbo-aware: works with both initial page load and Turbo navigation
*/

const carousel = (() => {

  // forEach function
  let forEach = (array, callback, scope) => {
    for (let i = 0; i < array.length; i++) {
      callback.call(scope, i, array[i]); // passes back stuff we need
    }
  };

  function initialize() {
    // Carousel initialisation
    let carousels = document.querySelectorAll('.swiper:not(.swiper-initialized)');
    forEach(carousels, (index, value) => {
      
      let userOptions,
          pagerOptions;
      if(value.dataset.swiperOptions != undefined) userOptions = JSON.parse(value.dataset.swiperOptions);


      // Pager
      if(userOptions && userOptions.pager) {
        pagerOptions = {
          pagination: {
            el: '.pagination .list-unstyled',
            clickable: true,
            bulletActiveClass: 'active',
            bulletClass: 'page-item',
            renderBullet: function (index, className) {
              return '<li class="' + className + '"><a href="#" class="page-link btn-icon btn-sm">' + (index + 1) + '</a></li>';
            }
          }
        }
      }

      // Slider init
      let options = {...userOptions, ...pagerOptions};
      let swiper = new Swiper(value, options);


      // Tabs (linked content)
      if(userOptions && userOptions.tabs) {

        swiper.on('activeIndexChange', (e) => {
          let targetTab = document.querySelector(e.slides[e.activeIndex].dataset.swiperTab),
              previousTab = document.querySelector(e.slides[e.previousIndex].dataset.swiperTab);

          if (previousTab) previousTab.classList.remove('active');
          if (targetTab) targetTab.classList.add('active');
        });
      }

    });
  }

  // Initialize on DOMContentLoaded (initial page load)
  document.addEventListener('DOMContentLoaded', initialize);

  // Initialize on Turbo load (Turbo navigation)
  document.addEventListener('turbo:load', initialize);

})();

export default carousel;
