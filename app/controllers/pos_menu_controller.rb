class PosMenuController < ApplicationController

  def allowed?(action)
    true
  end
  
  def index
    @sales = Sale.where("closed_at is not null").order("closed_at DESC").page(params[:page]).per(15)
    @open_sales = Sale.where("closed_at is null").order("created_at DESC")
  end

end
