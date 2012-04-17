class UsersController < ApplicationController

  # Access control
  
  def allowed?(action)
    current_user_has_role?('administrator') ? true : super
  end

  # Actionsrequire 'contact_book_controller'
  

  def index
    @users = User.order(:name)
    @all_roles = Role.order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  def show    
    if params[:id] != '1' || is_root?
      @user = User.find(params[:id])
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @user }
      end
    else
      redirect_to_back_or_root 'You are not allowed to access that record.'
    end
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to users_url, :notice => 'User was successfully created.'
    else
      render :action => :new
    end
  end

  def update
    @user = User.find(params[:id])
    @user.roles << Role.find(params[:user][:roles])
    if @user.update_attributes(params[:id])
      redirect_to(users_url, :notice => 'User was updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    if accessing_root?
      redirect_to_back_or_root "Root user can't be deleted"
    elsif accessing_current_user?
      redirect_to_back_or_root "You can't delete your own user"
    else
      @user = User.find(params[:id])
      @user.destroy
      respond_to do |format|
        format.html { redirect_to(users_url, :notice => 'User was deleted.') }
        format.xml  { head :ok }
      end
    end
  end

  def add_role
    @user = User.find(params[:id])
    @role = Role.find(params[:role_id])
    @user.roles << @role if @user and @role
    redirect_to users_url, :notice => 'Role added.'
  end

  def remove_role
    @user = User.find(params[:id])
    @role = Role.find(params[:role_id])
    @user.roles.delete(@role) if @user && @role
    redirect_to users_url, :notice => 'Role removed.'
  end

private

  def accessing_root?
    params[:id] == '1'
  end

  def accessing_current_user?
    params[:id] == current_user.id.to_s
  end
  
end
