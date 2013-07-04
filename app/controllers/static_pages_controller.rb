class StaticPagesController < ApplicationController

  def home
    if user_signed_in?
      redirect_to(user_path current_user)
    end
  end

  def help
  end

  def about
  end

  def privacy
  end

  def testimony
  end

  def contact
  end

  def terms
  end

  def routing_error
    flash[:error] = "Page not found."
    if user_signed_in?
      redirect_back_or_default(user_path current_user)
    else
      redirect_back_or_default(root_path)
    end
  end
end