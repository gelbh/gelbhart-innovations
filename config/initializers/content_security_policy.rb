# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    # Default source for all directives
    policy.default_src :self, :https
    
    # Font sources: self-hosted assets and Google Fonts
    policy.font_src    :self, :https, :data, "https://fonts.gstatic.com"
    
    # Image sources: self-hosted, data URIs, and HTTPS
    policy.img_src     :self, :https, :data, "blob:"
    
    # Prevent loading plugins and Java applets
    policy.object_src  :none
    
    # Script sources: self-hosted, nonce-based inline scripts, and unsafe-eval for importmap
    # Note: unsafe-eval is required for importmap-rails to work with ES modules
    policy.script_src  :self, :unsafe_eval
    
    # Style sources: self-hosted, nonce-based inline styles, Google Fonts, and unsafe-inline
    # Note: unsafe-inline is required for:
    #   - Inline style attributes (style="...") in HTML
    #   - Turbo Rails dynamically applied styles during page transitions
    #   - Vendor libraries (Swiper, Lightgallery, etc.) that add inline styles
    policy.style_src   :self, :unsafe_inline, "https://fonts.googleapis.com"
    
    # Connect sources: self for AJAX requests
    policy.connect_src :self
    
    # Frame sources: allow Google Maps embed for contacts page
    policy.frame_src   "https://www.google.com"
    
    # Base URI: restrict to self
    policy.base_uri    :self
    
    # Form action: restrict to self
    policy.form_action :self
    
    # Upgrade insecure requests in production (optional, uncomment if needed)
    # policy.upgrade_insecure_requests true
    
    # Specify URI for violation reports (optional, configure if using reporting service)
    # policy.report_uri "/csp-violation-report-endpoint"
  end

  # Generate session nonces for permitted importmap and inline scripts
  # This creates unique nonces per request to allow specific inline scripts
  config.content_security_policy_nonce_generator = ->(request) { 
    # Use SecureRandom for production-grade nonce generation
    SecureRandom.base64(16)
  }
  
  # Apply nonces only to script-src (not style-src)
  # Note: We only apply nonces to scripts for strong XSS protection.
  # Styles use 'unsafe-inline' instead because:
  #   - When nonces are present, 'unsafe-inline' is ignored by browsers
  #   - Inline styles are needed for HTML attributes, Turbo, and vendor libraries
  #   - Style injection is less dangerous than script injection
  config.content_security_policy_nonce_directives = %w(script-src)

  # Report violations without enforcing the policy (safe for initial deployment)
  # Set to false once CSP is tested and working correctly
  # 
  # TESTING INSTRUCTIONS:
  # 1. Deploy with report_only = true
  # 2. Monitor browser console for CSP warnings (they won't block resources)
  # 3. Test all pages: home, services, team, contacts, news, documents
  # 4. Verify Google Fonts load correctly
  # 5. Verify all vendor scripts work (Bootstrap, Swiper, Lightgallery, etc.)
  # 6. Verify theme toggle works (light/dark mode)
  # 7. Check for any CSP violations in browser console
  # 8. Once confirmed no violations, set report_only = false to enforce
  #
  # COMMON ISSUES:
  # - If importmap modules fail: verify :unsafe_eval in script-src
  # - If Google Fonts fail: verify fonts.googleapis.com and fonts.gstatic.com in font-src/style-src
  # - If inline scripts fail: verify nonce is applied (check <script> tags in HTML source)
  # - If dynamically created scripts fail: they need nonce attribute set via JS
  config.content_security_policy_report_only = true
end
