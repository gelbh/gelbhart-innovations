module SeoHelper
  # Default site name
  SITE_NAME = "Gelbhart Innovations"
  DEFAULT_OG_IMAGE = "logo.png" # Will be converted to full URL

  # Generate Open Graph meta tags
  def og_meta_tags(title: nil, description: nil, image: nil, url: nil, type: "website")
    title ||= @title || SITE_NAME
    description ||= @desc || default_description
    image ||= @og_image || DEFAULT_OG_IMAGE
    url ||= request.original_url

    # Convert relative image path to absolute URL
    image_url = image.start_with?("http") ? image : asset_url(image)

    {
      "og:title" => truncate_text(title, 60),
      "og:description" => truncate_text(description, 160),
      "og:image" => image_url,
      "og:url" => url,
      "og:type" => type,
      "og:site_name" => SITE_NAME,
      "og:locale" => "en_US"
    }
  end

  # Generate Twitter Card meta tags
  def twitter_card_meta_tags(title: nil, description: nil, image: nil, card_type: "summary_large_image")
    title ||= @title || SITE_NAME
    description ||= @desc || default_description
    image ||= @og_image || DEFAULT_OG_IMAGE

    # Convert relative image path to absolute URL
    image_url = image.start_with?("http") ? image : asset_url(image)

    {
      "twitter:card" => card_type,
      "twitter:title" => truncate_text(title, 70),
      "twitter:description" => truncate_text(description, 200),
      "twitter:image" => image_url,
      "twitter:site" => "",
      "twitter:creator" => ""
    }
  end

  # Generate canonical URL
  def canonical_url(custom_url = nil)
    custom_url || @canonical_url || request.original_url.split("?").first
  end

  # Generate language and alternate language tags
  def language_tags
    {
      "lang" => "en",
      "hreflang" => "en"
    }
  end

  # Generate robots meta tag
  def robots_meta_tag(robots = nil)
    robots || @robots || "index, follow"
  end

  # Render meta tag
  def meta_tag(name, content)
    return "" if content.blank?
    tag.meta(name: name, content: content)
  end

  # Render property meta tag (for Open Graph)
  def property_meta_tag(property, content)
    return "" if content.blank?
    tag.meta(property: property, content: content)
  end

  # Default description fallback
  def default_description
    "Gelbhart Innovations provides innovative solutions creating value through comprehensive consulting services in pharmaceutical and real estate industries."
  end

  # Truncate text to specified length
  def truncate_text(text, length)
    return "" if text.blank?
    text.length > length ? "#{text[0..length - 4]}..." : text
  end

  # Convert asset path to full URL
  def asset_url(asset_path)
    return asset_path if asset_path.start_with?("http")
    uri = URI.parse(request.original_url)
    base_url = "#{uri.scheme}://#{uri.host}"
    base_url += ":#{uri.port}" unless [80, 443].include?(uri.port)
    "#{base_url}#{asset_path(asset_path)}"
  end
end

