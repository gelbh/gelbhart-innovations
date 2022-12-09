Rails.application.routes.draw do
  root 'pages#index'

  get 'services', controller: 'pages'
  get 'team', controller: 'pages'
  get 'contacts', controller: 'pages'

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
