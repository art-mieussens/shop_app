class MerchandiseReceptionLine < ActiveRecord::Base
  
  belongs_to :merchandise_reception
  belongs_to :inventory_movement
  belongs_to :product
  
  attr_accessor :total
  attr_reader :total
  
  def total=(total) #virtual attribute
    unless unit_cost.present?
      if total.present?
        self.unit_cost = to_decimal(total).to_f / quantity.to_i
      end
    end
  end
  
private
  
  def to_decimal(string)
    string.gsub(/[.,]\d\d\d/){|s| s[1..3]}.gsub(/[,]/, '.')
  end
  
end
