def fill_basket(basket, product_ids)
  product_ids.each do |id|
    basket.add_product Database.find_product(id)
  end
end

