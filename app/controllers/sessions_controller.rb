class SessionsController < ApplicationController
  before_action :logged_in, except: :destroy

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
        flash[:success] = "You are now signed in, enjoy!"
        redirect_to home_path
      else
        flash[:danger] = "Your account has been suspended, please contact customer service."
        redirect_to login_path
      end
    else
      flash.now[:danger] = "Incorrect username or password."
      render :new
    end
  end

  def destroy
    if logged_in?
      session[:user_id] = nil
      flash[:info] = "You have signed out."
      redirect_to root_path
    end
  end
end
