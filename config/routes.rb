Rails.application.routes.draw do
  # resources :recipe_tags
  resources :tags
  # resources :recipe_ingredients
  resources :ingredients
  resources :likes
  resources :comments
  # resources :users
  # resources :recipes
  #resources :follows
  
  get "/recipes", to: "recipes#show_user_recipes"
  get '/recipes/search/:query', to: 'recipes#search'
  get "/recipes/:user_name/following_recipes", to: "recipes#following_recipes"

  get '/recipes/by_tag/:tag_id', to: 'recipes#tag_recipes'

  get '/recipes/liked/:user_id', to: 'recipes#liked_recipes' #get user's liked recipes

  get "/recipes/:id", to: "recipes#show"
  post "/recipes", to: "recipes#create"
  patch "/recipes/:id", to: "recipes#update"
  delete "/recipes/:id", to: "recipes#destroy"

  post "/recipes/:id/copy", to: "recipes#copy_recipe"

  get "/users/ping", to: "users#ping"
  post '/users/login', to: "users#login"
  post '/users/register', to: "users#register"
  post '/users/logout', to: "users#logout"
  patch '/users/password_reset', to: "users#password_reset"
  post '/users/trigger_reset', to: "users#trigger_reset"
  get 'users/:id/following', to: "users#following"

  get '/followings', to: 'follows#index'
  post '/followings/new', to: "follows#add_follow"
  delete 'followings/:id', to: "follows#destroy"  #here id is the Follow instance id

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
