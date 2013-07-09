class OfficesController < ApplicationController
	before_filter :authenticate_user!
	load_and_authorize_resource
	
	def create
		@company = Company.find(Ownership.find_by_owner_id(current_user).company_id)
		@office = @company.offices.build()
	    @office.name = params[:office][:name]
	    @office.range = params[:office][:range]
	    @office.latitude = params[:office][:latitude]
	    @office.longitude = params[:office][:longitude]
	    delta_lat = params[:office][:range].to_f / 6378137 * 180 / Math::PI
	    delta_long = 2 * Math.asin(Math.sin(params[:office][:range].to_f / 12756274) / Math.cos(params[:office][:latitude].to_f * Math::PI / 180)) * 180 / Math::PI
	    @office.latitude_min = params[:office][:latitude].to_f - delta_lat
	    @office.latitude_max = params[:office][:latitude].to_f + delta_lat
	    @office.longitude_min = params[:office][:longitude].to_f - delta_long
	    @office.longitude_max = params[:office][:longitude].to_f + delta_long
	    if @office.save
	    	flash[:notice] = "Office created."
	    else
	    	flash[:error] = "Failed to create office"
	    end
	    redirect_to :back
	end

	def edit
		@office = Office.find(params[:id])
	end

	def update
		@office = Office.find(params[:id])
		@office.update_attributes(params[:office])
		delta_lat = params[:office][:range].to_f / 6378137 * 180 / Math::PI
	    delta_long = 2 * Math.asin(Math.sin(params[:office][:range].to_f / 12756274) / Math.cos(params[:office][:latitude].to_f * Math::PI / 180)) * 180 / Math::PI
	    @office.update_attribute('latitude_min',params[:office][:latitude].to_f - delta_lat)
	    @office.update_attribute('latitude_max',params[:office][:latitude].to_f + delta_lat)
	    @office.update_attribute('longitude_min',params[:office][:longitude].to_f - delta_long)
	    @office.update_attribute('longitude_max',params[:office][:longitude].to_f + delta_long)
	    flash[:notice] = "Office updated."
		redirect_to company_path(current_user.company_id)
	end

	def destroy	
		Office.find(params[:id]).destroy
		flash[:notice] = "Office deleted."
        redirect_to :back
	end

end