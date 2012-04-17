namespace :product do

  desc "Set all the prices to their current value"
  task :make_all_prices_fixed => :environment do
    Product.all.each do |p|
      if p.for_sale
	if p.price.blank?
          p.update_attribute(:price, p.sell_price)
	end
      end
    end
  end
  
end
