class UserImportsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def new
    @user_import = UserImport.new
  end

  def create
    if !params[:user_import].nil?
      @user_import = UserImport.new(params[:user_import])
      if @user_import.save(current_user.company_id)
        flash[:notice] = "Imported employees successfully."
        redirect_to users_path
      else
        render :new
      end
    else
      flash[:error]="Wrong File format"
      redirect_to new_user_import_path
    end
  end
end