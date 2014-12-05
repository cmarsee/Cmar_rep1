class RidesController < ApplicationController
  before_action :ensure_user_logged_in, only: [:edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update]
  
  def index
    @service = Service.find(params[:service_id])
	  order_param = (params[:order] || :Date).to_sym
	  ordering = case order_param
	    when :Date
	       :date
	    when :Service
	      :service_id
	    end
    @rides = @service.rides.order(ordering)
  end
  
  def show
    @ride = Ride.find(params[:id])
    rescue
    flash[:danger] = "Unable to find ride"
    redirect_to rides_path
  end
  
#  def new
#    @ride = Ride.new
#  end
  
  def create
    @service = Service.find(params[:service_id])
    @ride = @service.rides.build(ride_params)
    @ride.user = current_user
#    puts @ride.date
#    puts @ride.user
#    puts current_user
    if @ride.save
      flash[:success] = "Ride created"
      redirect_to @ride
    else
      flash.now[:danger] = "Unable to create ride"
      render 'new'
    end
  end
  
  
private
  def ride_params
    params.require(:ride).permit(:user_id, :service_id, :date, :vehicle, :leave_time, :return_time, :number_of_seats, :seats_available, :meeting_location, :id)
  end
  
  def ensure_user_logged_in
    unless current_user
      flash[:warning] = "Not logged in"
      redirect_to login_path
    end
  end
  
  def ensure_correct_user
	  @user = User.find(params[:id])
	  unless current_user?(@user)
      flash[:danger] = "Cannot edit other user's profiles"
	    redirect_to root_path
	  end
  rescue
	  flash[:danger] = "Unable to find user"
	  redirect_to users_path
  end
    
end
