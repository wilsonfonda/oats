class CompaniesController < ApplicationController
	before_filter :authenticate_user!
	load_and_authorize_resource
	
	def index
		@companies = Company.paginate(:page => params[:page])
	end

	def edit
		@company = Company.find(params[:id])
		@offices = @company.offices
	end

	def update
		@company = Company.find(params[:id])
		@company.update_attributes(params[:company])
		flash[:notice] = "Company information updated."
		redirect_to :back
	end

	def show
		@company = Company.find(params[:id])
		@offices = @company.offices.paginate(:page => params[:page])
	end

	def destroy	
		Company.find(params[:id]).destroy
		flash[:notice] = "Company deleted."
        redirect_to :back
	end
end