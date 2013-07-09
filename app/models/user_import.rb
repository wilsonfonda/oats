class UserImport
  # switch to ActiveModel::Model in Rails 4
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :file

  def initialize(attributes = {})
    attributes.each { |name, value| send("#{name}=", value) }
  end

  def persisted?
    false
  end

  def save
    if imported_users.map(&:valid?).all?
      imported_users.each(&:save!)
      true
    else
      imported_users.each_with_index do |user, index|
        user.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def imported_users
    @imported_users ||= load_imported_users
  end

  def load_imported_users
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      user = User.find_by_id(row["id"]) || User.new
      user.attributes = row.to_hash.slice(*User.accessible_attributes)
      valid_office = false
      if(!row["office_id"].nil?)
        Company.find(current_user.company_id).offices.each do |o|
          if(row["office_id"].to_i == o.id)
            valid_office = true
          end
        end
      end
      if valid_office
        user.office_id = row["office_id"].to_i
      else
        user.office_id = Company.find(params[:id]).offices.first
      end
      user.role = '3'
      user.password = user.email
      user.password_confirmation = user.email
      user.access_token = Digest::SHA2.hexdigest(user.email) + Array.new(8){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
      user
    end
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end