# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  begin
    ActiveAdmin.routes(self)
  rescue StandardError
    ActiveAdmin::DatabaseHitDuringLoad
  end
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  authenticate :admin_user do
    mount Flipper::UI.app(Flipper) => '/admin/flipper'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resource :sessions, only: %i[create update]
      resources :playlists do
        resources :songs, only: %i[index create destroy], controller: :playlist_songs
        resources :comments, only: %i[index create]
        resources :reactions, only: %i[create]
      end
      resources :songs, only: %i[index]
      resources :abouts, only: %i[index]
      resources :users, only: %i[show]
      resource :current_user, only: %i[show update destroy]
      namespace :user do
        resources :friendships, only: %i[index destroy create update]
        resources :playlists, only: %i[index]
        resources :friends, only: %i[index]
      end

      post '/sign_up', to: 'sign_up#index'
      get '/songs/:type', to: 'home#songs'
      get '/home_users', to: 'home#users_info'
      get '/home_playlists', to: 'home#playlists_info'
      get 'user/search_new_user', to: 'users#search_new_user'
    end
  end
end
# rubocop:enable Metrics/BlockLength
