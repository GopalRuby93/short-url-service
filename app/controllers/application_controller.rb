class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session, if: -> { request.format.json? }
    before_action :authenticate_user
  
    include ApiExceptionsHandler
    include ApiResponse
  
    private
  
    def authenticate_user
      unless current_user
        handle_authentication_error
      end
    end
  
    def current_user
      if request.path.start_with?("/api/")
        header = request.headers['Authorization']
        token = header.split(' ').last if header.present?
        begin
          decoded_token = JsonWebToken.decode(token)
          @current_user ||= User.find_by(id: decoded_token[:user_id]) if decoded_token
        rescue JWT::DecodeError
          nil
        end
      else
        @current_user ||= User.find_by(id: session[:user_id])
      end
    
      @current_user
    end
    

    def handle_authentication_error
      if request.format.json?
        render_error_response(error: "Invalid token", message: "Unauthorized", status: 401)
      else
        flash[:alert] = "Please log in first"
        redirect_to login_path
      end
    end
end
