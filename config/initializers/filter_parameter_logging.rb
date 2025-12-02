# frozen_string_literal: true

# Filter sensitive parameters from logs
# These patterns are partially matched (e.g., "passw" matches "password")
Rails.application.config.filter_parameters += %i[
  passw
  email
  secret
  token
  _key
  crypt
  salt
  certificate
  otp
  ssn
  cvv
  cvc
]
