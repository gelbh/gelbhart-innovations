class SitemapController < ApplicationController
  before_action :set_no_cache_headers

  def show
    Rails.logger.info "[SitemapController] Serving sitemap"

    if accepts_gzip? && sitemap_gz_path.exist?
      send_sitemap_file(sitemap_gz_path, content_encoding: "gzip")
    elsif sitemap_xml_path.exist?
      send_sitemap_file(sitemap_xml_path)
    else
      Rails.logger.warn "[SitemapController] Sitemap not found at #{sitemap_xml_path}"
      head :not_found
    end
  rescue StandardError => e
    log_error("Error serving sitemap", e)
    head :internal_server_error
  end

  def show_gz
    if sitemap_gz_path.exist?
      send_sitemap_file(sitemap_gz_path, content_encoding: "gzip")
    else
      head :not_found
    end
  rescue StandardError => e
    log_error("Error serving compressed sitemap", e)
    head :internal_server_error
  end

  private

  def set_no_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "0"
  end

  def accepts_gzip?
    request.headers["Accept-Encoding"].to_s.include?("gzip")
  end

  def sitemap_xml_path
    @sitemap_xml_path ||= Rails.public_path.join("sitemap.xml")
  end

  def sitemap_gz_path
    @sitemap_gz_path ||= Rails.public_path.join("sitemap.xml.gz")
  end

  def send_sitemap_file(path, content_encoding: nil)
    options = {
      type: "application/xml",
      disposition: "inline",
      status: :ok
    }
    options[:content_encoding] = content_encoding if content_encoding
    send_file path, **options
  end

  def log_error(message, error)
    Rails.logger.error "#{message}: #{error.class} - #{error.message}"
    Rails.logger.error error.backtrace.join("\n") if Rails.env.development?
  end
end
