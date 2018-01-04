Rails.application.routes.draw do
	# Devise really wants you to have a root
	devise_for :users
	root to: "patients#index"
	authenticate :user do
		mount Crono::Web, at: '/crono'
		get 'strumenti', to: 'crono#index', as: 'crono'
	end
	resources :patients
	resources :questionnaires
	resources :campaigns
	resources :invitations

	#resources :answers
	#resources :options
	#resources :questions
	#resources :dialogs
	#resources :welcomes
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

	# Webhooks
	post "/webhooks/telegram" => 'webhooks#callback'
end
