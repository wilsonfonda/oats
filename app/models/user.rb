class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :trackable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :division, :role, :access_token
  
  has_many :worktimes, dependent: :destroy
  has_one :ownership, foreign_key: "owner_id", dependent: :destroy
  belongs_to :office

  delegate :company_id, :to => :office

  validates :office_id, presence: true
  validates :name, presence:true, length: { maximum: 50 }
  validates :role, presence: true

  def self.checkin?(user)
    w = Worktime.find_by_user_id(user, :limit => 1, :order => 'created_at desc')
    unless (w.nil?)
      !w.checkin.nil? && w.checkout.nil?
    end
  end
end
