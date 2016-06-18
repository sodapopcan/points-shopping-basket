require 'minitest/autorun'

require_relative './app'
require_relative './helpers'

describe Database do
  it "can find a product" do
    product = Database.find_product(1)
    product.description.must_equal 'Book'
    product.price.must_equal 12.49
  end
end

describe LineItem do
  product = Database.find_product(4)
  line_item = LineItem.new product, 2
  it "takes a product and quantity" do
    line_item.product.must_equal product
    line_item.quantity.must_equal 2
    line_item.price.must_equal 10
  end

  it "calculates the subtotal (no tax)" do
    line_item.subtotal.must_equal 20.0
  end

  it "knows if it's imported or not" do
    line_item.imported?.must_equal true
  end
end

describe TaxCalculator do
  it "can calculated tax of a LineItem" do
    line_item = LineItem.new Database.find_product(6)
    TaxCalculator.calculate(line_item).must_equal 1.4
  end

  it "rounds to the nearest 0.05" do
    TaxCalculator.round(1.421).must_equal BigDecimal.new('1.45')
    TaxCalculator.round(1.45).must_equal BigDecimal.new('1.45')
    TaxCalculator.round(1.46).must_equal BigDecimal.new('1.5')
  end
end

describe Basket do
  # These run the exercise expectations
  it "has the right totals for the first output" do
    basket = Basket.new
    fill_basket(basket, [1,2,3])
    basket.line_items[0].total.must_equal BigDecimal.new('12.49')
    basket.line_items[1].total.must_equal BigDecimal.new('16.49')
    basket.line_items[2].total.must_equal BigDecimal.new('0.85')
    basket.tax_total.must_equal BigDecimal.new('1.5')
    basket.total.must_equal BigDecimal.new('29.83')
  end

  it "has the right totals for the second output" do
    basket = Basket.new
    fill_basket(basket, [4,5])
    basket.line_items[0].total.must_equal BigDecimal.new('10.5')
    basket.line_items[1].total.must_equal BigDecimal.new('54.65')
    basket.tax_total.must_equal BigDecimal.new('7.65')
    basket.total.must_equal BigDecimal.new('65.15')
  end

  it "has the right totals for the third output" do
    basket = Basket.new
    fill_basket(basket, [6,7,8,9])
    basket.line_items[0].total.must_equal BigDecimal.new('32.19')
    basket.line_items[1].total.must_equal BigDecimal.new('20.89')
    basket.line_items[2].total.must_equal BigDecimal.new('9.75')
    basket.line_items[3].total.must_equal BigDecimal.new('11.85')
    basket.tax_total.must_equal BigDecimal.new('6.70')
    basket.total.must_equal BigDecimal.new('74.68')
  end
end
