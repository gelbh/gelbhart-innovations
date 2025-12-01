# IndexNow Service
# Handles communication with IndexNow API to notify search engines of content changes
# See https://www.indexnow.org/ for protocol details
module Services
  class IndexNowService
    # IndexNow API endpoints
    INDEXNOW_ENDPOINTS = [
      'https://api.indexnow.org/IndexNow',
      'https://www.bing.com/indexnow',
      'https://yandex.com/indexnow',
      'https://search.seznam.cz/indexnow',
      'https://searchadvisor.naver.com/indexnow'
    ].freeze

    # Maximum URLs per request (IndexNow limit is 10,000)
    MAX_URLS_PER_REQUEST = 10_000

    class << self
      # Ping IndexNow with a list of URLs
      # @param urls [Array<String>] Array of full URLs to notify
      # @param api_key [String] IndexNow API key (optional, uses config if not provided)
      # @param host [String] Site hostname (optional, uses config if not provided)
      # @return [Boolean] true if at least one endpoint was successfully pinged
      def ping(urls:, api_key: nil, host: nil)
        return false if urls.empty?

        api_key ||= IndexNowConfig.api_key
        host ||= IndexNowConfig.host

        return false if api_key.blank? || host.blank?

        # Remove protocol from host if present
        host = host.gsub(%r{^https?://}, '').gsub(%r{/.*$}, '')

        # Batch URLs if needed (IndexNow supports up to 10,000 URLs per request)
        url_batches = urls.each_slice(MAX_URLS_PER_REQUEST).to_a

        success = false
        url_batches.each_with_index do |url_batch, batch_index|
          Rails.logger.info "[IndexNow] Pinging #{url_batch.size} URL(s) (batch #{batch_index + 1}/#{url_batches.size})"

          INDEXNOW_ENDPOINTS.each do |endpoint|
            result = ping_endpoint(endpoint: endpoint, urls: url_batch, api_key: api_key, host: host)
            success ||= result
          end
        end

        if success
          Rails.logger.info "[IndexNow] Successfully notified search engines about #{urls.size} URL(s)"
        else
          Rails.logger.warn "[IndexNow] Failed to notify search engines about #{urls.size} URL(s)"
        end

        success
      rescue StandardError => e
        Rails.logger.error "[IndexNow] Error: #{e.class} - #{e.message}"
        Rails.logger.error e.backtrace.join("\n") if Rails.env.development?
        false
      end

      # Construct the full URL to the IndexNow API key file
      # @param host [String] Site hostname (without protocol)
      # @param api_key [String] IndexNow API key
      # @return [String] Full URL to the key file
      def key_location_url(host:, api_key:)
        "https://#{host}/#{api_key}.txt"
      end

      # Ping a single IndexNow endpoint
      # @param endpoint [String] IndexNow API endpoint URL
      # @param urls [Array<String>] Array of full URLs to notify
      # @param api_key [String] IndexNow API key
      # @param host [String] Site hostname
      # @return [Boolean] true if ping was successful
      def ping_endpoint(endpoint:, urls:, api_key:, host:)
        require 'net/http'
        require 'uri'
        require 'json'

        uri = URI.parse(endpoint)
        payload = {
          host: host,
          key: api_key,
          keyLocation: key_location_url(host: host, api_key: api_key),
          urlList: urls
        }

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme == 'https')
        http.read_timeout = 10
        http.open_timeout = 10

        request = Net::HTTP::Post.new(uri.path)
        request['Content-Type'] = 'application/json'
        request.body = payload.to_json

        response = http.request(request)

        # IndexNow returns 200 for success, 202 for accepted, or 4xx/5xx for errors
        if response.code.to_i >= 200 && response.code.to_i < 300
          Rails.logger.debug "[IndexNow] Successfully pinged #{endpoint}"
          true
        else
          response_body = response.body.to_s.strip
          if response_body.present?
            Rails.logger.warn "[IndexNow] Failed to ping #{endpoint}: HTTP #{response.code} - #{response_body}"
          else
            Rails.logger.warn "[IndexNow] Failed to ping #{endpoint}: HTTP #{response.code}"
          end
          false
        end
      rescue Net::TimeoutError, Errno::ETIMEDOUT, Timeout::Error
        Rails.logger.warn "[IndexNow] Timeout pinging #{endpoint}"
        false
      rescue StandardError => e
        Rails.logger.error "[IndexNow] Error pinging #{endpoint}: #{e.message}"
        false
      end

      # Extract URLs from sitemap XML file
      # @param sitemap_path [String] Path to sitemap.xml file
      # @return [Array<String>] Array of URLs found in sitemap
      def extract_urls_from_sitemap(sitemap_path = 'public/sitemap.xml')
        return [] unless File.exist?(sitemap_path)

        require 'rexml/document'
        xml_content = File.read(sitemap_path)
        doc = REXML::Document.new(xml_content)
        urls = []

        # Extract URLs from <loc> tags in sitemap
        # Handle both namespaced and non-namespaced sitemaps
        doc.elements.each('//urlset/url/loc') do |loc|
          url = loc.text.to_s.strip
          urls << url if url.present?
        end

        # Also try with namespace if no URLs found
        if urls.empty?
          doc.elements.each('//xmlns:urlset/xmlns:url/xmlns:loc') do |loc|
            url = loc.text.to_s.strip
            urls << url if url.present?
          end
        end

        urls
      rescue StandardError => e
        Rails.logger.error "[IndexNow] Error parsing sitemap: #{e.message}"
        []
      end
    end
  end
end

