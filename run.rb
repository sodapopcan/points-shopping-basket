require_relative './app'
require_relative './helpers'

basket = Basket.new
fill_basket(basket, [1,2,3])
puts View.render(basket)
puts ''

basket = Basket.new
fill_basket(basket, [4,5])
puts View.render(basket)
puts ''

basket = Basket.new
fill_basket(basket, [6,7,8,9])
puts View.render(basket)
