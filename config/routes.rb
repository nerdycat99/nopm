Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'splash#index'
  get 'test', to: 'splash#test'

  resources :umakes

  namespace :performer do
    resource :prerequisites
    resources :orgs do
      resources :users
      resources :projects do
        resources :tasks
      end
    end
  end

  resources :orgs do
    resources :users
    resources :projects do
      resources :tasks
    end
  end 
end
