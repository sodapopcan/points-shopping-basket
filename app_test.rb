require 'minitest/autorun'

require_relative './app'

describe Database do
  it "can find a product" do
    product = Database.find_product(1)
    product.description.must_equal 'Book'
    product.price.must_equal 12.49
  end
end
