module ApplicationHelper
  def nav_active_class(*paths)
    active = paths.any? { |path| current_page?(path) }
    active ? "active" : ""
  end

  def full_page_title(custom_title = nil)
    base = "Gelbhart Inn."
    custom_title.present? ? "#{custom_title} / #{base}" : base
  end

  def page_description(custom_description = nil)
    custom_description.presence || ""
  end
end