# IndexNow Configuration
# Configuration for IndexNow protocol integration
module IndexNowConfig
  # Get IndexNow API key from environment variable
  # The key file must be publicly accessible at https://{host}/{key}.txt
  # Generate the key file during deployment using: rake sitemap:generate_indexnow_key
  def self.api_key
    ENV.fetch('INDEXNOW_API_KEY', nil)
  end

  # Get site hostname for IndexNow requests
  # Defaults to SITEMAP_HOST or gelbhart.com
  def self.host
    ENV.fetch('SITEMAP_HOST', 'https://gelbhart.com')
           .gsub(%r{^https?://}, '')
           .gsub(%r{/.*$}, '')
  end

  # Check if IndexNow is enabled
  # Can be disabled via INDEXNOW_ENABLED=false environment variable
  def self.enabled?
    ENV.fetch('INDEXNOW_ENABLED', 'true').downcase == 'true'
  end
end

