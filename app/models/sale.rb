#coding: utf-8

class Sale < ActiveRecord::Base
  
  belongs_to :customer, :polymorphic => true
  belongs_to :seller, :class_name => "person"
  belongs_to :rate
  
  has_many :sale_lines, :dependent => :destroy
  
  validates_presence_of :seller_id
  
  before_destroy :clear #remove inventory movements and sale lines before deleting this sale
  
  #create an inventory movement for each line on this sale when it's closed
  def process
    self.sale_lines.each do |sl|
      sl.create_inventory_movement( :product_id => sl.product_id,
                                    :quantity => -sl.quantity,
                                    :unit_cost => Product.find(sl.product_id).unit_cost )
    end
  end
  
  #delete all inventory movements for this sale and mark it as open
  def open
    if self.closed
      @sale_lines = self.sale_lines
      if @sale_lines.present?
        @sale_lines.each do |sl|
          if sl.inventory_movement_id
            InventoryMovement.find(sl.inventory_movement_id).destroy
            sl.update_attributes(:inventory_movement_id => nil)
          end
        end
      end
      self.update_attributes(:closed => false)
    end
  end
  
  #open this sale and thend delete all it's lines
  def clear
    self.open
    @sale_lines = self.sale_lines
    @sale_lines.each{|sl| sl.destroy} if @sale_lines.present?
    self.update_attributes(:closed => false)
  end
  
  def total
    self.sale_lines.collect{|sale_line| sale_line.quantity * sale_line.price}.inject(:+) || 0
  end
  
  def cost
    self.sale_lines.collect{|sale_line| sale_line.quantity * sale_line.product.unit_cost(self.closed_at)}.inject(:+) || 0
  end
  
  def print_ticket(printer)
    pdf = Prawn::Document.new( :page_size => [225, 280],
                               :margin => [25, 15] )
                               
    pdf.text "Homy, hogar y decoración", :size => 10
    pdf.text "c/ Corazón de María 3", :size => 9
    pdf.text "28002 Madrid", :size => 9                      
    pdf.image "public/images/logo_bw.png", :width => 60, :at => [120, 230]
    pdf.move_down 12
    pdf.text "Ticket ##{self.ticket_number}"
    pdf.text "id: #{self.id}", :size => 8
    pdf.text "Fecha: #{closed_at.strftime("%d/%m/%Y")}", :size => 9
    pdf.text "Hora: #{closed_at.strftime("%H:%M:%S")}", :size => 9
    pdf.move_down 8

    pdf.table( [[ "código", "tarifa", "p.unit.", "#", "suma" ]],
                :column_widths => [59, 45, 33, 13, 35],
                :cell_style => {:size => 8,
                                :padding => 2,
                                :align => :right,
                                :borders => [:bottom] } )

    self.sale_lines.each do |sl|

      pdf.table( [[sl.product.description]],
                 :width => 185,
                 :cell_style => { :size => 8,
                                  :padding => 2,
                                  :align => :left,
                                  :borders => [] } )
      pdf.table( [[ sl.product.code,
                  sl.rate.description == "Estándar" ? "" : sl.rate.description,
                  "%.2f" % sl.price << "€",
                  sl.quantity,
                  "%.2f" % (sl.price * sl.quantity) << "€" ]],
                  :column_widths => [59, 45, 33, 13, 35],
                  :cell_style => {:size => 8,
                                  :padding => 2,
                                  :align => :right,
                                  :borders => [] } )      
    end

    pdf.move_down 2
    @pago = self.card ? "tarjeta" : "efectivo"
    pdf.table( [[ "IVA incluido", "", "", "Total " << @pago, "%.2f" % self.total << "€" ]],
                :column_widths => [59, 25, 3, 63, 35],
                :cell_style => {:size => 8,
                                :padding => 2,
                                :align => :right,
                                :borders => [:top] } )
    pdf.move_down 10
    pdf.text "15 días para cambios presentando este ticket", :size => 8
    pdf.text "Sólo hacemos devoluciones por vale de compra", :size => 8

    #generate pdf ticket
    pdf.render_file "data/tickets/ticket#{self.ticket_number}.pdf"

    #print ticket on selected printer
    system "lp -d #{printer.name} #{RAILS_ROOT}/data/tickets/ticket#{self.ticket_number}.pdf"
    
  end
  
end
