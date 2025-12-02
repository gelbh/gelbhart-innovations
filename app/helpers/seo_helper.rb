module SeoHelper
  DEFAULT_OG_IMAGE = "logo.png"
  DEFAULT_ROBOTS = "index, follow"

  def og_meta_tags(title: nil, description: nil, image: nil, url: nil, type: "website")
    {
      "og:title" => truncate_text(title || @title || ApplicationHelper::SITE_NAME, 60),
      "og:description" => truncate_text(description || @desc || ApplicationHelper::DEFAULT_DESCRIPTION, 160),
      "og:image" => convert_to_absolute_url(image || @og_image || DEFAULT_OG_IMAGE),
      "og:url" => url || request.original_url,
      "og:type" => type,
      "og:site_name" => ApplicationHelper::SITE_NAME,
      "og:locale" => "en_US"
    }
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

  def convert_to_absolute_url(path)
    return path if path.start_with?("http")

    uri = URI.parse(request.original_url)
    base_url = "#{uri.scheme}://#{uri.host}"
    base_url += ":#{uri.port}" unless [80, 443].include?(uri.port)
    "#{base_url}#{asset_path(path)}"
  end
end
