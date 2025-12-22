# frozen_string_literal: true

Rails.application.routes.draw do
  root "pages#index"

  # SEO and metadata
  get "/robots.txt", to: "robots#show", as: "robots"
  get "/sitemap.xml", to: "sitemap#show", as: "sitemap"
  get "/sitemap.xml.gz", to: "sitemap#show_gz", as: "sitemap_gz"
  get "/site.webmanifest", to: "manifest#site_webmanifest"

  # Main pages
  get "services", to: "pages#services"
  get "team", to: "pages#team"
  get "contact", to: "pages#contact"

  # Service category pages
  get "services/pharmaceutical", to: "pages#pharmaceutical", as: "pharmaceutical"
  get "services/real-estate", to: "pages#real_estate", as: "real_estate"

  # Legacy redirects
  get "pharmaceutical", to: redirect("/services/pharmaceutical", status: 301)
  get "real_estate", to: redirect("/services/real-estate", status: 301)
  get "contacts", to: redirect("/contact", status: 301)

  # Document pages
  get "tos", to: "documents#tos"

  # Favicon redirect
  get "/favicon.ico", to: redirect { |_params, _request|
    ActionController::Base.helpers.asset_path("favicon.ico")
  }

  # Error pages
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  match "*unmatched", to: "errors#not_found", via: :all
end
