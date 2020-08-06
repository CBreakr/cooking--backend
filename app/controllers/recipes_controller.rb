
require 'json';

require 'uri'
require 'net/http'

class RecipesController < ApplicationController
    # index (based on given user_id)
    # show
    # create (includes all the join tables and related elements)
    # update (includes all the join tables and related elements)
    # delete

    # social 
    # search --> this should be its own distinct thing
    ### wait on this one for later

    #render recipes list of a user, given user id, route: /:user_id/recipes
    def show_user_recipes
        # recipes = Recipe.find_user_recipes(params[:user_id].to_i)
        recipes = []
        if current_user then
            puts "we have a user"
            recipes = current_user.recipes.map do |recipe|
                recipe.image = recipe.getImageUrl
                recipe
            end
        else
            puts "No current user"
            # recipes = Recipe.all
        end
        render json: recipes, :include => :user, except: [:created_at, :updated_at]
    end
    
    #render recipes that are posted by user's followings, given user_id, route: /:user_id/following_recipes 
    def following_recipes
        recipes = Recipe.find_following_recipes(params[:user_name])
        render json: recipes, :include => :user, except: [:created_at, :updated_at]
    end
    
    #recipe list of given tag name, given tag_id, route: /tag/:tag_id/recipes
    def tag_recipes 
        recipes = Recipe.tag_recipes(params[:tag_id])
        render json: recipes, :include => :user, except: [:created_at, :updated_at]
    end
    
    def liked_recipes
        recipes = Recipe.user_liked_recipes(params[:user_id])
        render json: recipes, except: [:created_at, :updated_at]
    end
    
    #show details about this recipe, along with its ingredients, likes, comments, tags
    def show
        # recipe = Recipe.find(params[:id])
        if params[:id].include?('A')
            recipe_api_id = params[:id]
            recipe_api_id[0] = ''
            api_recipe = Recipe.find_by(api_id: recipe_api_id)
            if api_recipe
                details = api_recipe.full_recipe_info(api_recipe.id)
            else  
                recipe = Recipe.get_recipe_from_api(recipe_api_id)
                details = recipe.full_recipe_info(recipe.id)
            end
        else  
            recipe = Recipe.find(params[:id])
            details = recipe.full_recipe_info(params[:id].to_i)
        end

        # puts "We have a recipe match"
        # details = recipe.full_recipe_info(params[:id].to_i)
        puts details
        render json: details, except: [:created_at, :updated_at]
    end
    
    #given a recipe title, seach for recipes that match the query 
    def search 
        recipes = []

        recipes += Recipe.search_recipes(params[:query])

        api_recipes = Recipe.api_search(params[:query])

        # get all the unique ones before adding them so we don't compound the time it takes
        non_overlap = api_recipes.filter do |ar|
            recipes.none? {|r| r.api_id == ar.api_id}
        end

        recipes += non_overlap

        puts "RECIPE SEARCH"
        puts recipes

        render json: recipes, :include => :user, except: [:created_at, :updated_at]
    end
    
    def create
        puts "CREATE RECIPE"
        puts "CREATE RECIPE"
        puts "CREATE RECIPE"
        puts "CREATE RECIPE"
        puts "CREATE RECIPE"
        puts "CREATE RECIPE"
        puts "CREATE RECIPE"
        puts recipe_params

        puts "FULL RECIPE PARAMS"
        puts "FULL RECIPE PARAMS"
        puts "FULL RECIPE PARAMS"
        puts "FULL RECIPE PARAMS"
        puts "FULL RECIPE PARAMS"
        puts "FULL RECIPE PARAMS"
        puts "FULL RECIPE PARAMS"
        puts "FULL RECIPE PARAMS"
        puts params

        recipe = Recipe.new(recipe_params)
        recipe.user = current_user

        if params[:tags] then
            tags = JSON.parse(params[:tags])
            recipe.set_tags(tags)
        end

        puts params[:ingredients]

        if params[:ingredients] then
            ingredients = JSON.parse(params[:ingredients])
            recipe.set_ingredients(ingredients)
        end

        recipe.updateImage(params)

        puts "RECIPE AFTER IMAGE"
        puts recipe

        if recipe.save then
            puts "valid recipe"
        else
            puts "INVALID RECIPE"
        end
        render json: recipe, except: [:created_at, :updated_at]
    end

    def update
        recipe = Recipe.find(params[:id])

        puts "UPDATE RECIPE"
        puts "UPDATE RECIPE"
        puts "UPDATE RECIPE"
        puts "UPDATE RECIPE"
        puts "UPDATE RECIPE"
        puts "UPDATE RECIPE"
        puts "UPDATE RECIPE"
        puts "UPDATE RECIPE"
        puts recipe_params

        recipe.update(recipe_params)

        puts "FULL RECIPE PARAMS"
        puts "FULL RECIPE PARAMS"
        puts "FULL RECIPE PARAMS"
        puts "FULL RECIPE PARAMS"
        puts "FULL RECIPE PARAMS"
        puts "FULL RECIPE PARAMS"
        puts "FULL RECIPE PARAMS"
        puts "FULL RECIPE PARAMS"
        puts params

        puts params[:tags]

        if params[:tags] then
            tags = JSON.parse(params[:tags])
            recipe.set_tags(tags)
        end

        puts params[:ingredients]

        if params[:ingredients] then
            ingredients = JSON.parse(params[:ingredients])
            recipe.set_ingredients(ingredients)
        end

        recipe.updateImage(params)

        recipe.save

        if recipe.valid? then
            puts "valid recipe"
        else
            puts "INVALID RECIPE"
        end

        render json: recipe, except: [:created_at, :updated_at]
    end

    def destroy 
        recipe = Recipe.find(params[:id])
        recipe.destroy
    end

    def copy_recipe
        puts "COPY"
        puts "COPY"
        puts "COPY"
        puts "COPY"
        puts "COPY"
        puts "COPY"
        puts "COPY"
        puts "COPY"
        puts "COPY"
        puts "COPY"
        puts "COPY"
        puts "COPY"
        recipe = Recipe.find(params[:id])
        id = recipe.create_copy(current_user)
        render json: {id: id}
    end

    private 
    def recipe_params
        # params.require(:recipe).permit(:title, :image, :description, :steps, :isPublic)
        params.permit(:title, :image, :description, :steps, :isPublic)
    end
end
