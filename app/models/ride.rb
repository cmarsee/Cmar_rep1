class Ride < ActiveRecord::Base
  belongs_to :user
  belongs_to :service
  has_many :user_rides
  has_many :users, through: :user_rides
  
  validates :service, presence: true
  validates :user, presence: true
  
  validates :date, presence: true
#                    format: {with: /\A        # begin of input
#                      [\d]   # digits
#                      [-.\/\s]          # dash, dot, backspace, or white space seprator
#			                 [\d] # digits
#                       [-.\/\s]          # dash, dot, backspace, or white space seprator
#                        [\d] # digits
#			                 \z         # end of input
#		                  /xi }
  validate :date_in_future, on: :create
  
  
  validates :leave_time, presence: true
  validates :return_time, presence: true
  validate :return_after_leave
  
  validates :number_of_seats, presence: true, numericality: { only_integer: true, greater_than: 1 }
  validates :seats_available, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0}
  validate :less_than_total_seats
  
  validates :meeting_location, presence: true
  validates :vehicle, presence: true
  
  
  private
  def date_in_future
      errors.add(:date, "can't be in the past") unless date.present? && Date.valid_date?(date.year, date.month, date.day) && date.future?
  end
  
  def less_than_total_seats
    errors.add(:seats_available, "must be less than the total number of seats") unless seats_available.to_i < number_of_seats.to_i
  end
  
  def return_after_leave
    errors.add(:return_time, "must be after you leave") unless return_time.to_i > leave_time.to_i
  end
  
end
