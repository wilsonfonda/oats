class Presence < ActiveRecord::Base
  attr_accessible :date, :flag, :note
  belongs_to :user

  validates :user_id, presence: true
  validates :note, length: { maximum: 255 }
  validates :date, presence: true
end
