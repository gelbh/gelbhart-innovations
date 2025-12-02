# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "vendor")
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "favicon")
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "builds")

# Precompile ERB-processed webmanifest
Rails.application.config.assets.precompile += %w(site.webmanifest)

# Precompile cover images (explicitly declared for production)
Rails.application.config.assets.precompile += %w(
  covers/contacts_cover.jpg
  covers/services_cover.jpg
  covers/team_cover.jpg
)

# Precompile team member images (explicitly declared for production)
Rails.application.config.assets.precompile += %w(
  team/bareket.png
  team/tomer.png
  team/yaron.png
)

# Precompile logo and favicon assets (explicitly declared for production)
Rails.application.config.assets.precompile += %w(
  logo.png
  favicon.ico
  favicon-96x96.png
  favicon.svg
  apple-touch-icon.png
  safari-pinned-tab.svg
  browserconfig.xml
)

# Precompile application assets (explicitly declared for production)
# Note: link_directory in manifest.js doesn't work for dynamically-referenced assets
Rails.application.config.assets.precompile += %w(
  application.css
  application.js
  controllers/application.js
  controllers/index.js
  src/theme.js
  src/theme-mode.js
  src/navigation.js
  theme.min.js
  src/components/audio-player.js
  src/components/carousel.js
  src/components/element-parallax.js
  src/components/form-validation.js
  src/components/gallery.js
  src/components/hover-animation.js
  src/components/input-formatter.js
  src/components/masonry-grid.js
  src/components/page-loader.js
  src/components/parallax.js
  src/components/password-visibility-toggle.js
  src/components/popover.js
  src/components/price-switch.js
  src/components/range-slider.js
  src/components/scroll-top-button.js
  src/components/smooth-scroll.js
  src/components/sticky-navbar.js
  src/components/subscription-form.js
  src/components/team-card-focus.js
  src/components/theme-mode-switch.js
  src/components/toast.js
  src/components/tooltip.js
  src/components/video-button.js
)

# Precompile vendor assets (explicitly declared for production)
# Note: link_directory in manifest.js doesn't work for dynamically-referenced assets
Rails.application.config.assets.precompile += %w(
  boxicons/css/boxicons.min.css
  swiper/swiper-bundle.min.css
  swiper/swiper-bundle.min.js
  lightgallery/css/lightgallery-bundle.min.css
  lightgallery/lightgallery.min.js
  lightgallery/plugins/fullscreen/lg-fullscreen.min.js
  lightgallery/plugins/zoom/lg-zoom.min.js
  lightgallery/plugins/video/lg-video.min.js
  lightgallery/plugins/thumbnail/lg-thumbnail.min.js
  bootstrap/dist/js/bootstrap.bundle.min.js
  smooth-scroll/dist/smooth-scroll.polyfills.min.js
  cleave.js/dist/cleave.min.js
  jarallax/dist/jarallax.min.js
  parallax-js/dist/parallax.min.js
  rellax/rellax.min.js
  @lottiefiles/lottie-player/dist/lottie-player.js
)
