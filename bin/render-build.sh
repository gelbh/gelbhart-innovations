#!/usr/bin/env bash
# exit on error
set -o errexit

echo "=== Build Started ==="
BUILD_START=$(date +%s)

# Install Ruby dependencies
echo "--- Installing Ruby dependencies ---"
bundle install

# Compile assets
echo "--- Compiling assets ---"
ASSETS_START=$(date +%s)
bundle exec rails assets:precompile
ASSETS_END=$(date +%s)
echo "Asset compilation completed in $((ASSETS_END - ASSETS_START)) seconds"

# Report asset sizes
echo "--- Asset Size Report ---"
if [ -d "public/assets" ]; then
  # Total size of all assets
  TOTAL_SIZE=$(du -sh public/assets | cut -f1)
  echo "Total assets size: $TOTAL_SIZE"
  
  # Top 10 largest files
  echo "Top 10 largest asset files:"
  find public/assets -type f -exec du -h {} \; 2>/dev/null | sort -rh | head -10
  
  # Count of files by type
  echo "Asset file counts by type:"
  echo "  CSS files: $(find public/assets -name "*.css" -type f 2>/dev/null | wc -l)"
  echo "  JS files: $(find public/assets -name "*.js" -type f 2>/dev/null | wc -l)"
  echo "  Image files: $(find public/assets \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.gif" -o -name "*.svg" -o -name "*.webp" \) -type f 2>/dev/null | wc -l)"
  echo "  Font files: $(find public/assets \( -name "*.woff" -o -name "*.woff2" -o -name "*.ttf" -o -name "*.eot" \) -type f 2>/dev/null | wc -l)"
fi

# Generate sitemap
echo "--- Generating sitemap ---"
bundle exec rake sitemap:regenerate

# Generate IndexNow key file and ping
echo "--- IndexNow operations ---"
bundle exec rake sitemap:generate_indexnow_key
bundle exec rake sitemap:ping_indexnow

BUILD_END=$(date +%s)
echo "=== Build Completed in $((BUILD_END - BUILD_START)) seconds ==="
