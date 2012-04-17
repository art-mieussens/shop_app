class RolesController < ApplicationController
  
  def allowed?(action)
    true
  end
  
  def index
    @roots = Role.all_roots
  end
  
  def new
    @role = Role.new
    @parent = Role.find(params[:role_id]) if params[:role_id]
  end
  
  def create
    @role = Role.new(params[:role])
    @parent = Role.find(params[:role_id]) if params[:role_id]
    if @role.save
      @parent.add_child(@role)
      redirect_to(roles_url, :notice => "Nuevo Rol creado.")
    else
      render new_role_path
    end
  end
  
  def destroy
    @role = Role.find(params[:id])
    if params[:user_id]
      User.find(params[:user_id]).roles.delete(@role)
      redirect_to users_url, :notice => "Rol eliminado."
    else
      @role.full_set.each do |role|
        role.users.each do |user|
          role.users.delete(user)
        end
        role.destroy
      end
      redirect_to roles_url, :notice => "Rol borrado."
    end
  end
  
  def edit
    @role = Role.find(params[:id])
  end
  
  def update
    @role = Role.find(params[:id])
    if @role.update_attributes(params[:role])
      redirect_to roles_url, :notice => 'Rol modificado.'
    else
      render edit_role_url(@role)
    end
  end

end
