module SeoHelper
  DEFAULT_OG_IMAGE = "logo.png"
  DEFAULT_ROBOTS = "index, follow"

  # Open Graph uses underscore locales (language_TERRITORY), aligned with site locales.
  OG_LOCALE_BY_RAILS_LOCALE = {
    en: "en_US",
    es: "es_ES",
    fr: "fr_FR",
    de: "de_DE",
    it: "it_IT",
    pt: "pt_PT",
    zh: "zh_CN",
    ja: "ja_JP",
    ko: "ko_KR",
    ar: "ar_SA"
  }.freeze

  def og_meta_tags(title: nil, description: nil, image: nil, url: nil, type: "website")
    {
      "og:title" => truncate_text(title || @title || ApplicationHelper::SITE_NAME, 60),
      "og:description" => truncate_text(description || @desc || ApplicationHelper::DEFAULT_DESCRIPTION, 160),
      "og:image" => convert_to_absolute_url(image || @og_image || DEFAULT_OG_IMAGE),
      "og:url" => url || request.original_url,
      "og:type" => type,
      "og:site_name" => ApplicationHelper::SITE_NAME,
      "og:locale" => og_locale_for(I18n.locale)
    }
  end

  # Additional og:locale:alternate meta tags (one per other supported locale).
  def og_locale_alternate_properties
    primary = og_locale_for(I18n.locale)
    I18n.available_locales.filter_map do |loc|
      code = og_locale_for(loc)
      next if code == primary

      ["og:locale:alternate", code]
    end
  end

  def twitter_card_meta_tags(title: nil, description: nil, image: nil, card_type: "summary_large_image")
    {
      "twitter:card" => card_type,
      "twitter:title" => truncate_text(title || @title || ApplicationHelper::SITE_NAME, 70),
      "twitter:description" => truncate_text(description || @desc || ApplicationHelper::DEFAULT_DESCRIPTION, 200),
      "twitter:image" => convert_to_absolute_url(image || @og_image || DEFAULT_OG_IMAGE),
      "twitter:site" => "",
      "twitter:creator" => ""
    }
  end

  def canonical_url(custom_url = nil)
    custom_url || @canonical_url || request.original_url.split("?").first
  end

  def language_tags
    { "lang" => "en", "hreflang" => "en" }
  end

  def robots_meta_tag(robots = nil)
    robots || @robots || DEFAULT_ROBOTS
  end

  def meta_tag(name, content)
    return "" if content.blank?
    tag.meta(name:, content:)
  end

  def property_meta_tag(property, content)
    return "" if content.blank?
    tag.meta(property:, content:)
  end

  private

  def og_locale_for(locale)
    OG_LOCALE_BY_RAILS_LOCALE[locale.to_sym] || "en_US"
  end

  def convert_to_absolute_url(path)
    return path if path.start_with?("http")

    uri = URI.parse(request.original_url)
    base_url = "#{uri.scheme}://#{uri.host}"
    base_url += ":#{uri.port}" unless [80, 443].include?(uri.port)
    "#{base_url}#{asset_path(path)}"
  end
end
