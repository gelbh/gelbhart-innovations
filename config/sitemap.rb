# frozen_string_literal: true

require "sitemap_generator"

# Determine the base host with environment-aware fallback
base_host = ENV.fetch("SITEMAP_HOST", nil) ||
            Rails.application.config.action_mailer.default_url_options[:host] ||
            "gelbhart.com"

# Normalize host (remove protocol if present) and construct HTTPS URL
normalized_host = base_host.gsub(%r{^https?://}, "")
default_host = "https://#{normalized_host}"

SitemapGenerator::Sitemap.default_host = default_host
SitemapGenerator::Sitemap.public_path = "public/"
SitemapGenerator::Sitemap.sitemaps_path = ""
SitemapGenerator::Sitemap.compress = false

# Get last modification time for a view file
def view_lastmod(view_path)
  full_path = Rails.root.join("app/views", view_path)
  full_path.exist? ? File.mtime(full_path) : Time.current
rescue StandardError
  Time.current
end

# Get the most recent modification time from multiple view files
def recent_view_lastmod(*view_paths)
  view_paths.map { |path| view_lastmod(path) }.max || Time.current
end

SitemapGenerator::Sitemap.create do
  extend Rails.application.routes.url_helpers

  # Home page
  add root_path, lastmod: recent_view_lastmod("pages/index.html.erb", "layouts/application.html.erb")

  # Main pages
  add services_path, lastmod: view_lastmod("pages/services.html.erb")
  add pharmaceutical_path, lastmod: view_lastmod("pages/pharmaceutical.html.erb")
  add real_estate_path, lastmod: view_lastmod("pages/real_estate.html.erb")
  add team_path, lastmod: view_lastmod("pages/team.html.erb")
  add contact_path, lastmod: view_lastmod("pages/contact.html.erb")

  # Document pages
  add tos_path, lastmod: view_lastmod("documents/tos.html.erb")
end

