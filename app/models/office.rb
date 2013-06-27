class Office < ActiveRecord::Base
  attr_accessible :latitude, :latitude_max, :latitude_min, :longitude, :longitude_max, :longitude_min, :name, :range

  belongs_to :company
  has_many :users, dependent: :destroy
end
