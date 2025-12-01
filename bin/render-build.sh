#!/usr/bin/env bash
# exit on error
set -o errexit

# Install Ruby dependencies
bundle install

# Compile assets
bundle exec rails assets:precompile

# Generate sitemap
bundle exec rake sitemap:regenerate

# Generate IndexNow key file and ping
bundle exec rake sitemap:generate_indexnow_key
bundle exec rake sitemap:ping_indexnow

