class RidesController < ApplicationController
  before_action :ensure_user_logged_in, only: [:new, :create, :destroy, :edit, :update]
  before_action :ensure_correct_user, only: [:destroy, :edit, :update]
  
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
#    redirect_to @ride
    rescue
    flash[:danger] = "Unable to find ride"
    redirect_to rides_path
  end
  
  def create
    @service = Service.find(params[:service_id])
    @ride = @service.rides.build(ride_params)
    @ride.user = current_user
    if @ride.save
      flash[:success] = "Ride created"
      redirect_to @ride
    else
      flash.now[:danger] = "Unable to create ride"
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    @ride = Ride.find(params[:id])
    if @ride.update(ride_params)
      flash[:success] = "You have modified the this rides profile"
      redirect_to @ride
		else
      flash[:danger] = "Unable to update theis rides profile"
			render 'edit'
		end
#  rescue
#    flash[:warning] = "Please login"
#		  redirect_to churches_path
	end
  
  def destroy
    @ride = Ride.find(params[:id])
    @ride.destroy
    flash[:success] = "This ride removed"
    redirect_to rides_path
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
    @ride = ride.find(params[:id])
    unless current_user?(@ride.user)
      flash[:danger] = "Cannot edit other user's profiles"
	    redirect_to root_path
	  end
  rescue
    flash[:danger] = "Unable to find ride"
    redirect_to rides_path
  end
    
end
