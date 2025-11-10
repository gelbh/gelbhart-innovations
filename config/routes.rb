Rails.application.routes.draw do
  root 'pages#index'

  get 'services', controller: 'pages'
  get 'pharmaceutical', controller: 'pages'
  get 'real_estate', controller: 'pages'
  get 'team', controller: 'pages'
  get 'contacts', controller: 'pages'
  
  get 'tos', to: 'documents#tos'

  # Favicon route - redirect to asset pipeline version
  get '/favicon.ico', to: redirect { |_params, request| ActionController::Base.helpers.asset_path('favicon.ico') }

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
