class WorktimesController < ApplicationController
	before_filter :authenticate_user!
	load_and_authorize_resource
	
	def index
		@user = User.find(params[:id])
		@worktime = @user.worktimes[0]
		if @worktime.nil?
			redirect_to user_path current_user
		else
			if cannot? :read, @worktime
				redirect_to worktimes_path+"?id="+current_user.id.to_s
			end
		end
	end

	def create
		if (params[:access_token].nil?)
			@worktime = current_user.worktimes.build()
		    @office = Office.find(current_user.office_id)
		    @worktime.checkin = Time.now
		    if (params[:latitude].to_f > @office.latitude_min) && (params[:latitude].to_f < @office.latitude_max &&
		    	params[:longitude].to_f > @office.longitude_min) && (params[:longitude].to_f < @office.longitude_max)
		    	@worktime.place_checkin = @office.name
		    	@worktime.save
		    else
		    	@offices = Office.where("company_id = ? AND id <> ?", @office.company_id, @office.id)
		    	@offices.each  do | o |
		    		if (params[:latitude].to_f > o.latitude_min) && (params[:latitude].to_f < o.latitude_max &&
		    			params[:longitude].to_f > o.longitude_min) && (params[:longitude].to_f < o.longitude_max)
		    			@worktime.place_checkin = o.name
		    			@worktime.save
		    			break
		    		end
		    	end
		    end
		    redirect_to :back
		else
			@user = User.find_by_access_token(params[:access_token])
			if @user.nil?
				render :json => { :code => '501', :time => '0' }
			else
				if (User.checkin?(@user))
					render :json => { :code => '505', :time => '0' }
				else
					@worktime = @user.worktimes.build()
				    @office = Office.find(@user.office_id)
				    @worktime.checkin = Time.now
				    if (params[:latitude].to_f > @office.latitude_min) && (params[:latitude].to_f < @office.latitude_max &&
				    	params[:longitude].to_f > @office.longitude_min) && (params[:longitude].to_f < @office.longitude_max)
				    	@worktime.place_checkin = @office.name
				    	if @worktime.save
		    				render :json => { :code => '200', :time => Time.now }
		    			else
		    				render :json => { :code => '503', :time => '0' }
		    			end
				    else
				    	@offices = Office.where("company_id = ? AND id <> ?", @office.company_id, @office.id)
				    	found = false;
				    	@offices.each  do | o |
				    		if (params[:latitude].to_f > o.latitude_min) && (params[:latitude].to_f < o.latitude_max &&
				    			params[:longitude].to_f > o.longitude_min) && (params[:longitude].to_f < o.longitude_max)
				    			@worktime.place_checkin = o.name
				    			if @worktime.save
				    				render :json => { :code => '200', :time => Time.now }
				    			else
				    				render :json => { :code => '503', :time => '0' }
				    			end
				    			found = true
				    			break
				    		end
				    	end
				    	if !found
				    		render :json => { :code => '502', :time => '0' }
				    	end
				    end
				end
			end
		end
	end

	def update
		if (params[:access_token].nil?)
		    @worktime = Worktime.find_by_user_id(current_user, :limit => 1, :order => 'created_at desc')
			@office = Office.find(current_user.office_id)
		    if (params[:latitude].to_f > @office.latitude_min) && (params[:latitude].to_f < @office.latitude_max &&
		    	params[:longitude].to_f > @office.longitude_min) && (params[:longitude].to_f < @office.longitude_max)
				@worktime.update_attribute('checkout',Time.now)
				@worktime.update_attribute('place_checkout',@office.name)
		    else
		    	@offices = Office.where("company_id = ? AND id <> ?", @office.company_id, @office.id)
		    	@offices.each  do | o |
		    		if (params[:latitude].to_f > o.latitude_min) && (params[:latitude].to_f < o.latitude_max &&
		    			params[:longitude].to_f > o.longitude_min) && (params[:longitude].to_f < o.longitude_max)
						@worktime.update_attribute('checkout',Time.now)
						@worktime.update_attribute('place_checkout',o.name)
		    			break
		    		end
		    	end
		    end
	      	redirect_to :back
		else
			@user = User.find_by_access_token(params[:access_token])
			if @user.nil?
				render :json => { :code => '501', :time => '0' }
			else
				if (!User.checkin?(@user))
					render :json => { :code => '505', :time => '0' }
				else
					@worktime = Worktime.find_by_user_id(@user, :limit => 1, :order => 'created_at desc')
					@office = Office.find(@user.office_id)
				    if (params[:latitude].to_f > @office.latitude_min) && (params[:latitude].to_f < @office.latitude_max &&
				    	params[:longitude].to_f > @office.longitude_min) && (params[:longitude].to_f < @office.longitude_max)
				    	if @worktime.update_attribute('checkout',Time.now) && @worktime.update_attribute('place_checkout',@office.name)
		    				render :json => { :code => '200', :time => Time.now }
		    			else
		    				render :json => { :code => '503', :time => '0' }
		    			end
				    else
				    	@offices = Office.where("company_id = ? AND id <> ?", @office.company_id, @office.id)
				    	found = false
				    	@offices.each  do | o |
				    		if (params[:latitude].to_f > o.latitude_min) && (params[:latitude].to_f < o.latitude_max &&
				    			params[:longitude].to_f > o.longitude_min) && (params[:longitude].to_f < o.longitude_max)
								if @worktime.update_attribute('checkout',Time.now) && @worktime.update_attribute('place_checkout',o.name)
				    				render :json => { :code => '200', :time => Time.now }
				    			else
				    				render :json => { :code => '503', :time => '0' }
				    			end
				    			found = true
				    			break
				    		end
				    	end
				    	if !found
				    		render :json => { :code => '502', :time => '0' }
				    	end
				    end
				end
			end
		end
    end
end