class User < ActiveRecord::Base
  has_many :rides_provided, class_name: "Ride", foreign_key: "user_id"
  has_many :user_rides
  has_many :rides, through: :user_rides
  
  has_one :church
  #  if the chruch profile manager dosen't attend that church, use:
#  has_one :chruch_managed, class_name: "Church", foreign_key: "user_id"
  
  has_secure_password
    
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

end
