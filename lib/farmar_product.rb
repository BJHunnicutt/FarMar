# lib/farmar_product.rb
# require_relative '../far_mar'

class FarMar::Product
  ## Initialize a new instance of an object
  attr_reader :id, :name, :vendor_id
  def initialize(product_hash)
    @id = product_hash[:id]
    @name = product_hash[:name]
    @vendor_id = product_hash[:vendor_id]
  end

  ## Class Method to return a collection of instances for all objects described in the CSV
  def self.all
    # Initialize an array that will hold objects
    products = []
    # Go through each line of the csv, create an object, and add it to the array
    CSV.foreach("support/products.csv", "r") do |line|
      product = {id: line[0].to_i, name: line[1], vendor_id: line[2].to_i}
      products << self.new(product)
    end

    return products

  end

  ## Class Method to return an object instance for the given ID
  def self.find(id)
    products = self.all
    products.each do |product|
      if product.id == id
        return product
      end
    end
    return "There are no products with that ID"
  end
end
