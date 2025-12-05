# frozen_string_literal: true

require_relative "boot"

require "rails/all"

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
