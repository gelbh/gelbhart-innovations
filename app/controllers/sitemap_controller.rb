class SitemapController < ApplicationController
  def show
    sitemap_xml_path = Rails.root.join('public', 'sitemap.xml')
    sitemap_gz_path = Rails.root.join('public', 'sitemap.xml.gz')
    
    # Check if client accepts gzip encoding
    accepts_gzip = request.headers['Accept-Encoding'].to_s.include?('gzip')
    
    # Prefer compressed version if available and client supports it
    if accepts_gzip && File.exist?(sitemap_gz_path)
      send_file sitemap_gz_path,
                type: 'application/xml',
                disposition: 'inline',
                status: :ok,
                content_encoding: 'gzip'
    elsif File.exist?(sitemap_xml_path)
      send_file sitemap_xml_path,
                type: 'application/xml',
                disposition: 'inline',
                status: :ok
    else
      head :not_found
    end
  end

  def show_gz
    sitemap_gz_path = Rails.root.join('public', 'sitemap.xml.gz')
    
    if File.exist?(sitemap_gz_path)
      send_file sitemap_gz_path,
                type: 'application/xml',
                disposition: 'inline',
                status: :ok,
                content_encoding: 'gzip'
    else
      head :not_found
    end
  end
end

