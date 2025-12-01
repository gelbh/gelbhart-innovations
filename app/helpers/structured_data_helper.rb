module StructuredDataHelper
  # Generate Organization JSON-LD schema
  def organization_schema
    {
      "@context" => "https://schema.org",
      "@type" => "Organization",
      "name" => "Gelbhart Innovations",
      "url" => root_url,
      "logo" => asset_url("logo.png"),
      "description" => "Innovative solutions creating value through comprehensive consulting services in pharmaceutical and real estate industries.",
      "sameAs" => ["https://www.linkedin.com/in/tomer-gelbhart/", 
                   "https://www.linkedin.com/in/yaron-gelbhart/", 
                   "https://www.linkedin.com/in/bareket-gelbhart-83904a16/", 
                   "https://github.com/gelbh",
                   "https://github.com/gelbh/gelbhart-innovations"
      ]
    }
  end

  # Generate WebSite JSON-LD schema
  def website_schema
    {
      "@context" => "https://schema.org",
      "@type" => "WebSite",
      "name" => "Gelbhart Innovations",
      "url" => root_url,
      "potentialAction" => {
        "@type" => "SearchAction",
        "target" => {
          "@type" => "EntryPoint",
          "urlTemplate" => "#{root_url}?q={search_term_string}"
        },
        "query-input" => "required name=search_term_string"
      }
    }
  end

  # Generate BreadcrumbList JSON-LD schema
  def breadcrumb_list_schema(items)
    return nil if items.blank? || items.length < 2

    list_items = items.each_with_index.map do |item, index|
      {
        "@type" => "ListItem",
        "position" => index + 1,
        "name" => item[:name],
        "item" => item[:url] || item[:path]
      }
    end

    {
      "@context" => "https://schema.org",
      "@type" => "BreadcrumbList",
      "itemListElement" => list_items
    }
  end

  # Generate Person JSON-LD schema (for team members)
  def person_schema(name:, job_title: nil, description: nil, image: nil, url: nil, same_as: [])
    schema = {
      "@context" => "https://schema.org",
      "@type" => "Person",
      "name" => name
    }

    schema["jobTitle"] = job_title if job_title.present?
    schema["description"] = description if description.present?
    schema["image"] = image if image.present?
    schema["url"] = url if url.present?
    schema["sameAs"] = same_as if same_as.present?

    schema
  end

  # Generate Service JSON-LD schema
  def service_schema(name:, description:, provider: "Gelbhart Innovations", url: nil)
    schema = {
      "@context" => "https://schema.org",
      "@type" => "Service",
      "name" => name,
      "description" => description,
      "provider" => {
        "@type" => "Organization",
        "name" => provider
      }
    }

    schema["url"] = url if url.present?
    schema
  end

  # Generate LocalBusiness schema (if applicable)
  def local_business_schema(name:, address:, phone: nil, email: nil, url: nil)
    schema = {
      "@context" => "https://schema.org",
      "@type" => "LocalBusiness",
      "name" => name,
      "address" => address
    }

    schema["telephone"] = phone if phone.present?
    schema["email"] = email if email.present?
    schema["url"] = url if url.present?

    schema
  end

  # Render JSON-LD script tag
  def json_ld_script(data)
    return "" if data.blank?
    content_tag(:script, data.to_json.html_safe, type: "application/ld+json")
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

