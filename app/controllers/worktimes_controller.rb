class WorktimesController < ApplicationController
	before_filter :authenticate_user!, :only => :index
	load_and_authorize_resource
	
	def index
		if params[:id].nil?
			if !params[:from].nil? && !params[:to].nil?
				if current_user.role != "3"
					@offices = Company.find(current_user.company_id).offices
					@users = User.where("office_id IN (?)",@offices)
					@worktimes = Worktime.where("user_id IN (?) and checkin > ? and checkout < ?", @users, Time.parse(params[:from]), Time.parse(params[:to]).advance(:hours => 24)).includes(:user)
					respond_to do |format|
						format.html
						format.xls
					end
				else
					flash[:alert]="Access Denied."
					redirect_to user_path current_user
				end
			else
				flash[:alert]="Worktimes date range is unavailable."
				redirect_to user_path current_user
			end
		else
			@user = User.find(params[:id])
			@worktime = @user.worktimes[0]
			@worktimes = Worktime.where("user_id = ? and checkin > ? and checkout < ?", @user.id.to_s, Time.parse(params[:from]), Time.parse(params[:to]).advance(:hours => 24))
			@worktimes_paged = @worktimes.paginate(:page => params[:page], :per_page => 10)
			if !@worktime.nil?
				if cannot? :read, @worktime
					flash[:alert]="Access Denied."
					redirect_to worktimes_path+"?id="+current_user.id.to_s + "&from=" + Time.now.advance(:hours => -168).strftime("%d-%m-%Y") + "&to=" + Time.now.strftime("%d-%m-%Y")
				end
			end
		end
	end

	def create
		if (params[:access_token].nil?)
			@worktime = current_user.worktimes.build()
		    @office = Office.find(current_user.office_id)
		    @worktime.checkin = Time.now
		    if valid_location(@office, params[:latitude], params[:longitude])
		    	@worktime.place_checkin = @office.name
		    	@worktime.save
		    	flash[:notice] = "Successfully checked in."
		    else
		    	@offices = Office.where("company_id = ? AND id <> ?", @office.company_id, @office.id)
		    	found = false
		    	@offices.each  do | o |
		    		if valid_location(o, params[:latitude], params[:longitude])
		    			@worktime.place_checkin = o.name
		    			@worktime.save
		    			flash[:notice] = "Successfully checked in."
		    			found = true
		    			break
		    		end
		    	end
		    	if !found
		    		flash[:error] = "Failed to checkin. Please check your location."
		    	end
		    end
		    redirect_to :back
		else
			@user = User.find_by_access_token(params[:access_token])
			if @user.nil?
				render :json => { :code => '501', :time => '0' }
			else
				if (User.checkin?(@user))
					render :json => { :code => '504', :time => '0' }
				else
					@worktime = @user.worktimes.build()
				    @office = Office.find(@user.office_id)
				    @worktime.checkin = Time.now
				    if valid_location(@office, params[:latitude], params[:longitude])
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
				    		if valid_location(o, params[:latitude], params[:longitude])
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
		    if valid_location(@office, params[:latitude], params[:longitude])
				@worktime.update_attribute('checkout',Time.now)
				@worktime.update_attribute('place_checkout',@office.name)
				flash[:notice] = "Successfully checked out."
		    else
		    	@offices = Office.where("company_id = ? AND id <> ?", @office.company_id, @office.id)
		    	found = false
		    	@offices.each  do | o |
		    		if valid_location(o, params[:latitude], params[:longitude])
						@worktime.update_attribute('checkout',Time.now)
						@worktime.update_attribute('place_checkout',o.name)
						flash[:notice] = "Successfully checked out."
						found = true
		    			break
		    		end
		    	end
		    	if !found
		    		flash[:error] = "Failed to checkout. Please check your location."
		    	end
		    end
	      	redirect_to :back
		else
			@user = User.find_by_access_token(params[:access_token])
			if @user.nil?
				render :json => { :code => '501', :time => '0' }
			else
				if (!User.checkin?(@user))
					render :json => { :code => '504', :time => '0' }
				else
					@worktime = Worktime.find_by_user_id(@user, :limit => 1, :order => 'created_at desc')
					@office = Office.find(@user.office_id)
				    if valid_location(@office, params[:latitude], params[:longitude])
				    	if @worktime.update_attribute('checkout',Time.now) && @worktime.update_attribute('place_checkout',@office.name)
		    				render :json => { :code => '200', :time => Time.now }
		    			else
		    				render :json => { :code => '503', :time => '0' }
		    			end
				    else
				    	@offices = Office.where("company_id = ? AND id <> ?", @office.company_id, @office.id)
				    	found = false
				    	@offices.each  do | o |
				    		if valid_location(o, params[:latitude], params[:longitude])
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

    def mobile_graph
		@user = User.find_by_access_token(params[:access_token])
		if @user.nil?
			render :json => { :code => '501' }
		elsif Time.parse(params[:from]) > Time.parse(params[:to])
			render :json => { :code => '502' }
		else
			arr = Array.new
			worktimes = Worktime.where("user_id = ? and checkin > ? and checkout < ?", @user.id, Time.parse(params[:from]), Time.parse(params[:to]).advance(:hours => 24))
			date = Time.parse(params[:from])
			x = 0
			while date <= Time.parse(params[:to])
				a = 0
				if !worktimes[x].nil? && date.strftime("%d-%m-%Y") == worktimes[x].checkin.strftime("%d-%m-%Y")
				    a = (worktimes[x].checkout - worktimes[x].checkin).to_i
				    x += 1
				    while !worktimes[x].nil? && worktimes[x].checkin.strftime("%d-%m-%Y") == worktimes[x-1].checkin.strftime("%d-%m-%Y") 
				      a += (worktimes[x].checkout - worktimes[x].checkin).to_i
				      x += 1
				    end
				    arr.push({:date => date.strftime("%d-%m-%Y"), :worktime => (a.to_f/3600).to_s})
				else
				    arr.push({:date => date.strftime("%d-%m-%Y"), :worktime => '0'})
				end
				date += 1.day
			end
			render :json => { :code => '200', :performance => arr }
		end
    end

    private

    	def valid_location (office, latitude, longitude)
    		return (latitude.to_f > office.latitude_min) && (latitude.to_f < office.latitude_max) && 
    		(longitude.to_f > office.longitude_min) && (longitude.to_f < @office.longitude_max)
    	end
end