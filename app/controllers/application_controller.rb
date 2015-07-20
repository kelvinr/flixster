class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:danger] = "You must be logged in to do that!"
      redirect_to login_path
    end
  end

  def access_denied
    flash[:danger] = "You can't do that!"
    redirect_to root_path
  end

  def correct_user
    _model = controller_path.classify.constantize
    access_denied unless current_user == _model.find(params[:id]).user
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def logged_in
    redirect_to home_path if current_user
  end
end
