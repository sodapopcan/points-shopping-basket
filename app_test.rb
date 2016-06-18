require 'minitest/autorun'

require_relative './app'
require_relative './helpers'

# Fixture data
taxable_product = {
  id: 1,
  description: 'Perfume',
  type: 'Beauty',
  price: 12.49,
  imported: false
}

untaxable_product = {
  id: 2,
  description: 'Book',
  type: 'Book',
  price: 8.95,
  imported: false
}

imported_product = {
  id: 3,
  description: 'Box of chocolates',
  type: 'Food',
  price: 24.95,
  imported: true
}

describe Database do
  it "can find a product" do
    product = Product.new(taxable_product)
    product.description.must_equal 'Perfume'
    product.type.must_equal 'Beauty'
    product.price.must_equal BigDecimal.new('12.49')
  end
end

describe LineItem do
  product = Product.new(imported_product)
  line_item = LineItem.new product, 2
  it "takes a product and quantity" do
    line_item.product.must_equal product
    line_item.quantity.must_equal 2
    line_item.price.must_equal BigDecimal.new('24.95')
  end

  it "calculates the subtotal (no tax)" do
    line_item.subtotal.must_equal BigDecimal.new('49.9')
  end

  it "knows if it's imported or not" do
    line_item.imported?.must_equal true
  end
end

describe TaxCalculator do
  it "can calculated tax of a LineItem" do
    line_item = LineItem.new Product.new(taxable_product)
    TaxCalculator.calculate(line_item).must_equal BigDecimal.new('1.25')
  end

  it "rounds to the nearest 0.05" do
    TaxCalculator.send(:round, 1.421).must_equal BigDecimal.new('1.45')
    TaxCalculator.send(:round, 1.45).must_equal BigDecimal.new('1.45')
    TaxCalculator.send(:round, 1.46).must_equal BigDecimal.new('1.5')
  end
end

describe Basket do
  it "should add a product with a quantity" do
    basket = Basket.new
    basket.add_product(Product.new(taxable_product), 2)
    basket.line_items.count.must_equal 1
    basket.line_items.first.quantity.must_equal 2
  end

  it "can add multiple products" do
    basket = Basket.new
    basket.add_product Product.new(taxable_product)
    basket.add_product Product.new(untaxable_product)
    basket.add_product Product.new(imported_product)
    basket.line_items.count.must_equal 3
  end

  it "calculates the totals" do
    basket = Basket.new
    basket.add_product Product.new(taxable_product)
    basket.add_product Product.new(untaxable_product)
    basket.add_product Product.new(imported_product)
    basket.tax_total.must_equal BigDecimal.new('2.5')
    basket.total.must_equal BigDecimal.new('48.89')
  end


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
