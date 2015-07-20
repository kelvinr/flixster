class PasswordResetsController < ApplicationController
  before_action :logged_in
  before_action :get_user, except: :new
  before_action :valid_user, only: [:edit, :update]

  def create
    if @user
      @user.ship('password_reset')
      render :confirmation
    else
      flash.now[:danger] = "Email address not found."
      render :new
    end
  end

  def update
    if @user.update(user_params)
      @user.clear_reset
      flash[:success] = "Your password has been reset."
      redirect_to login_path
    else
      render :edit
    end
  end

private

  def user_params
    params.require(:user).permit(:password)
  end

  def get_user
    @user = User.find_by(email: params[:email].downcase)
  end

  def valid_link?
    return false if @user.reset_digest.nil?
    BCrypt::Password.new(@user.reset_digest).is_password?(params[:id])
  end

  def valid_user
    unless valid_link?
      redirect_to :expired_token
    end
  end
end
