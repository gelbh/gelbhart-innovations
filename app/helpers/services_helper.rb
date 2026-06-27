# frozen_string_literal: true

module ServicesHelper
  def real_estate_services_by_phase(services)
    AppConstants::REAL_ESTATE_PHASES.map do |phase_def|
      {
        phase: phase_def[:phase],
        services: services.select { |service| phase_def[:keys].include?(service.key) }
      }
    end
  end

  def service_description_items(service)
    description = service.description
    return [] if description.blank?

    description.is_a?(Array) ? description : [description]
  end
end
