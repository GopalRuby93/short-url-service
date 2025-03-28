class UsersController < ApplicationController
  skip_before_action :authenticate_user, only: [:new, :create, :login]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "Signup successful!"
      redirect_to login_path
    else
      flash[:alert] = @user.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def login
    if request.post?
      user = User.find_by(email: params[:email])

      if user&.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:notice] = "Login successful!"
        redirect_to new_short_url_generator_path
      else
        flash[:alert] = "Invalid email or password"
        render :login, status: :unprocessable_entity
      end
    else
      render :login
    end
  end

  private

  def user_params
    params.require(:user).permit(User::PERMITTED_ATTRIBUTES)
  end
end
