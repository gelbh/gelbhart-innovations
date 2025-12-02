# Security Headers Configuration
# 
# This initializer configures security-related HTTP headers to protect against
# common web vulnerabilities. These headers are applied to all responses.
#
# Reference: https://owasp.org/www-project-secure-headers/

Rails.application.config.action_dispatch.default_headers.merge!(
  # X-Frame-Options: Prevent clickjacking attacks
  # DENY prevents any site from embedding this page in an iframe
  # Use SAMEORIGIN if you need to embed pages within your own site
  "X-Frame-Options" => "DENY",

  # X-Content-Type-Options: Prevent MIME type sniffing
  # Stops browsers from trying to guess the MIME type of a resource
  # This helps prevent attacks where a malicious file is disguised
  "X-Content-Type-Options" => "nosniff",

  # Referrer-Policy: Control how much referrer information is shared
  # strict-origin-when-cross-origin sends:
  #   - Full URL for same-origin requests
  #   - Origin only for cross-origin HTTPS→HTTPS
  #   - No referrer for HTTPS→HTTP (downgrade)
  "Referrer-Policy" => "strict-origin-when-cross-origin",

  # X-XSS-Protection: Legacy XSS protection (for older browsers)
  # Note: This is deprecated in favor of CSP, but still useful for older browsers
  # 1; mode=block tells browser to block the page if XSS is detected
  "X-XSS-Protection" => "1; mode=block",

  # X-Permitted-Cross-Domain-Policies: Control Flash and PDF access
  # Prevents Flash and Acrobat from loading data from your domain
  "X-Permitted-Cross-Domain-Policies" => "none",

  # Cross-Origin-Opener-Policy: Isolate browsing context
  # Helps prevent cross-origin attacks like Spectre
  "Cross-Origin-Opener-Policy" => "same-origin",

  # Cross-Origin-Resource-Policy: Control resource sharing
  # Prevents other origins from loading resources from this origin
  # Use "cross-origin" if you need to share resources with other domains
  "Cross-Origin-Resource-Policy" => "same-origin",

  # Permissions-Policy: Control which browser features can be used
  # This header restricts access to powerful browser APIs (camera, microphone, etc.)
  # Configuration mirrors config/initializers/permissions_policy.rb
  # Format: feature=(self) allows same-origin, feature=() disables completely
  # Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Permissions-Policy
  "Permissions-Policy" => "accelerometer=(), autoplay=(self), camera=(), display-capture=(), encrypted-media=(self), fullscreen=(self), geolocation=(), gyroscope=(), hid=(), idle-detection=(), keyboard-map=(), magnetometer=(), microphone=(), midi=(), payment=(), picture-in-picture=(self), screen-wake-lock=(), serial=(), sync-xhr=(self), usb=(), web-share=(self)"
)

# Note: Strict-Transport-Security (HSTS) is handled by config.force_ssl in production.rb
# When force_ssl is enabled, Rails automatically adds the HSTS header with:
#   - max-age=31536000 (1 year)
#   - includeSubDomains
# You can customize these settings via config.ssl_options if needed.

