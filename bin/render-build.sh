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
    total_size=$(du -sh public/assets 2>/dev/null | cut -f1)
    echo "Total assets size: ${total_size}"

    # Top 10 largest files (suppress errors from find/sort)
    echo "Top 10 largest asset files:"
    set +e
    find public/assets -type f -exec du -h {} \; 2>/dev/null | sort -rh 2>/dev/null | head -10 2>/dev/null || echo "  (unable to list files)"
    set -e

    # File counts by type
    echo "Asset file counts by type:"
    local css_count js_count img_count font_count
    css_count=$(find public/assets -name "*.css" -type f 2>/dev/null | wc -l)
    js_count=$(find public/assets -name "*.js" -type f 2>/dev/null | wc -l)
    img_count=$(find public/assets \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.gif" -o -name "*.svg" -o -name "*.webp" \) -type f 2>/dev/null | wc -l)
    font_count=$(find public/assets \( -name "*.woff" -o -name "*.woff2" -o -name "*.ttf" -o -name "*.eot" \) -type f 2>/dev/null | wc -l)
    echo "  CSS files: ${css_count}"
    echo "  JS files: ${js_count}"
    echo "  Image files: ${img_count}"
    echo "  Font files: ${font_count}"
}

generate_sitemap() {
    log_section "Generating sitemap"
    # Temporarily disable exit on error to allow graceful failure
    set +e
    bundle exec rake sitemap:regenerate
    local sitemap_exit_code=$?
    set -e
    
    if [[ $sitemap_exit_code -ne 0 ]]; then
        echo "⚠️  Warning: Sitemap generation failed (exit code: $sitemap_exit_code)"
        echo "   This may be due to missing database connection or other environment issues."
        echo "   Build will continue, but sitemap may need to be generated manually."
        return 0
    fi
}

run_indexnow_operations() {
    log_section "IndexNow operations"
    # IndexNow operations are optional - allow them to fail gracefully
    set +e
    bundle exec rake sitemap:generate_indexnow_key || echo "⚠️  IndexNow key generation skipped"
    bundle exec rake sitemap:ping_indexnow || echo "⚠️  IndexNow ping skipped"
    set -e
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
