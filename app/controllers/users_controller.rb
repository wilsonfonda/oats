class UsersController < ApplicationController
	before_filter :authenticate_user!, :except => :mobile_signin
	load_and_authorize_resource
	
	def index
		@offices = Company.find(current_user.company_id).offices
		@users = User.where("office_id IN (?)",@offices).paginate(:page => params[:page])
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
      @user.access_token = Digest::SHA2.hexdigest(params[:user][:email]) + Array.new(8){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
      if @user.save
      	flash[:notice] = "Employee succesfully added."
      else
      	flash[:error] = "Failed to add employee."
      end
      redirect_to :back
    end

	def show
		unless Worktime.find_by_user_id(current_user, :limit => 1, :order => 'created_at desc').nil?
	      @timer = (Time.now - Worktime.find_by_user_id(current_user, :limit => 1, :order => 'created_at desc').checkin).to_i
	    end
		@user = User.find(params[:id])
	end

	def destroy	
		User.find(params[:id]).destroy
		flash[:notice] = "Employee succesfully deleted."
        redirect_to :back	
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if can? :change_role, @user
			if @user.update_attributes(params[:user])
				flash[:notice] = "Employee information updated."
			else
				flash[:error] = "Failed to update employee information"
			end
		else
			if @user.update_attributes(params[:user].except(:role))
				flash[:notice] = "Employee information updated."
			else
				flash[:error] = "Failed to update employee information"
			end
		end
		redirect_to :back
	end

	def change_password
		@user = User.find(params[:id])
		if (@user.valid_password?(params[:user][:old_password]) && (params[:user][:password] == params[:user][:password_confirmation]) && params[:user][:password].length > 5 )
			@user.update_attribute('password',params[:user][:password])
			@user.update_attribute('password_confirmation',params[:user][:password_confirmation])
			flash[:notice] = "Successfully change your password"
			sign_in @user,:bypass => true
		else
			flash[:error] = "Invalid old / new password"
		end
		redirect_back_or_default(user_path current_user)
	end

	def mobile_signin
		@user = User.find_by_email(params[:email])
		if @user.nil?
			render :json => { :code => '502' }
		else
			if !@user.valid_password?(params[:password])
				render :json => { :code => '501' }
			else
				render :json => { :code => '200', :access_token => @user.access_token }
			end
		end
	end
end
