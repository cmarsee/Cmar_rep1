class ChurchesController < ApplicationController
  before_action :ensure_user_logged_in, only: [:edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  def index
    @churches = Church.all
  end
  
  def new
	  @church = Church.new
  end
  
  def create
    @church = Church.new(church_params)
	    if @church.save
        flash[:success] = "You have created a new church, #{@user.name}"
	      redirect_to @church
	    else
	      flash.now[:danger] = "Unable to create new church"
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
    @church = Church.find(params[:id])
  end
  
  def update
    @church = Church.find(params[:id])
      if @church.update(church_params)
        flash[:success] = "You have modified the church profile"
        redirect_to root_path
		  else
        flash[:danger] = "Unable to update the church profile"
			  render 'edit'
		  end
  end
  
  def destroy
      @church = Church.find(params[:id])
          @church.destroy
          flash[:success] = "#{@church.name} removed from the site"
       redirect_to root_path
  end
  
  private
  
      def church_params
        params.require(:church).permit(:name, :picture, :web_site, :description)
        
      end
  
    def ensure_user_logged_in
        unless current_user
            flash[:warning] = "Not logged in"
            redirect_to login_path
        end
    end
  
    def ensure_correct_user
	    @church = Church.find(params[:id])
      unless current_user?(@church.user)
            flash[:danger] = "Cannot edit other user's church profiles"
	        redirect_to root_path
	    end
      rescue
	      flash[:danger] = "Unable to find user"
	      redirect_to users_path
    end
  
end
