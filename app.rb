require 'json'

module Database
  PRODUCTS = JSON.parse(File.read('./data.json'), symbolize_names: true)

  def self.find_product(id)
    data = PRODUCTS.find { |d| d[:id] == id }
    Product.new(data)
  end
end

# OpenStruct allows accessing hash keys as methods
class Product < OpenStruct
end

class LineItem
  attr_reader :product, :description, :type, :price, :quantity

  def initialize(product, quantity = 1)
    @product = product
    @description = product.description
    @price = product.price
    @type = product.type
    @quantity = quantity
  end

  def imported?
    @product.imported
  end
end

module TaxCalculator
  extend self

  def taxable?(item)
    return true if item.imported?
    !UNTAXABLE_TYPES.include?(item.type)
  end
end
