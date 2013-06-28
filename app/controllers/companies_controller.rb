class CompaniesController < ApplicationController
	before_filter :authenticate_user!
	load_and_authorize_resource
	
	def index
		@companies = Company.all
	end

	def edit
		@company = Company.find(params[:id])
		@offices = @company.offices
	end

	def update
		@company = Company.find(params[:id])
		@company.update_attributes(params[:company])
		redirect_to :back
	end

	def show
		@company = Company.find(params[:id])
		@offices = @company.offices
	end

	def destroy	
		Company.find(params[:id]).destroy
        redirect_to :back
	end
end