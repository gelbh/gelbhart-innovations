namespace :sitemap do
  desc "Regenerate sitemap (use this in deployment hooks)"
  task regenerate: :environment do
    puts "Regenerating sitemap..."
    
    begin
      Rake::Task['sitemap:refresh:no_ping'].invoke
    rescue StandardError => e
      puts "❌ Error generating sitemap: #{e.class} - #{e.message}"
      Rails.logger.error "[Sitemap] Generation error: #{e.class} - #{e.message}"
      Rails.logger.error e.backtrace.join("\n") if Rails.env.development?
      raise
    end
    
    # Extract uncompressed version if only .gz was generated
    sitemap_xml_path = Rails.root.join('public', 'sitemap.xml')
    sitemap_gz_path = Rails.root.join('public', 'sitemap.xml.gz')
    
    if File.exist?(sitemap_gz_path) && !File.exist?(sitemap_xml_path)
      puts "Extracting uncompressed sitemap..."
      result = system('gunzip -c public/sitemap.xml.gz > public/sitemap.xml')
      unless result
        puts "⚠️  Warning: Failed to extract uncompressed sitemap"
      end
    end
    
    # Verify sitemap was created successfully
    if File.exist?(sitemap_xml_path)
      file_size = File.size(sitemap_xml_path)
      puts "✅ Sitemap regeneration complete"
      puts "   Location: #{sitemap_xml_path}"
      puts "   Size: #{file_size} bytes"
      
      # Basic XML validation
      begin
        require 'rexml/document'
        doc = REXML::Document.new(File.read(sitemap_xml_path))
        url_count = doc.elements.to_a('//url').size
        puts "   URLs: #{url_count}"
      rescue StandardError => e
        puts "⚠️  Warning: Could not validate XML structure: #{e.message}"
      end
    elsif File.exist?(sitemap_gz_path)
      puts "✅ Sitemap regeneration complete (compressed only)"
      puts "   Location: #{sitemap_gz_path}"
      puts "   Size: #{File.size(sitemap_gz_path)} bytes"
      puts "⚠️  Note: Uncompressed version not found, but .gz file exists"
    else
      puts "❌ Error: Sitemap file was not created!"
      puts "   Expected location: #{sitemap_xml_path}"
      raise "Sitemap generation failed - no output file created"
    end
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
    urls = Services::IndexNowService.extract_urls_from_sitemap(sitemap_path.to_s)
    
    if urls.empty?
      puts "⚠️  No URLs found in sitemap. Skipping IndexNow ping."
      next
    end

    puts "Pinging IndexNow with #{urls.size} URL(s)..."
    
    begin
      success = Services::IndexNowService.ping(urls: urls)
      
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

