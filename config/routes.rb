Rails.application.routes.draw do
  # resources :recipe_tags
  resources :tags
  # resources :recipe_ingredients
  resources :ingredients
  resources :likes
  resources :comments
  resources :users
  # resources :recipes
  #resources :follows
  
  get "/recipes", to: "recipes#show_user_recipes"
  get '/recipes/search/:query', to: 'recipes#search'
  get "/recipes/:user_name/following_recipes", to: "recipes#following_recipes"

  get '/recipes/by_tag/:tag_id', to: 'recipes#tag_recipes'

  get "/recipes/:id", to: "recipes#show"
  post "/recipes", to: "recipes#create"
  patch "/recipes/:id", to: "recipes#update"
  delete "/recipes/:id", to: "recipes#destroy"

  post '/users/login', to: "users#login"
  post '/users/register', to: "users#register"
  post '/users/logout', to: "users#logout"
  get 'users/:id/following', to: "users#following"
  get '/followings', to: 'follows#index'
  post '/followings/new', to: "follows#add_follow"
  delete 'followings/:id', to: "follows#destroy"  #here id is the Follow instance id

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
