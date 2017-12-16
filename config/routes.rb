Rails.application.routes.draw do
	patch "orders/order_details", to: "orders#order_details"
	resources :orders do 
		collection do
			post "order_details"
			# patch "order_details" 
		end
	end
	# get 'orders/order_details', to: "orders#order_details", as: order_details
	devise_for :users
	root 'orders#new'
	namespace :api do
		devise_for :users, :controllers => {sessions: 'api/sessions', registrations: 'api/registrations'} 
		namespace :v1 do
			resources :products
		end
	end
end
