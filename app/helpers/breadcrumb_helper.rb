module BreadcrumbHelper
  def breadcrumb_trail
    items = []

    items << { name: "Home", path: root_path }

    unless %w[pages contacts news documents].include?(controller.controller_name)
      items << { name: controller.controller_name.titleize }
    end

    if services_subpage?
      items << { name: "Services", path: services_path }
    end

    items << { name: breadcrumb_current_label, current: true }

    items
  end

  private

  def services_subpage?
    %w[pharmaceutical real_estate].include?(action_name)
  end

  def breadcrumb_current_label
    return @breadcrumb if defined?(@breadcrumb) && @breadcrumb.present?

    if services_subpage?
      return action_name == "pharmaceutical" ? "Pharmaceutical" : "Real Estate"
    end

    (@title || "").to_s.split(" / ").first.presence || controller.action_name.titleize
  end
end

