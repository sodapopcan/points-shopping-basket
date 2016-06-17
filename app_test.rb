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
  it "takes a product and knows its tax" do
    line_item = LineItem.new Database.find_product(6)
    line_item.tax.must_equal 2.8
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
end
