class UsersController < ApplicationController
	before_filter :authenticate_user!
	load_and_authorize_resource
	
	def index
		@users = User.all
	end

	def add
	  if current_user.role == '0' || current_user.role == '1'
      	@user = User.new(params[:user])
      else
      	@user = User.new(params[:user].except(:role))
      	@user.role = '3'
      end
      @user.password = params[:user][:email]
      @user.password_confirmation = params[:user][:email]
      @user.access_token = Digest::SHA2.hexdigest(params[:user][:email])
      @user.save
      redirect_to :back
    end

	def show
		@user = User.find(params[:id])
	end

	def destroy	
		User.find(params[:id]).destroy
        redirect_to :back	
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		@user.update_attributes(params[:user])
		redirect_to :back
	end

	def change_password
		@user = User.find(params[:id])
		if (@user.valid_password?(params[:user][:old_password]) && (params[:user][:password] == params[:user][:password_confirmation]))
			@user.update_attribute('password',params[:user][:password])
			@user.update_attribute('password_confirmation',params[:user][:password_confirmation])
			sign_in @user
		end
		redirect_to :back
	end

end
