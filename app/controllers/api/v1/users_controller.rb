class Api::V1::UsersController < ApplicationController
    skip_before_action :authenticate_user, only: [:create, :login]

    def create
      user = User.new(user_params)
 
      if user.save
        token = JsonWebToken.encode(user_id: user.id)
        render_success_response(data: { user: user, token: token }, message: "User registered successfully", status:200)
      else
        render_error_response(error: user.errors.full_messages, message: "User registration failed", status:422)
      end
    end

    def login
      user = User.find_by(email: params[:email])
  
      if user && user.authenticate(params[:password])
        token = JsonWebToken.encode(user_id: user.id)
        render_success_response(data: { user: user, token: token }, message: "Login successful", status: 200)
      else
        render json: { error: "Invalid email or password", message: "Invalid email or password" }, status: 401
      end
    end

    private
  
    def user_params
      params.require(:user).permit(User::PERMITTED_ATTRIBUTES)
    end
  end
  