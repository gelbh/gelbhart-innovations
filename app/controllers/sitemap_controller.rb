class SitemapController < ApplicationController
  def show
    # Set no-cache headers to ensure search engines always get fresh sitemaps
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "0"

    Rails.logger.info "[SitemapController] Serving sitemap (new code path)"
    sitemap_xml_path = Rails.public_path.join('sitemap.xml')
    sitemap_gz_path = Rails.public_path.join('sitemap.xml.gz')
    
    # Check if client accepts gzip encoding
    accepts_gzip = request.headers['Accept-Encoding'].to_s.include?('gzip')
    
    # Prefer compressed version if available and client supports it
    if accepts_gzip && sitemap_gz_path.exist?
      send_file sitemap_gz_path,
                type: 'application/xml',
                disposition: 'inline',
                status: :ok,
                content_encoding: 'gzip'
    elsif sitemap_xml_path.exist?
      send_file sitemap_xml_path,
                type: 'application/xml',
                disposition: 'inline',
                status: :ok
    else
      Rails.logger.warn "[SitemapController] Sitemap not found at #{sitemap_xml_path} - returning 404"
      head :not_found
    end
  rescue StandardError => e
    Rails.logger.error "Error serving sitemap: #{e.class} - #{e.message}"
    Rails.logger.error e.backtrace.join("\n") if Rails.env.development?
    head :internal_server_error
  end

  def show_gz
    # Set no-cache headers to ensure search engines always get fresh sitemaps
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "0"

    sitemap_gz_path = Rails.public_path.join('sitemap.xml.gz')
    
    if sitemap_gz_path.exist?
      send_file sitemap_gz_path,
                type: 'application/xml',
                disposition: 'inline',
                status: :ok,
                content_encoding: 'gzip'
    else
      head :not_found
    end
  rescue StandardError => e
    Rails.logger.error "Error serving compressed sitemap: #{e.class} - #{e.message}"
    Rails.logger.error e.backtrace.join("\n") if Rails.env.development?
    head :internal_server_error
  end
end

