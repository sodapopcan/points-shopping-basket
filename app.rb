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

class Basket
  attr_reader :line_items

  def initialize
    @line_items = []
  end

  def add_product(product)
    @line_items << LineItem.new(product)
  end

  def tax_total
    @line_items.reduce(0) { |tax, item| tax += item.tax }
  end

  def total
    @line_items.reduce(0) { |total, item| total += item.total }
  end
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

  def tax
    TaxCalculator.calculate(self)
  end

  def subtotal
    price * quantity
  end

  def total
    subtotal + tax
  end

  def imported?
    @product.imported
  end
end

module TaxCalculator
  extend self

  BASIC_RATE = 0.1
  IMPORT_RATE = 0.05

  UNTAXABLE_TYPES = %w( Food Medicine Book )

  def calculate(item)
    tax = 0
    tax += round(item.subtotal * BASIC_RATE) unless UNTAXABLE_TYPES.include?(item.type)
    tax += round(item.subtotal * IMPORT_RATE) if item.imported?
    tax
  end

  def round(n)
    (n * 20).round / 20.0
  end
end
