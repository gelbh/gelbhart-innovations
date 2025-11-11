Rails.application.routes.draw do
  # Root
  root 'pages#index'

  # Main pages
  get 'services', to: 'pages#services'
  get 'team', to: 'pages#team'
  get 'contacts', to: 'pages#contacts'

  # Service category pages
  get 'pharmaceutical', to: 'pages#pharmaceutical'
  get 'real_estate', to: 'pages#real_estate'

  # Document pages
  get 'tos', to: 'documents#tos'

  # Assets
  get '/favicon.ico', to: redirect { |_params, request|
    ActionController::Base.helpers.asset_path('favicon.ico')
  }

  # Error pages
  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
