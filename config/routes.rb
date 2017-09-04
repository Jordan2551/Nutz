Rails.application.routes.draw do

  resources :likes, except: [:destroy, :update, :create, :edit]
  post 'like/:article_id', to: 'likes#like'
  get 'like/:id', to: 'likes#show'

  resources :favorites, except: [:destroy, :update, :create, :edit]
  post 'favorite/:article_id', to: 'favorites#favorite'
  get 'favorites/:id', to: 'favorites#show'

  devise_for :users

  resources :articles do
    resources :comments
  end

  resources :profiles, only: [:show]

  root 'articles#index'
  post 'filter_articles', to: 'articles#filter_articles'

end
