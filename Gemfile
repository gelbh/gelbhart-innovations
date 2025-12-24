# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.10"

# Rails and core dependencies
gem "bootsnap", require: false
gem "importmap-rails"
gem "jbuilder"
gem "puma", "~> 6.0"
gem "rails", "~> 8.1.0"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"

# Assets
gem "dartsass-rails"

# Application features
gem "mail_form"
gem "rexml"
gem "sitemap_generator"
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "dotenv-rails"
end

group :development do
  gem "erb_lint", require: false
  gem "htmlbeautifier", require: false
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "rails-controller-testing"
  gem "selenium-webdriver", ">= 4.11"
end
