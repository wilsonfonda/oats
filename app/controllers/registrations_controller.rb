class RegistrationsController < Devise::RegistrationsController

  def new
    super
  end

  def create
    if (valid_parameters(params))
        @company = Company.new()
        @company.name = params[:company_name]
        @company.address = params[:company_address]
        @company.contact = params[:company_contact]
        @company.status = true
        @company.deposit = 0
        @company.save

        @office = @company.offices.build()
        @office.name = params[:office_name]
        @office.range = params[:office_range]
        @office.latitude = params[:office_latitude]
        @office.longitude = params[:office_longitude]
        delta_lat = params[:office_range].to_f / 6378137 * 180 / Math::PI
        delta_long = 2 * Math.asin(Math.sin(params[:office_range].to_f / 12756274) / Math.cos(params[:office_latitude].to_f * Math::PI / 180)) * 180 / Math::PI
        @office.latitude_min = params[:office_latitude].to_f - delta_lat
        @office.latitude_max = params[:office_latitude].to_f + delta_lat
        @office.longitude_min = params[:office_longitude].to_f - delta_long
        @office.longitude_max = params[:office_longitude].to_f + delta_long
        @office.save   

        @user = @office.users.build()
        @user.email = params[:email]
        @user.password = params[:password]
        @user.password_confirmation = params[:password_confirmation]
        @user.name = params[:name]
        @user.division = params[:division]
        @user.access_token = Digest::SHA2.hexdigest(params[:email]) + Array.new(8){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
        @user.role = 1
        
        if @user.save
            @ownership = Ownership.new()
            @ownership.company_id = @company.id
            @ownership.owner_id = @user.id  
            @ownership.save
            sign_in @user
            redirect_to user_path current_user
        else
            @company.delete
            @office.delete
            flash[:alert] = "Email or password is invalid."
            redirect_to :back
        end
    else
        flash[:alert] = "Invalid parameters."
        redirect_to :back
    end
  end

  def update
    super
  end   

  private
    def valid_parameters(params)
        return (!params[:company_name].blank? && params[:company_name].length < 51 &&
        !params[:office_name].blank? && params[:office_name].length < 51 &&
        !params[:name].blank? && params[:name].length < 51 &&
        !params[:company_contact].blank? &&
        !params[:office_range].blank? && params[:office_range].to_f > 0 &&
        !params[:office_latitude].blank? && params[:office_latitude].to_f >= -90 && params[:office_latitude].to_f <= 90 &&
        !params[:office_longitude].blank? && params[:office_longitude].to_f >= -180 && params[:office_longitude].to_f <= 180 &&
        !params[:email].blank? && !params[:password].blank? && params[:password] == params[:password_confirmation])
    end
end 