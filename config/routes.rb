RateBeer::Application.routes.draw do

  resources :styles

  resources :places, only: [:index, :show]
  post 'places' => 'places#search'

  resources :memberships

  resources :beer_clubs

  root :to => 'breweries#index'

  resources :beers
  resources :breweries

  get 'kaikki_bisset', to: 'beers#index'

  resources :users
  get 'signup', to: 'users#new'

  resources :ratings, only: [:index, :new, :create, :destroy]

  resources :sessions, only: [:new, :create, :destroy]
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
end
