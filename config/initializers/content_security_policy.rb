# frozen_string_literal: true

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self, :https
    policy.font_src :self, :https, :data, "https://fonts.gstatic.com"
    policy.img_src :self, :https, :data, "blob:", "https://*.googleapis.com", "https://*.gstatic.com", "https://www.googletagmanager.com"
    policy.object_src :none
    policy.script_src :self, :unsafe_eval, "https://maps.googleapis.com", "https://*.gstatic.com", "https://www.googletagmanager.com"
    policy.style_src :self, :unsafe_inline, "https://fonts.googleapis.com", "https://maps.googleapis.com"
    policy.connect_src :self, :data, "https://maps.googleapis.com", "https://*.googleapis.com", "https://*.gstatic.com", "https://www.google-analytics.com", "https://*.google-analytics.com", "https://analytics.google.com", "https://*.googletagmanager.com"
    policy.worker_src :self, "blob:"
    policy.frame_src "https://www.google.com", "https://*.google.com"
    policy.base_uri :self
    policy.form_action :self
  end

  config.content_security_policy_nonce_generator = ->(_request) { SecureRandom.base64(16) }
  config.content_security_policy_nonce_directives = %w[script-src]
  config.content_security_policy_report_only = false
end
