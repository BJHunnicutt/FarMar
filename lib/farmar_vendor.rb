# lib/farmar_vendor.rb
# require_relative '../far_mar'

class FarMar::Vendor
  ## Initialize a new instance of an object
  attr_reader :id, :name, :no_of_employees, :market_id
  def initialize(vendor_hash)
    @id = vendor_hash[:id]
    @name = vendor_hash[:name]
    @no_of_employees = vendor_hash[:no_of_employees]
    @market_id = vendor_hash[:market_id]
  end

  ## Class Method to return a collection of instances for all objects described in the CSV
  def self.all
    # Initialize an array that will hold objects
    vendors = []
    # Go through each line of the csv, create an object, and add it to the array
    CSV.foreach("support/vendors.csv", "r") do |line|
      vendor = {id: line[0].to_i, name: line[1], no_of_employees: line[2].to_i, market_id: line[3].to_i}
      vendors << self.new(vendor)
    end

    return vendors

  end

  ## Class Method to return an object instance for the given ID
  def self.find(id)
    vendors = self.all
    vendors.each do |vendor|
      if vendor.id == id
        return vendor
      end
    end
    return "There are no vendors with that ID"
  end

  # Instance Method to return the Market instance from the market_id of this vendor
  def market
    market_id = self.market_id
    market = FarMar::Market.find(market_id)
    return market
  end

  # Instance Method to return an array of FarMar::Product objects that are associated by the FarMar::Product vendor_id field.
  def products
    vendor_id = self.id
    all_products = FarMar::Product.all
    vendor_products = all_products.find_all {|p| p.vendor_id == vendor_id}
    return vendor_products
  end

  # Instance Method to return a collection of FarMar::Sale instances that are associated by the vendor_id field.
  def sales
    vendor_id = self.id
    all_sales = FarMar::Sale.all
    vendor_sales = all_sales.find_all {|s| s.vendor_id == vendor_id}
    return vendor_sales
  end

  # Instance Method to return the the sum of all of the vendor's sales (in cents)
  def revenue
    vendor_sales = self.sales
    total_sales = 0
    vendor_sales.each {|sale| total_sales += sale.amount}
    return total_sales
  end

  # Class Method to return all of the vendors associated with the given market_id
  def self.by_market(market_id)
    vendors = self.all
    market_vendors = []
    vendors.each do |vendor|
      if vendor.market_id == market_id
        market_vendors << vendor
      end
    end
    return market_vendors
  end

end
