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

  # Instance Method to return the FarMar::Vendor instance that is associated with this FarMar::Product
  def vendor
    vendor_id = self.vendor_id
    vendor = FarMar::Vendor.find(vendor_id)
    return vendor
  end

  # Instance Method to return an array of FarMar::Sale instances associated with the product_id.
  def sales
    product_id = self.id
    all_sales = FarMar::Sale.all
    product_sales = all_sales.find_all {|p| p.product_id == product_id}
    return product_sales
  end

  # Instance Method to return the number of times this product has been sold.
  def number_of_sales
    product_sales = self.sales
    num_of_sales = product_sales.length
    return num_of_sales
  end

  # Class Method to return all of the products with the given vendor_id
  def self.by_vendor(vendor_id)
    products = self.all
    vendor_products = []
    products.each do |product|
      if product.vendor_id == vendor_id
        vendor_products << product
      end
    end
    return vendor_products
  end

end
