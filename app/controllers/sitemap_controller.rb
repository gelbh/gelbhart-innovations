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
      # Fallback: try to generate sitemap on-the-fly if file doesn't exist
      Rails.logger.warn "Sitemap not found at #{sitemap_xml_path}, attempting to generate..."
      generate_sitemap_fallback
    end
  rescue StandardError => e
    Rails.logger.error "Error serving sitemap: #{e.class} - #{e.message}"
    Rails.logger.error e.backtrace.join("\n") if Rails.env.development?
    head :internal_server_error
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
  rescue StandardError => e
    Rails.logger.error "Error serving compressed sitemap: #{e.class} - #{e.message}"
    Rails.logger.error e.backtrace.join("\n") if Rails.env.development?
    head :internal_server_error
  end

  private

  def generate_sitemap_fallback
    # Attempt to generate sitemap on-the-fly as a fallback
    begin
      Rake::Task['sitemap:refresh:no_ping'].invoke
      
      sitemap_xml_path = Rails.root.join('public', 'sitemap.xml')
      sitemap_gz_path = Rails.root.join('public', 'sitemap.xml.gz')
      
      # Extract uncompressed version if only .gz was generated
      if File.exist?(sitemap_gz_path) && !File.exist?(sitemap_xml_path)
        system('gunzip -c public/sitemap.xml.gz > public/sitemap.xml')
      end
      
      if File.exist?(sitemap_xml_path)
        send_file sitemap_xml_path,
                  type: 'application/xml',
                  disposition: 'inline',
                  status: :ok
      else
        Rails.logger.error "Failed to generate sitemap fallback"
        head :not_found
      end
    rescue StandardError => e
      Rails.logger.error "Error generating sitemap fallback: #{e.class} - #{e.message}"
      head :not_found
    end
  end
end

