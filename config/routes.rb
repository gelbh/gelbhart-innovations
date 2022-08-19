Rails.application.routes.draw do
  root 'home#index'

  get 'services', controller: 'home'
  get 'team', controller: 'home'
  get 'corporate', controller: 'home'
  get 'contact', controller: 'home'

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
