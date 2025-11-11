require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Innovations
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.

    # Set Time.zone for the application
    # config.time_zone = "Central Time (US & Canada)"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.default_locale = :en
    config.i18n.available_locales = [:en]

    # Configure autoload paths
    config.autoload_paths += %W[
      #{config.root}/app/presenters
      #{config.root}/lib
    ]

    # Configure eager load paths (for production)
    config.eager_load_paths += %W[
      #{config.root}/app/presenters
    ]

    # Generator configuration
    config.generators do |g|
      g.test_framework :test_unit, fixture: true
      g.fixture_replacement :test_unit, dir: 'test/fixtures'
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.system_tests true
    end

    # Configure Active Support deprecation warnings
    config.active_support.deprecation = :log
    config.active_support.disallowed_deprecation = :raise
    config.active_support.disallowed_deprecation_warnings = []

    # Use SQL for schema format (better for complex databases)
    # Keep as ruby for simple schemas
    config.active_record.schema_format = :ruby

    # Don't generate system test files automatically
    config.generators.system_tests = nil
  end
end
