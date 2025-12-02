# frozen_string_literal: true

require "stringio"
require "zlib"

class SitemapService
  SITEMAP_XML = "sitemap.xml"
  SITEMAP_GZ = "sitemap.xml.gz"

  def generate
    ensure_public_directory_exists
    clear_old_sitemaps
    generate_uncompressed_sitemap
    verify_sitemap_created
    create_compressed_version
  end

  private

  def ensure_public_directory_exists
    Rails.public_path.mkpath unless Rails.public_path.exist?
  end

  def clear_old_sitemaps
    [sitemap_path, gz_path].each { |path| path.delete if path.exist? }
  end

  def generate_uncompressed_sitemap
    configure_sitemap_generator
    load_sitemap_config
    configure_sitemap_generator
  end

  def configure_sitemap_generator
    SitemapGenerator::Sitemap.tap do |sitemap|
      sitemap.public_path = Rails.public_path.to_s
      sitemap.sitemaps_path = ""
      sitemap.compress = false
    end
  end

  def load_sitemap_config
    if Rails.env.test?
      silence_stdout { load sitemap_config_path }
    else
      load sitemap_config_path
    end
  end

  def silence_stdout
    original_stdout = $stdout
    $stdout = StringIO.new
    yield
  ensure
    $stdout = original_stdout
  end

  def sitemap_config_path
    Rails.root.join("config", "sitemap.rb")
  end

  def verify_sitemap_created
    return if sitemap_path.exist?

    raise build_error_message("Failed to generate sitemap.xml")
  end

  def create_compressed_version
    validate_sitemap_exists
    validate_sitemap_not_empty

    Zlib::GzipWriter.open(gz_path) { |gz| gz.write(File.read(sitemap_path)) }
  end

  def validate_sitemap_exists
    return if sitemap_path.exist?

    raise build_error_message("Cannot create compressed sitemap: sitemap.xml not found")
  end

  def validate_sitemap_not_empty
    return unless File.read(sitemap_path).empty?

    raise "Cannot create compressed sitemap: sitemap.xml exists but is empty at #{sitemap_path}"
  end

  def build_error_message(base_message)
    existing_files = Dir.glob(Rails.public_path.join("sitemap*"))
    details = []
    details << "Found files: #{existing_files.inspect}" if existing_files.any?
    details << "Public path exists: #{Rails.public_path.exist?}"
    details << "Public path writable: #{File.writable?(Rails.public_path)}" if Rails.public_path.exist?
    details << "Compress setting: #{SitemapGenerator::Sitemap.compress}"

    "#{base_message} at #{sitemap_path}. #{details.join(', ')}"
  end

  def sitemap_path
    @sitemap_path ||= Rails.public_path.join(SITEMAP_XML)
  end

  def gz_path
    @gz_path ||= Rails.public_path.join(SITEMAP_GZ)
  end
end
