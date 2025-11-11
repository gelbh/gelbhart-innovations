# frozen_string_literal: true

# Application-wide constants
module AppConstants
  # Service category gradients
  SERVICE_GRADIENTS = {
    pharmaceutical: "linear-gradient(135deg, #667eea 0%, #764ba2 100%)",
    real_estate: "linear-gradient(135deg, #11998e 0%, #38ef7d 100%)"
  }.freeze

  # Service category icons
  SERVICE_ICONS = {
    pharmaceutical: "bx bxs-capsule",
    real_estate: "bx bxs-buildings"
  }.freeze

  # Service category icon modifiers (for CSS classes)
  SERVICE_ICON_MODIFIERS = {
    pharmaceutical: "pharma-icon",
    real_estate: "realestate-icon"
  }.freeze

  # Jarallax background images
  JARALLAX_IMAGES = {
    services: "services_cover",
    team: "team_cover",
    contacts: "contacts_cover"
  }.freeze

  # Controllers that should be excluded from breadcrumb display
  BREADCRUMB_EXCLUDED_CONTROLLERS = %w[pages contacts documents].freeze

  # Service-related actions for breadcrumb logic
  SERVICE_ACTIONS = %w[pharmaceutical real_estate].freeze
end

