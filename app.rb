require 'json'

module Database
  PRODUCTS = JSON.parse(File.read('./data.json'), symbolize_names: true)

  def self.find_product(id)
    data = PRODUCTS.find { |d| d[:id] == id }
    Product.new(data)
  end
end
