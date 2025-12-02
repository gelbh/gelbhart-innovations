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
    services: "covers/services_cover.jpg",
    team: "covers/team_cover.jpg",
    contacts: "covers/contacts_cover.jpg"
  }.freeze

  # Controllers that should be excluded from breadcrumb display
  BREADCRUMB_EXCLUDED_CONTROLLERS = %w[pages contacts documents].freeze

  # Service-related actions for breadcrumb logic
  SERVICE_ACTIONS = %w[pharmaceutical real_estate].freeze

  # Contact information
  CONTACT_INFO = {
    address: {
      street: "Via Giuseppe Motta, 9",
      city: "Riva san Vitale",
      postal_code: "6826",
      country: "Switzerland"
    },
    phone: {
      display: "+41 79 765 84 22",
      tel: "+41797658422"
    },
    email: "info@gelbhart.com",
    business_hours: {
      weekdays: { open: "08:00", close: "17:00", days: "Mon - Fri" },
      weekend: "Closed"
    },
    google_maps_embed_url: "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d11105.540609364607!2d8.966258838391106!3d45.90360883759438!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x47842973164cf711%3A0x2d91b98d1d5f95c2!2sVia%20Giuseppe%20Motta%209%2C%206826%20Riva%20San%20Vitale!5e0!3m2!1sen!2sch!4v1661011079847!5m2!1sen!2sch"
  }.freeze
end

