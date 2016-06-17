require 'minitest/autorun'

require_relative './app'

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
  it "knows that an item is taxable" do
    line_item = LineItem.new Database.find_product(5)
    TaxCalculator.taxable?(line_item).must_equal true
  end

  it "knows that an item is untaxable" do
    line_item = LineItem.new Database.find_product(8)
    TaxCalculator.taxable?(line_item).must_equal false
  end

  it "knows that an imported item is always taxable" do
    line_item = LineItem.new Database.find_product(6)
    TaxCalculator.taxable?(line_item).must_equal true
  end

  it "can calculated tax of a LineItem" do
    line_item = LineItem.new Database.find_product(6)
    TaxCalculator.calculate(line_item).must_equal 2.8
  end
end
