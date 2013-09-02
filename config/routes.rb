RateBeer::Application.routes.draw do
  root :to => 'breweries#index'

  resources :beers
  resources :breweries

  get 'kaikki_bisset', to: 'beers#index'

  get 'ratings', to: 'ratings#index'
  get 'ratings/new', to:'ratings#new'
  post 'ratings', to: 'ratings#create'
end
