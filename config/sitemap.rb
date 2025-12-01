# Sitemap configuration using sitemap_generator gem
require "sitemap_generator"

# Use environment-aware domain with fallback
base_host = ENV.fetch("SITEMAP_HOST", nil) ||
            Rails.application.config.action_mailer.default_url_options[:host] ||
            "gelbhart.com"

# Remove protocol if present and add https
base_host = base_host.gsub(/^https?:\/\//, "")
default_host = "https://#{base_host}"

SitemapGenerator::Sitemap.default_host = default_host
SitemapGenerator::Sitemap.public_path = "public/"
SitemapGenerator::Sitemap.sitemaps_path = ""
# Create both compressed and uncompressed files
SitemapGenerator::Sitemap.compress = false

# Helper method to get last modification time for view files
def get_view_lastmod(view_path)
  full_path = Rails.root.join("app", "views", view_path)
  return Time.current unless full_path.exist?

  File.mtime(full_path)
rescue StandardError
  Time.current
end

# Helper method to get last modification time for multiple view files (uses most recent)
def get_multiple_views_lastmod(*view_paths)
  times = view_paths.map { |path| get_view_lastmod(path) }
  times.max || Time.current
end

SitemapGenerator::Sitemap.create do
  # Include Rails URL helpers in this block's context
  extend Rails.application.routes.url_helpers
  
  # Home page
  home_lastmod = get_multiple_views_lastmod("pages/index.html.erb", "layouts/application.html.erb")
  add root_path, lastmod: home_lastmod

  # Main service pages
  add services_path, lastmod: get_view_lastmod('pages/services.html.erb')
  
  # Service category pages
  add pharmaceutical_path, lastmod: get_view_lastmod('pages/pharmaceutical.html.erb')
  
  add real_estate_path, lastmod: get_view_lastmod('pages/real_estate.html.erb')

  # Other main pages
  add team_path, lastmod: get_view_lastmod('pages/team.html.erb')
  
  add contacts_path, lastmod: get_view_lastmod('pages/contacts.html.erb')

  # Document pages
  add tos_path, lastmod: get_view_lastmod('documents/tos.html.erb')
end

