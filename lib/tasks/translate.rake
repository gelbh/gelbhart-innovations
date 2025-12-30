# frozen_string_literal: true

require "net/http"
require "json"
require "yaml"

namespace :i18n do
  desc "Translate locale files using DeepL and Google Cloud Translation APIs"
  task translate: :environment do
    Translator.new.translate_all
  end

  desc "Translate to a specific locale (e.g., rake i18n:translate_to[es])"
  task :translate_to, [:locale] => :environment do |_t, args|
    locale = args[:locale]&.to_sym
    abort "Please specify a locale: rake i18n:translate_to[es]" unless locale
    abort "Invalid locale: #{locale}" unless I18n.available_locales.include?(locale)

    Translator.new.translate_to(locale)
  end
end

class Translator
  DEEPL_LANGUAGES = %i[es fr de it pt zh ja ko ar].freeze
  GOOGLE_LANGUAGES = [].freeze

  DEEPL_LANG_CODES = { es: "ES", fr: "FR", de: "DE", it: "IT", pt: "PT-PT", zh: "ZH", ja: "JA", ko: "KO", ar: "AR" }.freeze
  GOOGLE_LANG_CODES = {}.freeze

  DEEPL_BATCH_SIZE = 50
  GOOGLE_BATCH_SIZE = 128
  API_DELAY = 0.5
  MAX_RETRIES = 3
  RATE_LIMIT_BASE_WAIT = 5

  SKIP_PATHS = %w[languages icon gradient href tel].freeze
  SKIP_COMPANY_NAMES = ["Gelbhart Innovations", "GELBHART", "INNOVATIONS"].freeze
  SKIP_PATH_PATTERNS = %w[site.name site.author pages.home.title pages.home.subtitle pages.contact.title].freeze

  def initialize
    @deepl_api_key = Rails.application.credentials.dig(:deepl, :api_key)
    @google_api_key = Rails.application.credentials.dig(:google, :translate_api_key)
    @source_file = Rails.root.join("config/locales/en.yml")
    @source_data = load_source_data
  end

  def translate_all
    (I18n.available_locales - [:en]).each { |locale| translate_to(locale) }
    puts "\n✅ All translations completed!"
  end

  def translate_to(locale)
    puts "\n🌍 Translating to #{locale}..."
    return unless api_key_configured?(locale)

    strings_to_translate = collect_strings(@source_data)
    translatable = strings_to_translate.reject { |item| skip_translation?(item[:path], item[:text]) }
    skipped_count = strings_to_translate.size - translatable.size

    puts "   Found #{strings_to_translate.size} strings, translating #{translatable.size} (#{skipped_count} skipped)"

    translations = batch_translate(translatable, locale)
    translated = rebuild_structure(@source_data, translations, locale)
    save_translation(locale, translated)

    puts "   ✓ Saved to config/locales/#{locale}.yml"
  end

  private

  def load_source_data
    YAML.safe_load_file(@source_file, permitted_classes: [Symbol])["en"]
  rescue Psych::SyntaxError => e
    abort "Error loading source file: #{e.message}"
  end

  def api_key_configured?(locale)
    if DEEPL_LANGUAGES.include?(locale) && !@deepl_api_key
      warn "   ⚠️  DeepL API key not configured. Skipping #{locale}."
      return false
    end

    if GOOGLE_LANGUAGES.include?(locale) && !@google_api_key
      warn "   ⚠️  Google Translate API key not configured. Skipping #{locale}."
      return false
    end

    true
  end

  def collect_strings(data, path = [])
    case data
    when Hash then data.flat_map { |key, value| collect_strings(value, path + [key.to_s]) }
    when Array then data.flat_map.with_index { |item, index| collect_strings(item, path + [index]) }
    when String then [{ path: path, text: data }]
    else []
    end
  end

  def batch_translate(items, locale)
    translations = {}
    provider = DEEPL_LANGUAGES.include?(locale) ? :deepl : (GOOGLE_LANGUAGES.include?(locale) ? :google : nil)
    return translations unless provider

    translate_with_provider(items, locale, translations, provider)
    translations
  end

  def translate_with_provider(items, locale, translations, provider)
    api_key = provider == :deepl ? @deepl_api_key : @google_api_key
    return unless api_key

    batch_size = provider == :deepl ? DEEPL_BATCH_SIZE : GOOGLE_BATCH_SIZE
    total_batches = (items.size.to_f / batch_size).ceil

    items.each_slice(batch_size).with_index do |batch, batch_index|
      puts "   Batch #{batch_index + 1}/#{total_batches}..."

      texts = batch.map { |item| item[:text] }
      translated_texts = send("#{provider}_translate_batch", texts, locale)

      batch.each_with_index do |item, index|
        translations[item[:path].join(".")] = translated_texts[index] || item[:text]
      end

      sleep(API_DELAY) if batch_index < total_batches - 1
    end
  end

  def deepl_translate_batch(texts, locale, retries = MAX_RETRIES)
    protected_texts, placeholder_maps = protect_placeholders(texts)
    uri = URI("https://api-free.deepl.com/v2/translate")
    request = build_deepl_request(uri, protected_texts, locale)
    response = execute_request(uri, request)

    handle_translation_response(response, texts, placeholder_maps, locale, :deepl, retries)
  rescue StandardError => e
    warn "   ⚠️  DeepL translation failed: #{e.message}"
    texts
  end

  def google_translate_batch(texts, locale, retries = MAX_RETRIES)
    protected_texts, placeholder_maps = protect_placeholders(texts)
    uri = URI("https://translation.googleapis.com/language/translate/v2")
    uri.query = URI.encode_www_form("key" => @google_api_key)
    request = build_google_request(uri, protected_texts, locale)
    response = execute_request(uri, request)

    handle_translation_response(response, texts, placeholder_maps, locale, :google, retries)
  rescue StandardError => e
    warn "   ⚠️  Google translation failed: #{e.message}"
    texts
  end

  def build_deepl_request(uri, texts, locale)
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "DeepL-Auth-Key #{@deepl_api_key}"
    request["Content-Type"] = "application/json"
    request.body = { text: texts, source_lang: "EN", target_lang: DEEPL_LANG_CODES[locale], preserve_formatting: true }.to_json
    request
  end

  def build_google_request(uri, texts, locale)
    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request.body = { q: texts, source: "en", target: GOOGLE_LANG_CODES[locale], format: "text" }.to_json
    request
  end

  def execute_request(uri, request)
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(request) }
  end

  def handle_translation_response(response, texts, placeholder_maps, locale, provider, retries)
    if response.is_a?(Net::HTTPSuccess)
      restore_placeholders(extract_translations(response, provider), placeholder_maps)
    elsif response.code == "429" && retries.positive?
      handle_rate_limit(texts, locale, provider, retries)
    else
      warn "   ⚠️  #{provider.capitalize} API error: #{response.code}#{" - #{response.body}" if provider == :google}"
      texts
    end
  end

  def extract_translations(response, provider)
    result = JSON.parse(response.body)
    case provider
    when :deepl then result["translations"].map { |t| t["text"] }
    when :google then result.dig("data", "translations")&.map { |t| t["translatedText"] } || []
    end
  end

  def handle_rate_limit(texts, locale, provider, retries)
    wait_time = (MAX_RETRIES + 1 - retries) * RATE_LIMIT_BASE_WAIT
    warn "   ⚠️  Rate limited, waiting #{wait_time}s before retry..."
    sleep(wait_time)
    send("#{provider}_translate_batch", texts, locale, retries - 1)
  end

  def rebuild_structure(data, translations, locale, path = [])
    case data
    when Hash then data.transform_keys(&:to_s).to_h { |key, value| [key, rebuild_structure(value, translations, locale, path + [key])] }
    when Array then data.map.with_index { |item, index| rebuild_structure(item, translations, locale, path + [index]) }
    when String then skip_translation?(path, data) ? data : (translations[path.join(".")] || data)
    else data
    end
  end

  def skip_translation?(path, text)
    text_str = text.to_s
    path_str = path.map(&:to_s)

    text_str.strip.empty? ||
      text_str.match?(/\A%\{[^}]+\}\z/) ||
      text_str.match?(%r{\Ahttps?://}) ||
      path_str.include?("languages") ||
      path_str.any? { |p| SKIP_PATHS.include?(p) } ||
      SKIP_COMPANY_NAMES.include?(text_str) ||
      SKIP_PATH_PATTERNS.include?(path_str.join("."))
  end

  def protect_placeholders(texts)
    placeholder_maps = []
    protected_texts = texts.map do |text|
      placeholders = {}
      counter = 0
      protected = text.gsub(/%\{([^}]+)\}/) do |match|
        key = "__PH_#{counter}__"
        placeholders[key] = match
        counter += 1
        key
      end
      placeholder_maps << placeholders
      protected
    end
    [protected_texts, placeholder_maps]
  end

  def restore_placeholders(translated_texts, placeholder_maps)
    translated_texts.zip(placeholder_maps).map { |text, placeholders| placeholders.reduce(text) { |result, (key, original)| result.gsub(key, original) } }
  end

  def save_translation(locale, translated)
    output_file = Rails.root.join("config/locales/#{locale}.yml")
    File.write(output_file, { locale.to_s => translated }.to_yaml(line_width: -1))
  end
end
