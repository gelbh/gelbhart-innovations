class RobotsController < ApplicationController
  def show
    sitemap_url = ENV.fetch('SITEMAP_HOST', 'https://gelbhart.com') + '/sitemap.xml'
    
    robots_txt = <<~ROBOTS
      # See https://www.robotstxt.org/robotstxt.html for documentation on how to use the robots.txt file

      # Allow all search engines to crawl all content
      User-agent: *
      Allow: /

      # Disallow admin and private areas (if any exist in the future)
      # Disallow: /admin/
      # Disallow: /private/

      # Sitemap location
      Sitemap: #{sitemap_url}
    ROBOTS

    render plain: robots_txt, content_type: 'text/plain'
  end
end

