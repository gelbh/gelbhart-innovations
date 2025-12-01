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
end

