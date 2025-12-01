# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = ENV.fetch('SITEMAP_HOST', 'https://gelbhart.com')

# Generate both compressed and uncompressed versions
SitemapGenerator::Sitemap.compress = true

# Helper module for sitemap utilities
module SitemapHelper
  # Get the most recent modification time of view files
  def self.get_view_lastmod(view_path)
    full_path = Rails.root.join('app', 'views', view_path)
    if File.exist?(full_path)
      File.mtime(full_path)
    else
      # Fallback to current time if file doesn't exist
      Time.current
    end
  rescue
    Time.current
  end
end

SitemapGenerator::Sitemap.create do
  # Home page - highest priority
  add root_path, 
      priority: 1.0, 
      changefreq: 'monthly', 
      lastmod: SitemapHelper.get_view_lastmod('pages/index.html.erb')

  # Main service pages
  add services_path, 
      priority: 0.9, 
      changefreq: 'monthly', 
      lastmod: SitemapHelper.get_view_lastmod('pages/services.html.erb')
  
  add pharmaceutical_path, 
      priority: 0.8, 
      changefreq: 'monthly', 
      lastmod: SitemapHelper.get_view_lastmod('pages/pharmaceutical.html.erb')
  
  add real_estate_path, 
      priority: 0.8, 
      changefreq: 'monthly', 
      lastmod: SitemapHelper.get_view_lastmod('pages/real_estate.html.erb')

  # Other main pages
  add team_path, 
      priority: 0.7, 
      changefreq: 'monthly', 
      lastmod: SitemapHelper.get_view_lastmod('pages/team.html.erb')
  
  add contacts_path, 
      priority: 0.6, 
      changefreq: 'yearly', 
      lastmod: SitemapHelper.get_view_lastmod('pages/contacts.html.erb')

  # Document pages
  add tos_path, 
      priority: 0.3, 
      changefreq: 'yearly', 
      lastmod: SitemapHelper.get_view_lastmod('documents/tos.html.erb')
end

