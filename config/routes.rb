Rails.application.routes.draw do
  root 'home#index'
  get 'home/services'
  get 'home/team'
  get 'home/corporate'
  get 'home/contact'

end
