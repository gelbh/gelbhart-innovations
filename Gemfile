source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.10"

gem "rails", "~> 8.1.0"
gem 'pg'
gem "sprockets-rails"
gem "puma", "~> 6.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false
gem "mail_form"
gem 'dartsass-rails'
gem 'sitemap_generator'
gem "image_processing", "~> 1.2"
gem "rexml"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  gem "web-console"
  gem "htmlbeautifier", require: false
  gem "erb_lint", require: false
end

group :production do
end

group :test do
  gem "capybara"
  gem "selenium-webdriver", ">= 4.11"
  gem "rails-controller-testing"
end
