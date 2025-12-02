module ApplicationHelper
  include SeoHelper
  include StructuredDataHelper

  SITE_NAME = "Gelbhart Innovations"
  MAX_TITLE_LENGTH = 60
  MAX_DESCRIPTION_LENGTH = 160
  DEFAULT_DESCRIPTION = "Gelbhart Innovations provides innovative solutions creating value through " \
                        "comprehensive consulting services in pharmaceutical and real estate industries."

  def nav_active_class(*paths)
    paths.any? { |path| current_page?(path) } ? "active" : ""
  end

  def full_page_title(custom_title = nil)
    return SITE_NAME if custom_title.blank?

    title = "#{custom_title} | #{SITE_NAME}"
    return title if title.length <= MAX_TITLE_LENGTH

    available_space = MAX_TITLE_LENGTH - SITE_NAME.length - 3
    truncated_title = truncate_text(custom_title, available_space)
    "#{truncated_title} | #{SITE_NAME}"
  end

  def page_description(custom_description = nil)
    description = custom_description.presence || DEFAULT_DESCRIPTION
    truncate_text(description, MAX_DESCRIPTION_LENGTH)
  end

  def truncate_text(text, length)
    return "" if text.blank?
    text.length > length ? "#{text[0..length - 4]}..." : text
  end
end
