# encoding: utf-8

class MerchandiseReceptionsController < ApplicationController
  
  def allowed?(action)
    true
  end
  
  def new
    @merchandise_reception = MerchandiseReception.new
    @suppliers = Bussiness.where(:supplier => true).order(:name)
    @employees = Person.where(:employee => true).order(:first_name)
  end
  
  def create
    @merchandise_reception = MerchandiseReception.new(params[:merchandise_reception])
    if @merchandise_reception.save
      redirect_to merchandise_receptions_url, :notice => "Nuevo albarán creado."
    else
      @suppliers = Bussiness.where(:supplier => true).order(:name)
      @employees = Person.where(:employee => true).order(:first_name)
      render new_merchandise_reception_path
    end
  end
  
  def index
    @merchandise_receptions = MerchandiseReception.order("received_at DESC").page(params[:page]).per(15)
  end
  
  def show
    @merchandise_reception = MerchandiseReception.find(params[:id])
    @merchandise_reception.clear_nils
  end
  
  def edit
    @merchandise_reception = MerchandiseReception.find(params[:id])
    @merchandise_reception.clear_nils
    @merchandise_reception.calculate if params[:recalculate]
    @suppliers = Bussiness.where(:supplier => true).order(:name)
    @employees = Person.where(:employee => true).order(:first_name)
  end
  
  def update
    @merchandise_reception = MerchandiseReception.find(params[:id])
    params[:merchandise_reception][:discount] = to_decimal params[:merchandise_reception][:discount]
    params[:merchandise_reception][:sum18] = to_decimal params[:merchandise_reception][:sum18]
    params[:merchandise_reception][:sum8] = to_decimal params[:merchandise_reception][:sum8]
    params[:merchandise_reception][:sum4] = to_decimal params[:merchandise_reception][:sum4]
    params[:merchandise_reception][:disc18] = to_decimal params[:merchandise_reception][:disc18]
    params[:merchandise_reception][:disc8] = to_decimal params[:merchandise_reception][:disc8]
    params[:merchandise_reception][:disc4] = to_decimal params[:merchandise_reception][:disc4]
    params[:merchandise_reception][:bi18sum] = to_decimal params[:merchandise_reception][:bi18sum]
    params[:merchandise_reception][:bi8sum] = to_decimal params[:merchandise_reception][:bi8sum]
    params[:merchandise_reception][:bi4sum] = to_decimal params[:merchandise_reception][:bi4sum]
    params[:merchandise_reception][:vat18sum] = to_decimal params[:merchandise_reception][:vat18sum]
    params[:merchandise_reception][:vat8sum] = to_decimal params[:merchandise_reception][:vat8sum]
    params[:merchandise_reception][:vat4sum] = to_decimal params[:merchandise_reception][:vat4sum]
    params[:merchandise_reception][:req18sum] = to_decimal params[:merchandise_reception][:req18sum]
    params[:merchandise_reception][:req8sum] = to_decimal params[:merchandise_reception][:req8sum]
    params[:merchandise_reception][:req4sum] = to_decimal params[:merchandise_reception][:req4sum]
    params[:merchandise_reception][:transport_cost] = to_decimal params[:merchandise_reception][:transport_cost]
    params[:merchandise_reception][:other_cost] = to_decimal params[:merchandise_reception][:other_cost]
    if @merchandise_reception.update_attributes(params[:merchandise_reception])
      if params[:commit] == "recalcular"
        @merchandise_reception.calculate
        redirect_to edit_merchandise_reception_url(@merchandise_reception), :notice => "Nota de recepción recalculada."
      else
        redirect_to @merchandise_reception, :notice => "Nota de recepción modificada."
      end
    else
      @suppliers = Bussiness.where(:supplier => true).order(:name)
      @employees = Person.where(:employee => true).order(:first_name)      
      render :action => :edit
    end
  end
  
  def destroy
    @merchandise_reception = MerchandiseReception.find(params[:id])
    if @merchandise_reception.destroy
      redirect_to merchandise_receptions_url, :notice => "Albarán borrado."
    else
      redirect_back
    end    
  end

  def process_and_close
    @merchandise_reception = MerchandiseReception.find(params[:merchandise_reception_id])
    
    @bi_total = @merchandise_reception.bi18sum.to_f + @merchandise_reception.bi8sum.to_f + @merchandise_reception.bi4sum.to_f
    @costs_total = @merchandise_reception.transport_cost.to_f + @merchandise_reception.other_cost.to_f - @merchandise_reception.discount.to_f
    @factor_global = @bi_total == 0 ? 0 : @costs_total / @bi_total
    @factor18 = @merchandise_reception.bi18sum == 0 ? 0 : (@merchandise_reception.vat18sum.to_f + @merchandise_reception.req18sum.to_f) / @merchandise_reception.bi18sum.to_f
    @factor8 = @merchandise_reception.bi8sum == 0 ? 0 : (@merchandise_reception.vat8sum.to_f + @merchandise_reception.req8sum.to_f) / @merchandise_reception.bi8sum.to_f
    @factor4 = @merchandise_reception.bi4sum == 0 ? 0 : (@merchandise_reception.vat4sum.to_f + @merchandise_reception.req4sum.to_f) / @merchandise_reception.bi4sum.to_f    

    @merchandise_reception.merchandise_reception_lines.each do |mrl|
      @im = InventoryMovement.new
      @im.product_id = mrl.product_id
      @im.quantity = mrl.quantity
      if mrl.product.vat == 4
        @im.unit_cost = (mrl.unit_cost.to_f * (1 + @factor4 + @factor_global + @factor4 * @factor_global)).round(2)
      elsif mrl.product.vat == 8
        @im.unit_cost = (mrl.unit_cost.to_f * (1 + @factor8 + @factor_global + @factor8 * @factor_global)).round(2)
      else  # mrl.product.vat.blank? || mrl.product.vat == 18
        @im.unit_cost = (mrl.unit_cost.to_f * (1 + @factor18 + @factor_global + @factor18 * @factor_global)).round(2)
      end
      @im.save
      mrl.update_attributes({:inventory_movement_id => @im.id})
    end
    @merchandise_reception.update_attributes({:closed => true, :processed_by => current_user.id })
    redirect_to merchandise_reception_url(@merchandise_reception), :message => "Nota de recepción procesada y cerrada."
  end
  
end
