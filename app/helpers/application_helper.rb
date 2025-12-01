module ApplicationHelper
  include SeoHelper
  include StructuredDataHelper

  def nav_active_class(*paths)
    active = paths.any? { |path| current_page?(path) }
    active ? "active" : ""
  end

  def full_page_title(custom_title = nil)
    base = "Gelbhart Innovations"
    max_length = 60

    if custom_title.present?
      title = "#{custom_title} | #{base}"
      # Truncate if too long, prioritizing the custom title
      if title.length > max_length
        available_space = max_length - base.length - 3 # " | " = 3 chars
        truncated_title = truncate_text(custom_title, available_space)
        title = "#{truncated_title} | #{base}"
      end
      title
    else
      base
    end
  end

  def page_description(custom_description = nil)
    description = custom_description.presence || default_description
    truncate_text(description, 160)
  end

  private

  # Truncate text helper (used by both title and description)
  def truncate_text(text, length)
    return "" if text.blank?
    text.length > length ? "#{text[0..length - 4]}..." : text
  end

  # Default description fallback
  def default_description
    "Gelbhart Innovations provides innovative solutions creating value through comprehensive consulting services in pharmaceutical and real estate industries."
  end
end