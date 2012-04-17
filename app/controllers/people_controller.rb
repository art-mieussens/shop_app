class PeopleController < ApplicationController
  
  def allowed?(action)
    true
  end
  
  def new
    @person = Person.new
  end
  
  def create
    @person = Person.new(params[:person])
    if @person.save
      redirect_to people_url, :notice => "Nueva persona creada."
    end
  end
  
  def index
    if params[:select]
      @select = params[:select]
      @people = Person.where(@select.to_sym => true).order(:first_name)
    else
      @people = Person.order(:first_name)
    end
  end
  
  def show
    @person = Person.find(params[:id])
  end
  
  def edit
    @person = Person.find(params[:id])
  end
  
  def update
  end
  
  def destroy
    @person = Person.find(params[:id])
    if @person.destroy
      redirect_to people_url, :notice => "Persona borrada"
    end
  end
  
end
