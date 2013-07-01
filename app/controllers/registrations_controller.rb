class RegistrationsController < Devise::RegistrationsController

  def new
    super
  end

  def create
    @company = Company.new()
    @company.name = params[:company_name]
    @company.address = params[:company_address]
    @company.contact = params[:company_contact]
    @company.status = true
    @company.deposit = 0

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

    @user = @office.users.build()
    @user.email = params[:email]
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    @user.name = params[:name]
    @user.division = params[:division]
    @user.access_token = Digest::SHA2.hexdigest(params[:email]) + Array.new(8){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
    @user.role = 1

    if (@company.save && @office.save && @user.save)
        @ownership = Ownership.new()
        @ownership.company_id = @company.id
        @ownership.owner_id = @user.id  
        @ownership.save
        sign_in @user
        redirect_to user_path current_user
    else
        redirect_to :back
    end
  end

  def update
    super
  end   

end 