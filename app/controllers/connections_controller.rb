class ConnectionsController < ApplicationController
  
  skip_before_filter :update_activity_time, :session_expiry
  
  def allowed?(action)
    true
  end
  
  def new
  end

  def create
    if user = User.authenticate(params[:name], params[:password])
      session[:user_id] = user.id 
      redirect_to root_url, :notice => "Successfully logged in."
    else
      redirect_to new_connection_url, :notice => "Invalid user/password."
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out."
  end
  
end
