Rails.application.routes.draw do
  # Root
  root 'pages#index'

  # Robots.txt
  get '/robots.txt', to: 'robots#show', as: 'robots'

  # Sitemap
  get '/sitemap.xml', to: 'sitemap#show', as: 'sitemap'

  # Main pages
  get 'services', to: 'pages#services'
  get 'team', to: 'pages#team'
  get 'contacts', to: 'pages#contacts'

  # Service category pages (nested under services)
  get 'services/pharmaceutical', to: 'pages#pharmaceutical', as: 'pharmaceutical'
  get 'services/real-estate', to: 'pages#real_estate', as: 'real_estate'

  # 301 redirects for old URLs
  get 'pharmaceutical', to: redirect('/services/pharmaceutical', status: 301)
  get 'real_estate', to: redirect('/services/real-estate', status: 301)

  # Document pages
  get 'tos', to: 'documents#tos'

  # Assets
  get '/favicon.ico', to: redirect { |_params, request|
    ActionController::Base.helpers.asset_path('favicon.ico')
  }

  # Error pages
  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
  
  # Catch-all route for 404s - must be last
  match '*unmatched', to: 'errors#not_found', via: :all
end
