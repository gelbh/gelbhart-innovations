source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.9"

gem "rails", "~> 7.0.3", ">= 7.0.3.1"
gem 'pg'
gem "sprockets-rails"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem "mail_form"
gem 'sassc-rails'

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
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
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "rails-controller-testing"
end
