class SitemapController < ApplicationController
  def show
    sitemap_path = Rails.root.join('public', 'sitemap.xml')
    
    if File.exist?(sitemap_path)
      send_file sitemap_path, 
                type: 'application/xml', 
                disposition: 'inline',
                status: :ok
    else
      head :not_found
    end
  end
end

