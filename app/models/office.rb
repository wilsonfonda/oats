class Office < ActiveRecord::Base
  attr_accessible :latitude, :latitude_max, :latitude_min, :longitude, :longitude_max, :longitude_min, :name, :range

  belongs_to :company
  has_many :users, dependent: :destroy

  validates :company_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :latitude, presence: true, :numericality => {:greater_than_or_equal_to => -90, 
  														 :less_than_or_equal_to => 90}
  validates :longitude, presence: true, :numericality => {:greater_than_or_equal_to => -180, 
  														 :less_than_or_equal_to => 180}
  validates :latitude_min, :numericality => {:greater_than_or_equal_to => -90, 
  														 :less_than_or_equal_to => 90}
  validates :longitude_min, :numericality => {:greater_than_or_equal_to => -180, 
  														 :less_than_or_equal_to => 180}
  validates :latitude_max, :numericality => {:greater_than_or_equal_to => -90, 
  														 :less_than_or_equal_to => 90}
  validates :longitude_max, :numericality => {:greater_than_or_equal_to => -180, 
  														 :less_than_or_equal_to => 180}	
  validates :range, presence: true	
end
