class UsersController < ApplicationController

	def index
		@users = User.all
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
