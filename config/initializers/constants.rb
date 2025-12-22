# frozen_string_literal: true

module AppConstants
  SERVICE_GRADIENTS = {
    pharmaceutical: "linear-gradient(135deg, #667eea 0%, #764ba2 100%)",
    real_estate: "linear-gradient(135deg, #11998e 0%, #38ef7d 100%)"
  }.freeze

  SERVICE_ICONS = {
    pharmaceutical: "bx bxs-capsule",
    real_estate: "bx bxs-buildings"
  }.freeze

  SERVICE_ICON_MODIFIERS = {
    pharmaceutical: "pharma-icon",
    real_estate: "realestate-icon"
  }.freeze

  JARALLAX_IMAGES = {
    services: "covers/services_cover.jpg",
    team: "covers/team_cover.jpg",
    contact: "covers/contacts_cover.jpg"
  }.freeze

  BREADCRUMB_EXCLUDED_CONTROLLERS = %w[pages contact documents].freeze

  SERVICE_ACTIONS = %w[pharmaceutical real_estate].freeze

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
    map_coordinates: {
      lat: 45.901_520_8,
      lng: 8.971_048_6
    },
    google_maps_embed_url: {
      light: "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d11105.540609364607!2d8.966258838391106!3d45.90360883759438!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x47842973164cf711%3A0x2d91b98d1d5f95c2!2sVia%20Giuseppe%20Motta%209%2C%206826%20Riva%20San%20Vitale!5e0!3m2!1sen!2sch!4v1661011079847!5m2!1sen!2sch&style=feature:all|element:geometry|color:0xf3f6ff&style=feature:all|element:labels.text.fill|color:0x565973&style=feature:all|element:labels.text.stroke|color:0xffffff&style=feature:administrative|element:geometry.stroke|color:0xd4d7e5&style=feature:landscape|element:geometry|color:0xeff2fc&style=feature:poi|element:geometry|color:0xe2e5f1&style=feature:poi.park|element:geometry|color:0xdee7df&style=feature:road|element:geometry|color:0xffffff&style=feature:road|element:geometry.stroke|color:0xe2e5f1&style=feature:road.highway|element:geometry|color:0xd4d7e5&style=feature:road.highway|element:geometry.stroke|color:0xb4b7c9&style=feature:water|element:geometry|color:0xc9d6f7&style=feature:water|element:labels.text.fill|color:0x6366f1",
      dark: "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d11105.540609364607!2d8.966258838391106!3d45.90360883759438!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x47842973164cf711%3A0x2d91b98d1d5f95c2!2sVia%20Giuseppe%20Motta%209%2C%206826%20Riva%20San%20Vitale!5e0!3m2!1sen!2sch!4v1661011079847!5m2!1sen!2sch"
    }
  }.freeze
end
