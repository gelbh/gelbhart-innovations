# frozen_string_literal: true

require_relative "boot"

# Load Rails components
require "rails"
require "action_controller/railtie"
require "action_view/railtie"
require "action_mailer/railtie"
require "active_job/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module Innovations
  class Application < Rails::Application
    config.load_defaults 8.1

    # Autoload lib directory, excluding non-Ruby subdirectories
    config.autoload_lib(ignore: %w[assets tasks])

    # Disable system test file generation
    config.generators.system_tests = nil
  end
end
