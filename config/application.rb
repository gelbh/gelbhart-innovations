require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Innovations
  class Application < Rails::Application

  end
end
