class RecipesController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_response
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_response

    before_action :authorize

    #GET /recipes
    def index
        current_user = User.find(session[:user_id])
        render json: current_user.recipes, status: :ok
    end

    #POST /recipes
    def create
        current_user = User.find(session[:user_id])
        current_user.recipes.create!(recipe_params)
        render json: current_user.recipes.last, status: :created
    end



    private

    def unprocessable_entity_response invalid
        render json: {errors: [invalid.message]}, status: :unprocessable_entity
    end

    def record_not_found_response invalid
        render json: {errors: [invalid.message]}, status: :not_found
    end

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete, )
    end
end
