class UsersController < ApplicationController

	def index
		@users = User.all
	end

	def add
      @user = User.new(params[:user])
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

	def update
		@user = User.find(params[:id])
		@user.update_attributes(params[:user])
		redirect_to :back
	end

end
