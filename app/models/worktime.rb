class Worktime < ActiveRecord::Base
  attr_accessible :checkin, :checkout, :place_checkin, :place_checkout
  belongs_to :user
  
  validates :user_id, presence: true
  validates :place_checkin, length: { maximum: 50 }
  validates :place_checkout, length: { maximum: 50 }

  def self.search(search)  
    if search 
      where('place_checkin LIKE ? OR place_checkout LIKE ?',  "%#{search}%", "%#{search}%")  
    else  
      scoped  
    end  
  end  
end
