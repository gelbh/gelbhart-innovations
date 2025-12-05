# frozen_string_literal: true

# Security headers configuration
# Reference: https://owasp.org/www-project-secure-headers/

Rails.application.config.action_dispatch.default_headers.merge!(
  # Prevent clickjacking attacks
  "X-Frame-Options" => "DENY",

  # Prevent MIME type sniffing
  "X-Content-Type-Options" => "nosniff",

  # Control referrer information sharing
  "Referrer-Policy" => "strict-origin-when-cross-origin",

  # Prevent Flash and Acrobat from loading data
  "X-Permitted-Cross-Domain-Policies" => "none",

  # Isolate browsing context to prevent cross-origin attacks
  "Cross-Origin-Opener-Policy" => "same-origin",

  # Control resource sharing across origins
  "Cross-Origin-Resource-Policy" => "same-origin"
)

