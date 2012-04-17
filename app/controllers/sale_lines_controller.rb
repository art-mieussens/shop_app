class SaleLinesController < ApplicationController
  
  def allowed?(*action)
    true
  end
  
  def create
    if params[:commit] == "buscar" #if a search was entered, pass it to the sale and show it again
      session[:product_search] = params[:product_search]
      redirect_to sale_path(params[:sale_id])
    else
      @sale = Sale.find(params[:sale_id])
      if @product = Product.find_by_code_or_bar_code(params[:product_search])
        params[:sale_line][:product_id] = @product.id
        params[:sale_line][:price] = @product.get_price(Rate.find(params[:sale_line][:rate_id]))
        @sale.sale_lines.create(params[:sale_line])
        redirect_to sale_url(@sale)
      else
        flash[:error] = "No se encuentra el producto."
        redirect_to sale_url(@sale)
      end
    end
  end
  
  def destroy
    @sale = Sale.find(params[:sale_id])
    @sale.sale_lines.delete(SaleLine.find(params[:id]))
    redirect_to sale_url(@sale), :notice => "Linea de venta eliminada."
  end
  
end
