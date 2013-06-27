class RegistrationsController < Devise::RegistrationsController

  def new
    super
  end

  def create
    @user = User.new(params[:user])
  	@user.role = 'a'
  	@user.save
  end

  def update
    super
  end   

end 