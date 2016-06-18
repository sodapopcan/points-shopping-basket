require 'json'
require 'bigdecimal'

module Database
  def self.find_product(id)
    products = JSON.parse(File.read('./data.json'), symbolize_names: true)
    product = products.find { |d| d[:id] == id }
    Product.new(product)
  end
end

# OpenStruct allows accessing hash keys as methods
class Product < OpenStruct
  def price
    BigDecimal.new(super.to_s)
  end
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
    subtotal = item.subtotal
    tax = BigDecimal.new('0.0')
    tax += round(subtotal * BASIC_RATE) unless UNTAXABLE_TYPES.include?(item.type)
    tax += round(subtotal * IMPORT_RATE) if item.imported?
    tax
  end

  def round(n)
    (BigDecimal.new(n.to_s) * 20).ceil / BigDecimal.new("20.0")
  end
end

module View
  LINE_ITEM_TEMPLATE = "%i %s: $%.2f"

  def self.render(basket)
    output = []
    basket.line_items.each do |item|
      output << LINE_ITEM_TEMPLATE % [item.quantity, item.description, item.total]
    end
    output << "Sales Tax: $%.2f" % basket.tax_total
    output << "Total: $%.2f" % basket.total

    output.join("\n")
  end
end
