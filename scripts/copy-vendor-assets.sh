#!/usr/bin/env bash
# Copy only necessary vendor assets from node_modules to app/assets/vendor
# This script copies only the files actually used by the Rails asset pipeline

set -euo pipefail

VENDOR_DIR="app/assets/vendor"
NODE_MODULES="node_modules"

# Create vendor directory
mkdir -p "$VENDOR_DIR"

# Copy CSS files
echo "Copying CSS assets..."
mkdir -p "$VENDOR_DIR/boxicons/css"
cp "$NODE_MODULES/boxicons/css/boxicons.min.css" "$VENDOR_DIR/boxicons/css/" 2>/dev/null || true

mkdir -p "$VENDOR_DIR/flag-icons/css"
cp "$NODE_MODULES/flag-icons/css"/*.css "$VENDOR_DIR/flag-icons/css/" 2>/dev/null || true
# Copy flag images if needed
if [ -d "$NODE_MODULES/flag-icons/flags" ]; then
  cp -r "$NODE_MODULES/flag-icons/flags" "$VENDOR_DIR/flag-icons/" 2>/dev/null || true
fi

mkdir -p "$VENDOR_DIR/lightgallery/css"
cp "$NODE_MODULES/lightgallery/css"/*.css "$VENDOR_DIR/lightgallery/css/" 2>/dev/null || true

mkdir -p "$VENDOR_DIR/swiper"
cp "$NODE_MODULES/swiper/swiper-bundle.min.css" "$VENDOR_DIR/swiper/" 2>/dev/null || true

# Copy JavaScript files
echo "Copying JavaScript assets..."
mkdir -p "$VENDOR_DIR/bootstrap/dist/js"
cp "$NODE_MODULES/bootstrap/dist/js/bootstrap.bundle.min.js" "$VENDOR_DIR/bootstrap/dist/js/" 2>/dev/null || true

mkdir -p "$VENDOR_DIR/cleave.js/dist"
cp "$NODE_MODULES/cleave.js/dist/cleave.min.js" "$VENDOR_DIR/cleave.js/dist/" 2>/dev/null || true

mkdir -p "$VENDOR_DIR/jarallax/dist"
cp "$NODE_MODULES/jarallax/dist/jarallax.min.js" "$VENDOR_DIR/jarallax/dist/" 2>/dev/null || true

mkdir -p "$VENDOR_DIR/lightgallery"
cp "$NODE_MODULES/lightgallery/lightgallery.min.js" "$VENDOR_DIR/lightgallery/" 2>/dev/null || true

mkdir -p "$VENDOR_DIR/lightgallery/plugins/fullscreen"
cp "$NODE_MODULES/lightgallery/plugins/fullscreen/lg-fullscreen.min.js" "$VENDOR_DIR/lightgallery/plugins/fullscreen/" 2>/dev/null || true

mkdir -p "$VENDOR_DIR/lightgallery/plugins/thumbnail"
cp "$NODE_MODULES/lightgallery/plugins/thumbnail/lg-thumbnail.min.js" "$VENDOR_DIR/lightgallery/plugins/thumbnail/" 2>/dev/null || true

mkdir -p "$VENDOR_DIR/lightgallery/plugins/video"
cp "$NODE_MODULES/lightgallery/plugins/video/lg-video.min.js" "$VENDOR_DIR/lightgallery/plugins/video/" 2>/dev/null || true

mkdir -p "$VENDOR_DIR/lightgallery/plugins/zoom"
cp "$NODE_MODULES/lightgallery/plugins/zoom/lg-zoom.min.js" "$VENDOR_DIR/lightgallery/plugins/zoom/" 2>/dev/null || true

mkdir -p "$VENDOR_DIR/parallax-js/dist"
cp "$NODE_MODULES/parallax-js/dist/parallax.min.js" "$VENDOR_DIR/parallax-js/dist/" 2>/dev/null || true

mkdir -p "$VENDOR_DIR/rellax"
cp "$NODE_MODULES/rellax/rellax.min.js" "$VENDOR_DIR/rellax/" 2>/dev/null || true

mkdir -p "$VENDOR_DIR/smooth-scroll/dist"
cp "$NODE_MODULES/smooth-scroll/dist/smooth-scroll.min.js" "$VENDOR_DIR/smooth-scroll/dist/" 2>/dev/null || true

mkdir -p "$VENDOR_DIR/swiper"
cp "$NODE_MODULES/swiper/swiper-bundle.min.js" "$VENDOR_DIR/swiper/" 2>/dev/null || true

mkdir -p "$VENDOR_DIR/@lottiefiles/lottie-player/dist"
cp "$NODE_MODULES/@lottiefiles/lottie-player/dist/lottie-player.js" "$VENDOR_DIR/@lottiefiles/lottie-player/dist/" 2>/dev/null || true

echo "Vendor assets copied successfully"

