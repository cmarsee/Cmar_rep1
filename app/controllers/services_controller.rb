class ServicesController < ApplicationController
  before_action :ensure_user_logged_in, only: [:edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update]
  
  def index
    order_param = (params[:order] || :Day).to_sym
    case order_param
    when :Day
      @services = Service.all.to_a
      weekorder = {"Sunday" => 1, "Monday" => 2, "Tuesday" => 3, "Wednesday" => 4, "Thursday" => 5, "Friday" => 6, "Saturday" => 7}
      @services.sort! {|a,b| weekorder[a.day_of_week] <=> weekorder[b.day_of_week]}
 # own sort operation
    when :Time
      @services = Service.order(:start_time)
    end
  end
  
  def show
    @service = Service.find(params[:id])
    rescue
      flash[:danger] = "Unable to find service"
      redirect_to services_path
  end
  
  def update
    @service = Service.find(params[:id])
    if @service.update(service_params)
      flash[:success] = "You have modified the service profile"
      redirect_to @service.church
		else
      flash[:danger] = "Unable to update the service profile"
			render 'edit'
		end
  end
  
  def edit
  end
  
  private
  def service_params
    params.require(:service).permit(:start_time,
					                        :finish_time,
					                        :location,
       				                    :day_of_week,
                                  :id )
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

