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
  #  *For a given date if a DateTime argument is passed
  def revenue(date = nil)
    total_sales = 0
    vendor_sales = self.sales
    if date.class == DateTime || date.class == Date # Because the Date and DateTime work fine together for what I'm doing
      vendor_sales.each do |sale|
        sale_purchase_time = DateTime.strptime(sale.purchase_time, '%Y-%m-%d %H:%M:%S %z')
        # Google tells me that === will tell you if 2 DateTime objects are on the same day...
        if sale_purchase_time === date
          total_sales += sale.amount
        end
      end
    elsif date == nil
      vendor_sales.each {|sale| total_sales += sale.amount}
    else
      raise ArgumentError.new("To search only a specific day, a DateTime input is required")
    end

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


  # Class Method to return the top n vendor instances ranked by total revenue
  ### ****  This initially took 27 minutes to run!
  ###       I spent 4 hours trying to figure out how to speed it up...
  ###         *Main culprits:
  ###           (1) Converting to the sale purchase time DateTime in Sale.self.all, only doing it later --> 2X faster
  ###               * DateTime.strptime(sale.purchase_time, '%Y-%m-%d %H:%M:%S %z') is ~2x faster than DateTime.parse(sale.purchase_time) (0.5s -> 0.3s)
  ###           (2) Reading in the CSV with CSV.foreach * IO.foreach (then line.split(",")) --> 3x faster

  def self.most_revenue(n)
    all_vendors = FarMar::Vendor.all
    all_revenues = {}
    top_vendors_by_revenue = []
    # "collecting revenues"
    all_vendors.each do |vendor|
      all_revenues[vendor] = vendor.revenue
      print "👾 "
    end
    # "sorting"
    ordered_revenues = all_revenues.sort_by{|k,v| v}  # Hash[hash.sort_by{|k,v| v}] would return a hash, but I want it ordered, so an array is better
    # "reversing the list"
    ordered_revenues = ordered_revenues.reverse # was arranged low-high
    # "getting top values"
    (0...n).each {|i| top_vendors_by_revenue << ordered_revenues[i][0]}
    return top_vendors_by_revenue
  end

  # Class Method to return the top n vendor instances ranked by total number of items sold
  def self.most_items(n)
    all_vendors = FarMar::Vendor.all
    all_item_numbers = {}
    top_vendors_by_item_numbers = []
    # "collecting revenues"
    all_vendors.each do |vendor|
      all_item_numbers[vendor] = vendor.sales.length
      print "🐷 "
    end
    # "sorting"
    ordered_item_numbers = all_item_numbers.sort_by{|k,v| v}  # Hash[hash.sort_by{|k,v| v}] would return a hash, but I want it ordered, so an array is better
    # "reversing the list"
    ordered_item_numbers = ordered_item_numbers.reverse # was arranged low-high
    # "getting top values"
    (0...n).each {|i| top_vendors_by_item_numbers << ordered_item_numbers[i][0]}
    return top_vendors_by_item_numbers
  end

  # Class Method to return the total revenue for that date across all vendors
  def self.revenue(date)
    all_vendors = FarMar::Vendor.all
    total_revenue = 0

    if date.class == DateTime || date.class == Date || date.class == nil # Because the Date and DateTime work fine together for what I'm doing
      all_vendors.each do |vendor|
        total_revenue += vendor.revenue(date)
        print "🐓 "
      end
    else
      raise ArgumentError.new("To search only a specific day, a DateTime input is required")
    end

    return total_revenue
  end


end
