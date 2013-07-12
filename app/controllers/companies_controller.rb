class CompaniesController < ApplicationController
	before_filter :authenticate_user!
	load_and_authorize_resource
	helper_method :sort_column, :sort_direction
	
	def index
		@companies = Company.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(:page => params[:page])
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

	private
		def sort_direction  
		  %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"  
		end  

		def sort_column  
		  Company.column_names.include?(params[:sort]) ? params[:sort] : "id"  
		end  
end