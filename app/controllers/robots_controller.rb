class RobotsController < ApplicationController
  def show
    render plain: robots_content, content_type: "text/plain"
  end

  private

  def robots_content
    <<~ROBOTS
      User-agent: *
      Allow: /

      Sitemap: #{sitemap_url}
    ROBOTS
  end

  def sitemap_url
    "#{ENV.fetch('SITEMAP_HOST', 'https://gelbhart.com')}/sitemap.xml"
  end
end
