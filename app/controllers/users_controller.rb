class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_response
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_response

    before_action :authorize
    skip_before_action :authorize, only: [:create]

    #POST /signup
    def create
        user = User.create!(user_params)
        session[:user_id] = user.id
        render json: user, status: :created
    end

    #GET /me
    def show
        user = User.find(session[:user_id])
        render json: user, status: :created
    end


    private

    def user_params
        params.permit(:username, :bio, :password, :password_confirmation, :image_url)
    end

    def unprocessable_entity_response invalid
        render json: {errors: [invalid.message]}, status: :unprocessable_entity
    end

    def record_not_found_response invalid
        render json: {errors: [invalid.message]}, status: :not_found
    end

end
