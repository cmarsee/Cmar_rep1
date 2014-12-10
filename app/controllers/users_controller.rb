class UsersController < ApplicationController
    before_action :ensure_user_logged_in, only: [:edit, :update, :destroy]
    before_action :ensure_user_logged_out, only: [:new, :create]
    before_action :ensure_correct_user, only: [:edit, :update]
    before_action :ensure_admin, only: [:destroy]

    def index
	    @users = User.all
    end

    def new
	    @user = User.new
    end

    def create
	    @user = User.new(user_params)
	    if @user.save
	        flash[:success] = "Welcome to the site, #{@user.name}"
	        redirect_to @user
	    else
	        flash.now[:danger] = "Unable to create new user"
	        render 'new'
	    end
    end
	
	def show
		@user = User.find(params[:id])
	  rescue
		  flash[:danger] = "Unable to find user"
		  redirect_to users_path
    end
	
	def edit
	end
	
	def update
		@user = User.find(params[:id])
    if params[:church_id]
      @user.church_id = params[:church_id]
      flash[:success] = "Now attending Church"
      @user.save
      redirect_to @user.church
    elsif params[:ride_id]
      @ride = Ride.find(params[:ride_id])
      if @ride.seats_available.to_i > 0
        @user.rides << @ride
        @ride.seats_available = @ride.seats_available - 1
        flash[:success] = "Now have a ride to Church"
        @user.save
        @ride.save
        redirect_to @ride
      else
        flash[:danger] = "Ride is full"
        render_to @ride
      end
    else
      if @user.update(user_params)
			  flash[:success] = "You have modified your profile"
			  redirect_to @user
		  else
			  flash[:danger] = "Unable to update your profile"
			  render 'edit'
		  end
    end
    rescue
    flash[:danger] = "Something went wrong"
		  redirect_to user_path(@user)
	end
    
    def destroy
      @user = User.find(params[:id])
      @user.destroy
      flash[:success] = "#{@user.name} removed from the site"
      redirect_to users_path
    end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :church_id)
    end
    
    def ensure_user_logged_in
        unless current_user
            flash[:warning] = "Not logged in"
            redirect_to login_path
        end
    end
    
    def ensure_user_logged_out
        if current_user
            flash[:warning] = "Currently logged in"
            redirect_to root_path
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
    
    def ensure_admin
        redir = false
        unless current_user.admin?
            flash[:danger] = "Only admins allowed to delete users"
            redir = true
        end
        @user = User.find(params[:id])
        if current_user?(@user) && current_user.admin
          flash[:danger] = "Unable to delete self"
          redir = true
        end
        if redir
          redirect_to root_path
        end
    end
end
