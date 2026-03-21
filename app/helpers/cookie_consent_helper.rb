# frozen_string_literal: true

# GA measurement ID and Klaro i18n payloads for the EU consent head partial.
module CookieConsentHelper
  def ga_measurement_id
    Rails.application.credentials.dig(:google_analytics, :measurement_id).presence ||
      ENV['GA_MEASUREMENT_ID'].presence ||
      'G-F3QJEJ4YFR'
  end

  def cookie_consent_policy_version
    Rails.configuration.x.cookie_consent.policy_version
  end

  # Klaro translation objects keyed by locale string (plus zz fallback = default locale).
  def klaro_i18n_by_locale
    by_locale = I18n.available_locales.each_with_object({}) do |loc, memo|
      memo[loc.to_s] = I18n.with_locale(loc) do
        klaro_strings_for_locale.deep_stringify_keys
      end
    end
    by_locale['zz'] = by_locale[I18n.default_locale.to_s].deep_dup
    by_locale
  end

  private

  # rubocop:disable Metrics/MethodLength -- mirrors Klaro translation tree
  def klaro_strings_for_locale
    {
      privacyPolicyUrl: tos_path(anchor: 'privacy'),
      consentNotice: {
        title: I18n.t('klaro.consent_notice.title'),
        description: I18n.t('klaro.consent_notice.description'),
        learnMore: I18n.t('klaro.consent_notice.learn_more')
      },
      consentModal: {
        title: I18n.t('klaro.consent_modal.title'),
        description: I18n.t('klaro.consent_modal.description'),
        privacyPolicy: {
          name: I18n.t('klaro.consent_modal.privacy_policy_name'),
          text: I18n.t('klaro.consent_modal.privacy_policy_text')
        }
      },
      acceptAll: I18n.t('klaro.accept_all'),
      acceptSelected: I18n.t('klaro.accept_selected'),
      decline: I18n.t('klaro.decline'),
      save: I18n.t('klaro.save'),
      close: I18n.t('klaro.close'),
      purposes: {
        analytics: I18n.t('klaro.purposes.analytics')
      },
      "google-analytics": {
        title: I18n.t('klaro.services.google_analytics.title'),
        description: I18n.t('klaro.services.google_analytics.description')
      }
    }
  end
  # rubocop:enable Metrics/MethodLength
end
