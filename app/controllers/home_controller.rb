class HomeController < ApplicationController
  
  skip_before_filter :update_activity_time, :session_expiry
  
  def allowed?(action)
    true
  end
  
  def index
  end
  
end
