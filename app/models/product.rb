#coding: utf-8

class Product < ActiveRecord::Base
  
  belongs_to :product_category
  belongs_to :supplier, :class_name => "Bussiness"
  has_many :inventory_movements
  has_many :merchandise_reception_lines
  has_many :inventory_balances
  has_one :product_transformation
  has_many :product_transformation_lines
  has_many :sale_lines
  
  validates_presence_of :product_category, :supplier, :description, :code
  validates_uniqueness_of :bar_code, :allow_blank => true
  validate :code_must_be_unique_for_supplier
  
  attr_accessor :unit_cost
  attr_accessor :quantity
  attr_accessor :sell_price
  attr_accessor :get_price
  
  def code_must_be_unique_for_supplier
    if p = Product.find_by_code(code)
      errors.add(:code, "no puede repetirse para el mismo proveedor.") if p.id != id && p.supplier_id == supplier_id
    end
  end
  
  def unit_cost(*time)
    @inventory_balances = InventoryBalance.where(:product_id => self.id)                  #get all balances for this product
    @inventory_balances.where("created_at <= ?", time) if time                            #if a time is given, select only those before
    if @last_inventory_balance = inventory_balances.last                                   #if the last inventory balance exists
      @uc = @last_inventory_balance.unit_cost                                                 #take cost from las balance 
      @q = @last_inventory_balance.quantity                                                   #take quantity from last balance
      @recent_inventory_movements = InventoryMovement.where(:product_id => self.id).where(
        "created_at >= ?", @last_inventory_balance.inventory.created_at)                      #get movements since last balance
    else                                                                                    #if not
      @uc = 0                                                                                 #initialize cost
      @q = 0                                                                                  #initialize quantity
      @recent_inventory_movements = InventoryMovement.where(:product_id => self.id)           #get all movements for this product
    end
    if @recent_inventory_movements.present?                                                 #if there are any movements to consider
      @recent_inventory_movements.each do |im|                                                #for every movement
        if im.quantity > 0                                                                      #if it's an addition to inventory
          if im.quantity != @q                                                                    #if resulting product quantity is different from zero
            @uc = ((@uc * @q + im.unit_cost * im.quantity)/(@q + im.quantity)).round(2)             #calculate weighted average cost
          else                                                                                    #if not
            @uc = im.unit_cost                                                                      #set cost to that of this movement
          end
        end                                                                                     #if not an addition do not alter cost
        @q += im.quantity                                                                       #alter quantity
      end
    end
    @uc                                                                                     #return the unit cost
  end
              
  def quantity
    @recent_inventory_movements = InventoryMovement.where(:product_id => self.id)
    if @last_inventory_balance = InventoryBalance.where(:product_id => self.id).last
      @recent_inventory_movements.where("created_at >= ?", @last_inventory_balance.inventory.created_at)
      @q = @last_inventory_balance.quantity
    else
      @q = 0
    end
    unless @recent_inventory_movements.blank?
      @q += @recent_inventory_movements.collect{|im| im.quantity}.inject(:+)
    end
    @q
  end
  
  def sell_price
    if self.for_sale
      if self.price.present?
        self.price
      else
        coins_round_up(self.unit_cost * 2.78, 0.05)
      end
    else
      nil
    end
  end
  
  def coins_round_up(number, factor)
    (number/factor).ceil*factor
  end
  
  def search(string)
    Product.where({:bar_code.matches => "%#{string}%"} | {:code.matches => "%#{string}%"} | {:description.matches => "%#{string}%"})
  end
  
  def self.find_by_code_or_bar_code(string)
    self.find_by_bar_code(string) || self.find_by_code(string)
  end
  
  def get_price(rate)
    if rate.description == "Estándar"
      self.sell_price
    else
      self.sell_price * rate.expression.to_f
    end
  end
  
end
