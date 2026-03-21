# frozen_string_literal: true

# EU/EEA/UK detection for cookie consent (CF-IPCountry + env override).
module CookieConsentRegion
  extend ActiveSupport::Concern

  EU_EEA_UK = %w[
    AT BE BG HR CY CZ DK EE FI FR DE GR HU IE IT LV LT LU MT NL PL PT RO SK SI ES SE
    IS LI NO GB
  ].freeze

  included do
    helper_method :cookie_consent_required?
  end

  def cookie_consent_required?
    case ENV.fetch('FORCE_COOKIE_CONSENT_REGION', '').downcase
    when 'eu' then true
    when 'non_eu' then false
    else
      code = request.headers['CF-IPCountry']&.upcase
      code.present? && EU_EEA_UK.include?(code)
    end
  end
end
