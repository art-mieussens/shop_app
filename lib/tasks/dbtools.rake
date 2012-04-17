namespace :dbtools do

  namespace :merchandise_reception_lines do
    desc "Migrate inventory_movements data to merchandise_reception_lines"
    task :copy_im_data => :environment do
      mrlines = MerchandiseReceptionLine.all
      mrlines.each do |mrline|
        mrline.product_id = mrline.inventory_movement.product_id
        mrline.quantity = mrline.inventory_movement.quantity
        mrline.save
      end
    end
  end
  
  namespace :inventory_movements do
    desc "Delete all inventory_movements"
    task :delete_all => :environment do
      ims = InventoryMovement.all
      ims.each do |im|
        im.destroy
      end
    end
  end
  
  namespace :sales do
    desc "Assign ticket numbers to sales"
    task :assign_ticket_number => :environment do
      sales = Sale.order(:closed_at)
      sales.each_index do |index|
        @sale = sales.fetch(index)
        @sale.ticket_number = index + 1
        @sale.save
      end
    end
  end
  
end
