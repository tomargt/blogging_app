Rails.application.routes.draw do
  devise_for :users
  root to: 'blogs#index'

  resources :blogs do
    member do
      put 'publish'
      put 'archive'
    end
    collection do
      get 'my_blogs'
      get 'archived_blogs'
    end
  	resources :comments
	end
end