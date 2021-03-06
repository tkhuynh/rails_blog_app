class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def new
    #prevent current user to see signup view
    #redirect to its profile page
    if current_user
      redirect_to user_path(current_user)
    else 
      @user = User.new
    end
  end

  def create
    #prevent current user to create new account
    if current_user
      redirect_to user_path(current_user)
    else 
      @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id
        redirect_to user_path(@user)
      else
        flash[:error] = @user.errors.full_messages.join(', ')
        redirect_to new_user_path
      end
    end
  end

  def show
    user_id = params[:id]
    @user = User.find_by_id(user_id)
  end

  def edit
    # prevent current user to see other use edit user view
    user_id = params[:id]
    @user = User.find_by_id(user_id)
    unless current_user == @user # unless the user edit view belong to current user
      redirect_to user_path(current_user)
    end
  end

  def update
    user_id = params[:id]
    @user = User.find_by_id(user_id)
    # prevent current user to edit other user info
    if current_user == @user
      if @user.update_attributes(user_params)
        redirect_to user_path(@user)
      else
        flash[:error] = @user.errors.full_messages.join(', ')
        redirect_to edit_user_path(@user)
      end
    else 
      flash[:notice] = "You cannot edit other user's account!"
      redirect_to user_path(current_user)
    end
  end

  def destroy
    user_id = params[:id]
    @user = User.find_by_id(user_id)
    if current_user == @user
      @user.destroy
      session[:user_id] = nil
      redirect_to root_path
    else
      flash[:notice] = "You cannot delete other user's account!"
      redirect_to user_path(@user)
    end
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end
  	
end
