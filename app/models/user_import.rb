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

  def save(id)
    if imported_users(id).map(&:valid?).all?
      imported_users(id).each(&:save!)
      true
    else
      imported_users(id).each_with_index do |user, index|
        user.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def imported_users(id)
    @imported_users ||= load_imported_users(id)
  end

  def load_imported_users(id)
    spreadsheet = open_spreadsheet
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).map do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      user = User.where("email = ? AND office_id IN (?)",row["email"],Company.find(id).offices).first
      if !user.nil?
        user.name = row["name"] unless (row["name"].nil? && row["name"].blank?)
        user.division = row["division"] unless (row["division"].nil? && row["division"].blank?)
        o = Office.where("company_id = ? AND name = ?",id,row["office"]).first
        if !row["office"].nil? && !row["office"].blank? && !o.nil?
          user.office_id = o.id
        end
      else
        user = User.new
        user.email = row["email"]
        user.name = row["name"]
        user.division = row["division"]
        o = Office.where("company_id = ? AND name = ?",id,row["office"]).first
        if !row["office"].nil? && !row["office"].blank? && !o.nil?
          user.office_id = o.id
        else
          user.office_id = Company.find(id).offices.first
        end
        user.role = '3'
        user.password = user.email || "123123"
        user.password_confirmation = user.email || "123123"
        user.access_token = Digest::SHA2.hexdigest(user.email || "123123") + Array.new(8){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join 
      end
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