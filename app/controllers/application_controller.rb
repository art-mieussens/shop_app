#Encoding: utf-8
class ApplicationController < ActionController::Base
  
  protect_from_forgery
  before_filter :authorize
  before_filter :update_activity_time, :session_expiry

#accessible from views
  helper_method :logged_in?,
                :current_user,
                :is_root?,
                :allowed?,
                :current_user_has_role?,
                :coins_round_up,
                :params_to_date
                
protected

  # before filters 
  def authorize
    unless self.allowed?(action_name)
    flash[:error] = "No está autorizado a ejecutar esa acción."
    redirect_back_or_root 
    end
  end
  
  def update_activity_time
    session[:expires_at] = 10.minutes.from_now
  end
  
  def session_expiry  
    if (session[:expires_at] - Time.now).to_i <= 0
      reset_session
      flash[:error] = "La sesion ha expirado, ingrese de nuevo."
      redirect_to new_connection_url
    end
  end
    
  # helpers
  def logged_in?
    session[:user_id]
  end

  def current_user
    User.find(session[:user_id])
  end
  
  def is_root?
    session[:user_id] == 1
  end
  
  def allowed?(*action)
    false unless is_root?
  end
  
  def current_user_has_role?(role)
    is_root? or logged_in? ? current_user.roles.map{|r| r.name == role}.include?(true) : false
  end
  
  def redirect_back_or_root
    if request.env["HTTP_REFERER"]
      redirect_to :back
    else
      redirect_to :root
    end
  end
  
  def to_decimal(string)
    string.gsub(/[.,]\d\d\d/){|s| s[1..3]}.gsub(/[,]/, '.')
  end
  
  def coins_round_up(number, factor)
    x = number/factor
    xr = x.round
    x = xr < x ? xr + 1 : xr
    x * factor
  end
  
  def params_to_date(par)
    Time.mktime(par[:year], par[:month], par[:day]).to_date if par
  end
  
  def params_to_datetime(par)
    Time.mktime(par[:year], par[:month], par[:day], par[:hour], par[:minute]).to_datetime if par
  end
end
