class MerchandiseReception < ActiveRecord::Base
  
  belongs_to :receptor, :class_name => "Person", :foreign_key => "received_by"
  belongs_to :processor, :class_name => "Person", :foreign_key => "processed_by"
  belongs_to :supplier, :class_name => "Bussiness", :foreign_key => "supplier_id"
  
  has_many :merchandise_reception_lines
  
  validates_presence_of :supplier_id, :received_at, :received_by
  validate :code_must_be_unique_for_supplier
  
  def code_must_be_unique_for_supplier
    unless reception_note_code.blank?
      if mr = MerchandiseReception.find_by_reception_note_code(reception_note_code)
        errors.add(:reception_note_code, "no puede repetirse para el mismo proveedor.") if mr.id != id && mr.supplier_id == supplier_id
      end
    end
  end  
  
  def clear_nils
    self.discount ||= 0
    # Sumas
    self.sum18 ||= 0 
    self.sum8 ||= 0 
    self.sum4 ||= 0 
    # Descuentos
    self.disc18 ||= 0
    self.disc8 ||= 0  
    self.disc4 ||= 0 
    # Bases Imponibles
    self.bi18sum ||= 0 
    self.bi8sum ||= 0 
    self.bi4sum ||= 0  
    # Ivas
    self.vat18sum ||= 0
    self.vat8sum ||= 0
    self.vat4sum ||= 0
    # Recargos Eq.
    self.req18sum ||= 0
    self.req8sum ||= 0
    self.req4sum ||= 0
    self.save
  end
  
  def calculate
    @merchandise_reception_lines = self.merchandise_reception_lines
    self.discount ||= 0
    # Sumas
    self.sum18 = (@merchandise_reception_lines.select{|mrl| mrl.product.vat == 18 || mrl.product.vat.blank?}.collect{|mrl| mrl.quantity * mrl.unit_cost}.inject(:+) || 0)
    self.sum8 = (@merchandise_reception_lines.select{|mrl| mrl.product.vat == 8 }.collect{|mrl| mrl.quantity * mrl.unit_cost}.inject(:+) || 0)
    self.sum4 = (@merchandise_reception_lines.select{|mrl| mrl.product.vat == 4 }.collect{|mrl| mrl.quantity * mrl.unit_cost}.inject(:+) || 0)
    # Descuentos
    self.disc18 = self.discount * self.sum18/(self.sum18 + self.sum8 + self.sum4)
    self.disc8  = self.discount * self.sum8/(self.sum18 + self.sum8 + self.sum4)
    self.disc4  = self.discount * self.sum4/(self.sum18 + self.sum8 + self.sum4)
    # Bases Imponibles
    self.bi18sum = (self.sum18 - self.disc18).round(2)
    self.bi8sum = (self.sum8 - self.disc8).round(2)
    self.bi4sum = (self.sum4 - self.disc4).round(2)    
    # Ivas
    self.vat18sum = (self.bi18sum * 0.18).round(2)
    self.vat8sum  = (self.bi8sum  * 0.08).round(2)
    self.vat4sum = (self.bi4sum  * 0.04).round(2)
    # Recargos Eq.
    self.req18sum = (self.bi18sum * 0.04).round(2)
    self.req8sum = (self.bi8sum  * 0.01).round(2)
    self.req4sum = (self.bi4sum  * 0.005).round(2)
    self.save
  end
  
end
