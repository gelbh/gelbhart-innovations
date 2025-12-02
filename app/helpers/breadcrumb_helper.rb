module BreadcrumbHelper
  def breadcrumb_trail
    [].tap do |items|
      items << { name: "Home", path: root_path }

      unless AppConstants::BREADCRUMB_EXCLUDED_CONTROLLERS.include?(controller.controller_name)
        items << { name: controller.controller_name.titleize }
      end

      items << { name: "Services", path: services_path } if services_subpage?
      items << { name: breadcrumb_current_label, current: true }
    end
  end

  private

  def services_subpage?
    AppConstants::SERVICE_ACTIONS.include?(action_name)
  end

  def breadcrumb_current_label
    return @breadcrumb if @breadcrumb.present?
    return service_action_label if services_subpage?

    @title.to_s.split(" / ").first.presence || controller.action_name.titleize
  end

  def service_action_label
    action_name == "pharmaceutical" ? "Pharmaceutical" : "Real Estate"
  end
end
