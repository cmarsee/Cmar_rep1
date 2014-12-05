class ChurchesController < ApplicationController
  before_action :ensure_user_logged_in, only: [:new, :create]
#  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  before_action :ensure_church_manager, only: [:edit, :update, :destroy]
  
  def index
    @churches = Church.all
  end
  
  def new
    @church = Church.new
    @church.services.build
  end

  def create
    @church = Church.new(church_params)
    @church.user = current_user
    if @church.save
      flash[:success] = "Church created"
      redirect_to @church
    else
      flash.now[:danger] = "Unable to create church"
      render 'new'
    end
  end
  
  def show
    @church = Church.find(params[:id])
    rescue
		  flash[:danger] = "Unable to find church"
      redirect_to churches_path
  end
  
  def edit
  end
  
  def update
		@church = Church.find(params[:id])
    if @church.update(church_params)
      flash[:success] = "You have modified the church profile"
			redirect_to @church
		else
      flash[:danger] = "Unable to update the church profile"
			render 'edit'
		end
	end
  
  def destroy
    @church = Church.find(params[:id])
    @church.destroy
    flash[:success] = "#{@church.name} removed"
    redirect_to churches_path
  end
  
  private

  def church_params
	  params.require(:church).permit(:name,
		                           :web_site,
		                           :description,
		                           :picture,
				       services_attributes: [ :start_time,
					                        :finish_time,
					                        :location,
       				                    :day_of_week,
                                  :id] )
    end
  
  def ensure_church_manager
    @church = Church.find(params[:id])
    unless current_user?(@church.user) || current_user.admin?
      flash[:danger] = "Only church manager can edit church profile"
      redirect_to root_path
    end
    rescue
		  flash[:danger] = "Unable to find church"
      redirect_to churches_path
  end
    

  
#  def ensure_correct_user
#	  @user = User.find(params[:id])
#	  unless current_user?(@user)
#     flash[:danger] = "Cannot edit other user's church profiles"
#      redirect_to @church
#	  end
#    rescue
#	    flash[:danger] = "Unable to find user"
#	    redirect_to users_path
#  end
  
    def ensure_user_logged_in
    unless current_user
      flash[:warning] = "Not logged in"
      redirect_to login_path
    end
  end
  
end
