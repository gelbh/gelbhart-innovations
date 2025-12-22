#!/usr/bin/env bash
#
# Render Build Script
# Handles Ruby dependencies, asset compilation, sitemap generation, and IndexNow operations
#

# Strict mode: exit on error, unset variables, and pipeline failures
set -euo pipefail

# Error trap for better debugging
trap 'echo "Error: Build failed at line $LINENO. Exit code: $?" >&2' ERR

# -----------------------------------------------------------------------------
# Helper Functions
# -----------------------------------------------------------------------------

log_section() {
    echo "--- $1 ---"
}

log_timing() {
    local start_time=$1
    local end_time=$2
    local label=$3
    echo "${label} completed in $((end_time - start_time)) seconds"
}

# -----------------------------------------------------------------------------
# Build Steps
# -----------------------------------------------------------------------------

install_dependencies() {
    log_section "Installing Ruby dependencies"
    bundle install
}

compile_assets() {
    log_section "Compiling assets"
    local start_time
    start_time=$(date +%s)

    # Compile SCSS using Dart Sass (must run before Sprockets asset precompilation)
    echo "Building SCSS with dartsass-rails..."
    bundle exec rails dartsass:build

    # Run Sprockets asset precompilation (picks up pre-compiled CSS from app/assets/builds/)
    bundle exec rails assets:precompile

    local end_time
    end_time=$(date +%s)
    log_timing "$start_time" "$end_time" "Asset compilation"
}

report_asset_sizes() {
    log_section "Asset Size Report"

    if [[ ! -d "public/assets" ]]; then
        echo "No public/assets directory found"
        return 0
    fi

    # Total size
    local total_size
    total_size=$(du -sh public/assets | cut -f1)
    echo "Total assets size: ${total_size}"

    # Top 10 largest files
    echo "Top 10 largest asset files:"
    find public/assets -type f -exec du -h {} \; 2>/dev/null | sort -rh | head -10

    # File counts by type
    echo "Asset file counts by type:"
    echo "  CSS files: $(find public/assets -name "*.css" -type f 2>/dev/null | wc -l)"
    echo "  JS files: $(find public/assets -name "*.js" -type f 2>/dev/null | wc -l)"
    echo "  Image files: $(find public/assets \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.gif" -o -name "*.svg" -o -name "*.webp" \) -type f 2>/dev/null | wc -l)"
    echo "  Font files: $(find public/assets \( -name "*.woff" -o -name "*.woff2" -o -name "*.ttf" -o -name "*.eot" \) -type f 2>/dev/null | wc -l)"
}

generate_sitemap() {
    log_section "Generating sitemap"
    bundle exec rake sitemap:regenerate
}

run_indexnow_operations() {
    log_section "IndexNow operations"
    bundle exec rake sitemap:generate_indexnow_key
    bundle exec rake sitemap:ping_indexnow
}

# -----------------------------------------------------------------------------
# Main Entry Point
# -----------------------------------------------------------------------------

main() {
    echo "=== Build Started ==="
    local build_start
    build_start=$(date +%s)

    install_dependencies
    compile_assets
    report_asset_sizes
    generate_sitemap
    run_indexnow_operations

    local build_end
    build_end=$(date +%s)
    echo "=== Build Completed in $((build_end - build_start)) seconds ==="
}

main "$@"
