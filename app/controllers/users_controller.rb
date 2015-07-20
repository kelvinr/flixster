class UsersController < ApplicationController
  before_action :require_user, only: :show

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    result = UserSignup.new(@user).sign_up(params[:stripeToken], params[:token])

    if result.successful?
      flash[:success] = "Thank you for signing up!"
      redirect_to login_path
    else
      flash.now[:danger] = result.error_msg
      render :new
    end
  end

  def invited_registration
    @invitation = Invitation.find_by(token: params[:token])
    if @invitation
      @user = User.new(email: @invitation.recipient_email)
      render :new
    else
      redirect_to expired_token_path
    end
  end

private

  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end
end
