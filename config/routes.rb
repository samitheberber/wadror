RateBeer::Application.routes.draw do
  root :to => 'breweries#index'

  resources :beers
  resources :breweries

  get 'kaikki_bisset', to: 'beers#index'

  resources :users
  get 'signup', to:'users#new'

  resources :ratings, :only => [:index, :new, :create, :destroy]
end
