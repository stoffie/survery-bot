Rails.application.routes.draw do
  devise_for :users
	# Devise really wants you to have a root
	root to: "welcomes#index"

  resources :welcomes
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
