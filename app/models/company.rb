class Company < ActiveRecord::Base
  attr_accessible :address, :contact, :deposit, :name, :status

  has_many :offices, dependent: :destroy
  has_many :billings, dependent: :destroy
  has_one :ownership, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }

  def self.search(search)  
    if search  
      where('name LIKE ?', "%#{search}%")  
    else  
      scoped  
    end  
  end  
end
