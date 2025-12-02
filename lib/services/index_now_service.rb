# frozen_string_literal: true

require "net/http"
require "uri"
require "json"
require "rexml/document"

module Services
  class IndexNowService
    ENDPOINTS = [
      "https://api.indexnow.org/IndexNow",
      "https://www.bing.com/indexnow",
      "https://yandex.com/indexnow",
      "https://search.seznam.cz/indexnow",
      "https://searchadvisor.naver.com/indexnow"
    ].freeze

    MAX_URLS_PER_REQUEST = 10_000

    class << self
      def ping(urls:, api_key: nil, host: nil)
        return false if urls.empty?

        api_key ||= IndexNowConfig.api_key
        host ||= IndexNowConfig.host
        return false if api_key.blank? || host.blank?

        host = normalize_host(host)
        success = ping_url_batches(urls, api_key, host)

        log_result(success, urls.size)
        success
      rescue StandardError => e
        log_error("Error", e)
        false
      end

      def key_location_url(host:, api_key:)
        "https://#{host}/#{api_key}.txt"
      end

      def ping_endpoint(endpoint:, urls:, api_key:, host:)
        uri = URI.parse(endpoint)
        response = send_request(uri, build_payload(urls, api_key, host))

        handle_response(endpoint, response)
      rescue Net::TimeoutError, Errno::ETIMEDOUT, Timeout::Error
        Rails.logger.warn "[IndexNow] Timeout pinging #{endpoint}"
        false
      rescue StandardError => e
        Rails.logger.error "[IndexNow] Error pinging #{endpoint}: #{e.message}"
        false
      end

      def extract_urls_from_sitemap(sitemap_path = "public/sitemap.xml")
        return [] unless File.exist?(sitemap_path)

        doc = REXML::Document.new(File.read(sitemap_path))
        extract_urls_from_doc(doc)
      rescue StandardError => e
        Rails.logger.error "[IndexNow] Error parsing sitemap: #{e.message}"
        []
      end

      private

      def normalize_host(host)
        host.gsub(%r{^https?://}, "").gsub(%r{/.*$}, "")
      end

      def ping_url_batches(urls, api_key, host)
        url_batches = urls.each_slice(MAX_URLS_PER_REQUEST).to_a
        success = false

        url_batches.each_with_index do |url_batch, batch_index|
          Rails.logger.info "[IndexNow] Pinging #{url_batch.size} URL(s) (batch #{batch_index + 1}/#{url_batches.size})"

          ENDPOINTS.each do |endpoint|
            result = ping_endpoint(endpoint:, urls: url_batch, api_key:, host:)
            success ||= result
          end
        end

        success
      end

      def build_payload(urls, api_key, host)
        {
          host:,
          key: api_key,
          keyLocation: key_location_url(host:, api_key:),
          urlList: urls
        }
      end

      def send_request(uri, payload)
        http = Net::HTTP.new(uri.host, uri.port).tap do |h|
          h.use_ssl = uri.scheme == "https"
          h.read_timeout = 10
          h.open_timeout = 10
        end

        request = Net::HTTP::Post.new(uri.path).tap do |r|
          r["Content-Type"] = "application/json"
          r.body = payload.to_json
        end

        http.request(request)
      end

      def handle_response(endpoint, response)
        code = response.code.to_i

        if code.between?(200, 299)
          Rails.logger.debug "[IndexNow] Successfully pinged #{endpoint}"
          true
        else
          log_failed_ping(endpoint, response)
          false
        end
      end

      def log_failed_ping(endpoint, response)
        response_body = response.body.to_s.strip
        message = "[IndexNow] Failed to ping #{endpoint}: HTTP #{response.code}"
        message += " - #{response_body}" if response_body.present?
        Rails.logger.warn message
      end

      def extract_urls_from_doc(doc)
        urls = extract_with_xpath(doc, "//urlset/url/loc")
        urls = extract_with_xpath(doc, "//xmlns:urlset/xmlns:url/xmlns:loc") if urls.empty?
        urls
      end

      def extract_with_xpath(doc, xpath)
        urls = []
        doc.elements.each(xpath) do |loc|
          url = loc.text.to_s.strip
          urls << url if url.present?
        end
        urls
      end

      def log_result(success, url_count)
        if success
          Rails.logger.info "[IndexNow] Successfully notified search engines about #{url_count} URL(s)"
        else
          Rails.logger.warn "[IndexNow] Failed to notify search engines about #{url_count} URL(s)"
        end
      end

      def log_error(message, error)
        Rails.logger.error "[IndexNow] #{message}: #{error.class} - #{error.message}"
        Rails.logger.error error.backtrace.join("\n") if Rails.env.development?
      end
    end
  end
end
