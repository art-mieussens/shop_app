#coding: utf-8

class SalesController < ApplicationController
  
  def allowed?(*action)
    true
  end
  
  def new
    redirect_to :action => "create"
  end
  
  def create
    @sale = Sale.new
    @sale.seller_id = session[:user_id]
    if @sale.save
      redirect_to sale_url(@sale), :notice => "Nueva venta creada."
    else
      flash[:error] = "No se pudo crear la venta."
      render 'new'
    end
  end
  
  def index
    if params[:start_date] && params[:end_date]
      @sales = Sale.where :closed_at => (params_to_date(params[:start_date]).beginning_of_day)..(params_to_date(params[:end_date]).end_of_day)
    else
      @sales = Sale.where :closed_at => (Date.today.beginning_of_day)..Time.now
    end
    @sales_number = @sales.count
    @sales_total = @sales.collect{|sale| sale.total}.inject(:+)
    @costs_total = @sales.collect{|sale| sale.cost}.inject(:+)
    @sales = @sales.order(:ticket_number).page(params[:page]).per(20)
  end
  
  def show
    @sale = Sale.find(params[:id])
    @sale_line = SaleLine.new
    @sale_line.rate = @sale.rate
  end
  
  def edit
    @sale = Sale.find(params[:id])
  end
  
  def update
    @sale = Sale.find(params[:id])    
    if @sale.update_attributes(params[:sale])
      redirect_to sale_url(@sale), :notice => "Venta modificada."
    else
      flash[:error] = "No se pudo modificar la venta."
      render 'edit'
    end
  end
  
  def destroy
    @sale = Sale.find(params[:id])
    if @sale.destroy
      redirect_to sales_url, :notice => "Venta borrada."
    else
      flash[:error] = "No se pudo modificar la venta."
      render 'edit'
    end
  end
  
  #close the sale and go check payment
  def close
    @next_sale_number = Sale.where("closed_at is not null").order(:ticket_number).last.ticket_number + 1
    @sale = Sale.find(params[:sale_id])
    if @sale.update_attributes(:closed => true,
                               :closed_at => Time.now,
                               :ticket_number => @next_sale_number)
      @sale.process
      redirect_to sale_check_payment_url(@sale)
    else
      flash[:error] = "La venta no se pudo cerrar."
      redirect_to sale_url(@sale)
    end
  end
  
  #help with change and choose cash or card
  def check_payment
    @sale = Sale.find(params[:sale_id])
    unless params[:commit] == "Pagar"
      @card = params[:card] == "true" ? true : false
      @payment = to_decimal(params[:payment]) if params[:payment].present?
      if @payment.present?
        if @payment.to_f
          @change = @payment.to_f - @sale.total
        end
      end
    else
      @sale.update_attributes(:payed => true,
                              :card => params[:card],
                              :payment => params[:payment].present? ? to_decimal(params[:payment]) : nil )
    if @printer = Printer.find(cookies[:printer])
      @sale.print_ticket(@printer)
    else
      flash[:notice] = "No hay impresora seleccionada."
    end      
      redirect_to pos_menu_path
    end
  end
  
  def open
    if @sale = Sale.find(params[:sale_id])
      @sale.open
      redirect_to sale_url(@sale), :notice => "Venta abierta."
    else
      flash[:error] = "No se encuentra la venta."
      redirect_to sale_url(@sale)
    end
  end
  
  def print_ticket
    if @printer = Printer.find(cookies[:printer])
      @sale = Sale.find(params[:sale_id])
      @sale.print_ticket(@printer)
    else
      flash[:notice] = "No hay impresora seleccionada."
    end
    redirect_to sale_url(@sale)
  end
  
  def abstract
    @start_date = params_to_date(params[:start_date]) || Date.today
    @end_date = params_to_date(params[:end_date]) || Date.today
    @lines = []
    (@start_date..@end_date).each do |date|
      @day_sales = Sale.where :closed_at => (date.beginning_of_day)..(date.end_of_day)
      if @day_sales.present?      
        @lines << { :date => date,
                    :sales_number => @day_sales.count,
	  	    :first_ticket => @day_sales.collect{|s|s.ticket_number}.min,
	            :last_ticket => @day_sales.collect{|s|s.ticket_number}.max,
                    :sales_total => @day_sales.collect{|sale| sale.total}.inject(:+),
                    :costs_total => @day_sales.collect{|sale| sale.cost}.inject(:+) }
      else
        @lines << { :date => date,
                    :sales_number => 0,
                    :first_ticket => nil,
                    :last_ticket => nil,
                    :sales_total => 0,
                    :costs_total => 0 }
      end
    end
    
    if params[:make_pdf]
      pdf = Prawn::Document.new( :page_size => 'A4',
                                 :margin => [54] )
      pdf.text "Homy hogar y decoración", :size => 11
      pdf.text "C. Corazón de María 3", :size => 11
      pdf.text "28002 Madrid", :size => 11                      
      pdf.image "public/images/logo_bw.png", :width => 60, :at => [440, 750]
      pdf.move_down 24
      pdf.text "Resumen de ventas, de #{@start_date.strftime("%d / %m / %Y")} a #{@end_date.strftime("%d / %m / %Y")}", :size => 12
      pdf.move_down 16
      
      pdf.table( [[ "Fecha", "Tickets", "Desde", "Hasta", "Ventas" ]],
                  :column_widths => [100, 50, 50, 50, 100],
                  :cell_style => {:size => 10,
                                  :padding => 2,
                                  :align => :right,
                                  :borders => [:bottom] } )
      
      @lines.each do |l|
        pdf.table( [[ l[:date].strftime("%d / %m / %Y"), l[:sales_number], l[:first_ticket], l[:last_ticket], sprintf('%.2f €', l[:sales_total]) ]],
                    :column_widths => [100, 50, 50, 50, 100],
                    :cell_style => {:size => 10,
                                    :padding => 2,
                                    :align => :right,
                                    :borders => [] })
      end
      
      pdf.table( [[ "Totales:",
                    @lines.count.to_s,
                    @lines.collect{|line| line[:sales_number].to_i }.inject(:+),"","",
                    sprintf('%.2f €', @lines.collect{|line| line[:sales_total].to_f }.inject(:+)) ]],
                  :column_widths => [60, 40, 50, 50, 50, 100],
                  :cell_style => {:size => 10,
                                  :padding => 2,
                                  :align => :right,
                                  :borders => [:top] } )

      #generate pdf
      pdf.render_file "public/pdf/sales_abstracts/abstract#{@start_date.strftime("%Y%m%d")}-#{@end_date.strftime("%Y%m%d")}.pdf"
      send_file "public/pdf/sales_abstracts/abstract#{@start_date.strftime("%Y%m%d")}-#{@end_date.strftime("%Y%m%d")}.pdf", :type => 'application/pdf'
    end
    
  end
  
end

