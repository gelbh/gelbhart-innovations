# frozen_string_literal: true

# IndexNow protocol configuration for instant search engine indexing
# The key file must be publicly accessible at https://{host}/{key}.txt
# Generate the key file during deployment using: rake sitemap:generate_indexnow_key
module IndexNowConfig
  class << self
    def api_key
      Rails.application.credentials.dig(:indexnow_api_key) || ENV.fetch("INDEXNOW_API_KEY", nil)
    end

    def host
      ENV.fetch("SITEMAP_HOST", "https://gelbhart.com")
        .gsub(%r{^https?://}, "")
        .gsub(%r{/.*$}, "")
    end

    def enabled?
      ENV.fetch("INDEXNOW_ENABLED", "true").casecmp("true").zero?
    end
  end
end

