Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'splash#index'
  get 'test', to: 'splash#test'
  get 'register-space', to: 'splash#register_space'
  get 'register-user', to: 'splash#register_user'

  resources :umakes

  namespace :performer do
    resources :orgs do
      resources :users
      resources :projects do
        resource :prerequisites
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
