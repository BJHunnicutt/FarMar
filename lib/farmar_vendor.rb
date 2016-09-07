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
end
