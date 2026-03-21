# frozen_string_literal: true

# Records consent snapshots for audits (JSON lines in log/consent_events.jsonl).
#
# Verification checklist (Chrome / GA):
# - EU path: set FORCE_COOKIE_CONSENT_REGION=eu. Before Accept: no gtag/js in Network.
# - After Accept: gtag/js loads; collect to google-analytics.com; dataLayer consent update.
# - After Reject: consent update denied.
# - Application: klaro cookie; sessionStorage klaro_consent_logged dedupes POSTs.
# - Tag Assistant: GA4 after consent; Consent Mode signals on update.
class ConsentEventsController < ApplicationController
  def create
    choices_hash = normalized_choice_hash
    return head :bad_request unless choices_hash

    ConsentEventLogger.append(**consent_logger_attributes(choices_hash))
    head :created
  rescue SystemCallError => e
    Rails.logger.error("[consent_events] #{e.class}: #{e.message}")
    head :service_unavailable
  end

  private

  def consent_params
    @consent_params ||= params.permit(:policy_version, :client_locale, choices: {})
  end

  def normalized_choice_hash
    normalize_choices(consent_params[:choices])
  end

  # rubocop:disable Metrics/AbcSize -- assembles logger keyword args
  def consent_logger_attributes(choices_hash)
    pv = consent_params[:policy_version].presence || Rails.configuration.x.cookie_consent.policy_version
    {
      choices: choices_hash,
      policy_version: pv,
      region: request.headers['CF-IPCountry']&.upcase&.slice(0, 2),
      locale: consent_params[:client_locale].presence || I18n.locale.to_s,
      session_fingerprint: session[:consent_fingerprint]
    }
  end
  # rubocop:enable Metrics/AbcSize

  def normalize_choices(choices)
    return unless choices.is_a?(ActionController::Parameters) || choices.is_a?(Hash)

    choices.respond_to?(:to_unsafe_h) ? choices.to_unsafe_h : choices.to_h
  end
end
