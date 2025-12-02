# frozen_string_literal: true

# Permissions Policy configuration
# Controls which browser features can be used by the application
# Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Permissions-Policy

Rails.application.config.permissions_policy do |policy|
  # Disabled features (not used by this application)
  policy.camera :none
  policy.microphone :none
  policy.geolocation :none
  policy.gyroscope :none
  policy.accelerometer :none
  policy.magnetometer :none
  policy.usb :none
  policy.payment :none
  policy.idle_detection :none
  policy.serial :none
  policy.hid :none
  policy.midi :none
  policy.screen_wake_lock :none
  policy.display_capture :none
  policy.keyboard_map :none

  # Enabled features (used by Lightgallery and video content)
  policy.fullscreen :self
  policy.autoplay :self
  policy.picture_in_picture :self
  policy.encrypted_media :self
  policy.web_share :self
  policy.sync_xhr :self
end
