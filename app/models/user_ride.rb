class UserRide < ActiveRecord::Base
  belongs_to :user
  belongs_to :ride
  
  validates :ride, presence: true
  validates :user, presence: true
end
