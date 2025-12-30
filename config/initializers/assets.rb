# frozen_string_literal: true

Rails.application.config.assets.version = "1.0"

Rails.application.config.assets.paths << Rails.root.join("app/assets/vendor")
Rails.application.config.assets.paths << Rails.root.join("app/assets/favicon")
Rails.application.config.assets.paths << Rails.root.join("app/assets/builds")

Rails.application.config.assets.precompile += %w[
  application.css
  application.js
  controllers/application.js
  controllers/index.js
  src/navigation.js
  src/theme-mode.js
  src/theme.js
  theme.min.js

  logo.png
  favicon.ico
  favicon.svg
  favicon-96x96.png
  apple-touch-icon.png
  web-app-manifest-192x192.png
  web-app-manifest-512x512.png

  covers/contacts_cover.jpg
  covers/services_cover.jpg
  covers/team_cover.jpg

  team/bareket.png
  team/tomer.png
  team/yaron.png

  boxicons/css/boxicons.min.css
  bootstrap/dist/js/bootstrap.bundle.min.js
  cleave.js/dist/cleave.min.js
  jarallax/dist/jarallax.min.js
  lightgallery/css/lightgallery-bundle.min.css
  lightgallery/lightgallery.min.js
  lightgallery/plugins/fullscreen/lg-fullscreen.min.js
  lightgallery/plugins/thumbnail/lg-thumbnail.min.js
  lightgallery/plugins/video/lg-video.min.js
  lightgallery/plugins/zoom/lg-zoom.min.js
  parallax-js/dist/parallax.min.js
  rellax/rellax.min.js
  smooth-scroll/dist/smooth-scroll.min.js
  swiper/swiper-bundle.min.css
  swiper/swiper-bundle.min.js
  @lottiefiles/lottie-player/dist/lottie-player.js
  flag-icons/css/flag-icons.min.css
]
