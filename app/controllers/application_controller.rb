class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from CanCan::AccessDenied do |exception|
  	flash[:error] = "Access denied."
  	redirect_back_or_default(user_path current_user)
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    flash[:error] = "Not found."
    redirect_back_or_default(user_path current_user)
  end

  def store_location
    session[:return_to] = request.url
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  private
  	def after_sign_in_path_for(users)
  		if current_user.role == '0'
  			companies_path
  		elsif current_user.role == '1'
  			users_path
  		else
	  		user_path current_user
	  	end
  	end

  	def after_sign_up_path_for(users)
  		user_path current_user
  	end
end
