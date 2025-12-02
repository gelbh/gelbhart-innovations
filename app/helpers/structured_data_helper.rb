module StructuredDataHelper
  ORGANIZATION_NAME = "Gelbhart Innovations"
  ORGANIZATION_SAME_AS = [
    "https://www.linkedin.com/in/tomer-gelbhart/",
    "https://www.linkedin.com/in/yaron-gelbhart/",
    "https://www.linkedin.com/in/bareket-gelbhart-83904a16/",
    "https://github.com/gelbh",
    "https://github.com/gelbh/gelbhart-innovations",
    "https://gelbhart.dev"
  ].freeze

  def organization_schema
    {
      "@context" => "https://schema.org",
      "@type" => "Organization",
      "name" => ORGANIZATION_NAME,
      "url" => root_url,
      "logo" => convert_to_absolute_url("logo.png"),
      "description" => ApplicationHelper::DEFAULT_DESCRIPTION,
      "sameAs" => ORGANIZATION_SAME_AS
    }
  end

  def website_schema
    {
      "@context" => "https://schema.org",
      "@type" => "WebSite",
      "name" => ORGANIZATION_NAME,
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

  def person_schema(name:, job_title: nil, description: nil, image: nil, url: nil, same_as: [])
    {
      "@context" => "https://schema.org",
      "@type" => "Person",
      "name" => name
    }.tap do |schema|
      schema["jobTitle"] = job_title if job_title.present?
      schema["description"] = description if description.present?
      schema["image"] = image if image.present?
      schema["url"] = url if url.present?
      schema["sameAs"] = same_as if same_as.present?
    end
  end

  def service_schema(name:, description:, provider: ORGANIZATION_NAME, url: nil)
    {
      "@context" => "https://schema.org",
      "@type" => "Service",
      "name" => name,
      "description" => description,
      "provider" => {
        "@type" => "Organization",
        "name" => provider
      }
    }.tap do |schema|
      schema["url"] = url if url.present?
    end
  end

  def local_business_schema(name:, address:, phone: nil, email: nil, url: nil)
    {
      "@context" => "https://schema.org",
      "@type" => "LocalBusiness",
      "name" => name,
      "address" => address
    }.tap do |schema|
      schema["telephone"] = phone if phone.present?
      schema["email"] = email if email.present?
      schema["url"] = url if url.present?
    end
  end

  def json_ld_script(data)
    return "" if data.blank?
    content_tag(:script, data.to_json.html_safe, type: "application/ld+json")
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
