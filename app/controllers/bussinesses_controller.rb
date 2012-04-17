# coding: utf-8

class BussinessesController < ApplicationController
  
  def allowed?(action)
    true
  end
    
  def new
    @bussiness = Bussiness.new
  end
  
  def create
    @bussiness = Bussiness.new(params[:bussiness])
    if @bussiness.save
      redirect_to bussinesses_url, :notice => "Nueva empresa creada."
    else
      redirect_to :back
    end
  end
  
  def index
    if params[:select]
      @select = params[:select]
      @bussinesses = Bussiness.where(@select.to_sym => true).order(:name)
    else
      @bussinesses = Bussiness.order(:name)
    end
  end
  
  def suppliers
    @bussinesses = Bussiness.where(:supplier => true)
    @bussinesses.order(:name)
    render 'index'
  end
  
  def customers
    @bussinesses = Bussiness.where(:customer => true)
    @bussinesses.order(:name)
    render 'index'
  end
  
  def show
    @bussiness = Bussiness.find(params[:id])
  end
  
  def edit
    @bussiness = Bussiness.find(params[:id])
  end
  
  def update
    @bussiness = Bussiness.find(params[:id])
    if @bussiness.update_attributes(params[:bussiness])
      redirect_to bussinesses_url, :notice => "Empresa modificada."
    end
  end
  
  def destroy
    @bussiness = Bussiness.find(params[:id])
    if @bussiness.destroy
      redirect_to bussinesses_url, :notice => "Empresa borrada."
    else
      redirect_to bussinesses_url, :notice => "No se ha podido borrar la empresa."
    end
  end
  
end
