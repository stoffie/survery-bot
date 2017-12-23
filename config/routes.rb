Rails.application.routes.draw do
	# Devise really wants you to have a root
	devise_for :users
	root to: "patients#index"
	resources :patients
	resources :questionnaires
	resources :campaigns

	#resources :answers
	#resources :invitations
	#resources :options
	#resources :questions
	#resources :dialogs
	#resources :welcomes
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
