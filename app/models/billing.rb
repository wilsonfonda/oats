class Billing < ActiveRecord::Base
  attr_accessible :month, :payment_date, :price, :total_employee

  belongs_to :company

  validates :company_id, presence: true
end
