class Ownership < ActiveRecord::Base
  attr_accessible :company_id, :owner_id

  belongs_to :company
  belongs_to :owner, class_name: "User"
end
