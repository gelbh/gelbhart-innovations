# Define an application-wide HTTP permissions policy.
# For further information see:
# - https://developers.google.com/web/updates/2018/06/feature-policy
# - https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Permissions-Policy
#
# The Permissions-Policy header allows you to control which browser features
# can be used by your application and any embedded content.
#
# Supported directives in Rails 8.1 (from ActionDispatch::PermissionsPolicy::DIRECTIVES):
# accelerometer, ambient_light_sensor, autoplay, camera, display_capture,
# encrypted_media, fullscreen, geolocation, gyroscope, hid, idle_detection,
# keyboard_map, magnetometer, microphone, midi, payment, picture_in_picture,
# screen_wake_lock, serial, sync_xhr, usb, web_share

Rails.application.config.permissions_policy do |policy|
  # Camera: Disable completely - not used by this application
  policy.camera :none
  
  # Microphone: Disable completely - not used by this application
  policy.microphone :none
  
  # Geolocation: Disable completely - not used by this application
  policy.geolocation :none
  
  # Gyroscope: Disable completely - not needed for this application
  policy.gyroscope :none
  
  # Accelerometer: Disable completely - not needed for this application
  policy.accelerometer :none
  
  # USB: Disable completely - not used by this application
  policy.usb :none
  
  # Fullscreen: Allow for self - used by Lightgallery for image/video viewing
  policy.fullscreen :self
  
  # Payment: Disable completely - no payment processing on this site
  policy.payment :none
  
  # Autoplay: Allow for self - may be needed for gallery videos
  policy.autoplay :self
  
  # Picture-in-Picture: Allow for self - useful for video content
  policy.picture_in_picture :self
  
  # Idle Detection: Disable - not needed for this application
  policy.idle_detection :none
  
  # Serial: Disable - not needed for this application
  policy.serial :none
  
  # HID (Human Interface Device): Disable - not needed for this application
  policy.hid :none
  
  # MIDI: Disable - not needed for this application
  policy.midi :none
  
  # Screen Wake Lock: Disable - not needed for this application
  policy.screen_wake_lock :none
  
  # Magnetometer: Disable - not needed for this application
  policy.magnetometer :none
  
  # Display Capture: Disable - not needed for this application
  policy.display_capture :none
  
  # Encrypted Media: Allow for self - may be needed for video playback
  policy.encrypted_media :self
  
  # Ambient Light Sensor: Disable - not needed for this application
  policy.ambient_light_sensor :none
  
  # Keyboard Map: Disable - not needed for this application
  policy.keyboard_map :none
  
  # Web Share: Allow for self - could be useful for sharing content
  policy.web_share :self
  
  # Sync XHR: Allow for self - may be needed for some AJAX requests
  policy.sync_xhr :self
end
