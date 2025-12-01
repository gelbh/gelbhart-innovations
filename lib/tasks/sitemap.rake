namespace :sitemap do
  desc "Regenerate sitemap (use this in deployment hooks)"
  task regenerate: :environment do
    puts "Regenerating sitemap..."
    Rake::Task['sitemap:refresh:no_ping'].invoke
    
    # Extract uncompressed version if only .gz was generated
    if File.exist?('public/sitemap.xml.gz') && !File.exist?('public/sitemap.xml')
      puts "Extracting uncompressed sitemap..."
      system('gunzip -c public/sitemap.xml.gz > public/sitemap.xml')
    end
    
    puts "✅ Sitemap regeneration complete"
  end

  desc "Generate IndexNow API key file from environment variable"
  task generate_indexnow_key: :environment do
    api_key = IndexNowConfig.api_key
    
    if api_key.blank?
      puts "⚠️  INDEXNOW_API_KEY not set. Skipping key file generation."
      next
    end

    key_file_path = Rails.root.join('public', "#{api_key}.txt")
    
    # Create the key file with the API key value
    File.write(key_file_path, api_key)
    
    puts "✅ IndexNow key file generated: #{key_file_path}"
    puts "   Key file will be accessible at: https://#{IndexNowConfig.host}/#{api_key}.txt"
  end

  desc "Ping IndexNow with URLs from sitemap"
  task ping_indexnow: :environment do
    # Explicitly require the service class for rake tasks
    require_relative '../services/indexnow_service'
    
    unless IndexNowConfig.enabled?
      puts "IndexNow is disabled (INDEXNOW_ENABLED=false). Skipping ping."
      next
    end

    sitemap_path = Rails.root.join('public', 'sitemap.xml')
    
    unless File.exist?(sitemap_path)
      puts "⚠️  Sitemap not found at #{sitemap_path}. Skipping IndexNow ping."
      next
    end

    puts "Extracting URLs from sitemap..."
    urls = IndexNowService.extract_urls_from_sitemap(sitemap_path.to_s)
    
    if urls.empty?
      puts "⚠️  No URLs found in sitemap. Skipping IndexNow ping."
      next
    end

    puts "Pinging IndexNow with #{urls.size} URL(s)..."
    
    begin
      success = IndexNowService.ping(urls: urls)
      
      if success
        puts "✅ Successfully notified IndexNow about #{urls.size} URL(s)"
      else
        puts "⚠️  Failed to notify IndexNow (check logs for details)"
      end
    rescue StandardError => e
      puts "❌ Error pinging IndexNow: #{e.message}"
      Rails.logger.error "[IndexNow Rake Task] Error: #{e.class} - #{e.message}"
      Rails.logger.error e.backtrace.join("\n") if Rails.env.development?
      # Don't fail the task - IndexNow is optional
    end
  end
end

