# frozen_string_literal: true

# Content Security Policy configuration
# Reference: https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self, :https
    policy.font_src :self, :https, :data, "https://fonts.gstatic.com"
    policy.img_src :self, :https, :data, "blob:"
    policy.object_src :none
    policy.script_src :self, :unsafe_eval # unsafe_eval required for importmap-rails
    policy.style_src :self, :unsafe_inline, "https://fonts.googleapis.com" # unsafe_inline required for Turbo and vendor libraries
    policy.connect_src :self
    policy.frame_src "https://www.google.com" # Google Maps embed
    policy.base_uri :self
    policy.form_action :self
  end

  # Generate unique nonce per request for inline scripts
  config.content_security_policy_nonce_generator = ->(_request) { SecureRandom.base64(16) }

  # Apply nonces only to script-src for XSS protection
  config.content_security_policy_nonce_directives = %w[script-src]

  # Enforce CSP (set to true for report-only mode during testing)
  config.content_security_policy_report_only = false
end
