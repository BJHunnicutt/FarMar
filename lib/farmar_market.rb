# lib/farmar_market.rb
# require_relative '../far_mar'

class FarMar::Market
  ## Initialize a new instance of an object
  attr_reader :id, :name, :address, :city, :county, :state, :zip
  def initialize(market_hash)
    @id = market_hash[:id]
    @name = market_hash[:name]
    @address = market_hash[:address]
    @city = market_hash[:city]
    @county = market_hash[:county]
    @state = market_hash[:state]
    @zip = market_hash[:zip]
  end

  ## Class Method to return a collection of instances for all objects described in the CSV
  def self.all
    # Initialize an array that will hold objects
    markets = []
    # Go through each line of the csv, create an object, and add it to the array
    CSV.foreach("support/markets.csv", "r") do |line|
      market = {id: line[0].to_i, name: line[1], address: line[2], city: line[3], county: line[4], state: line[5], zip: line[6]}
      markets << self.new(market)
    end

    return markets

  end

  ## Class Method to return an object instance for the given ID
  def self.find(id)
    markets = self.all
    markets.each do |market|
      if market.id == id
        return market
      end
    end
    return "There are no markets with that ID"
  end

  ## Instance Method to find all the vendors at a given FarMar::Market
  def vendors
    vendors_at_market = []
    vendors = FarMar::Vendor.all
    vendors.each do |vendor|
      if vendor.market_id == self.id # Since this is an instance method I am looking at the ID of the FarMar::Market object I am calling .vendors on (i.e. the "self")
        vendors_at_market << vendor
      end
    end
  return vendors_at_market
  end

  #Instance Method returns an array of FarMar::Product instances that are associated to the market through the FarMar::Vendor class.
  def products
    vendors_at_market =  self.vendors
    products_at_market = []
    vendors_at_market.each do |vendor|
      products_at_market << vendor.products
    end
    return products_at_market.flatten
  end

  # Class Method to return a collection of FarMar::Market instances where the market name or vendor name contain the search_term.
    # EX: FarMar::Market.search('school') would return 3 results, one being the market with id 75 (Fox School Farmers FarMar::Market).
  # def self.search(search_term)
  #   search_results = []
  #   markets = self.all
  #   markets.each do |market|
  #     if market.name.include?(search_term) || market.name.include?(search_term)
  #       search_results << market
  #     end
  #   end
  #
  #   return search_results
  # end


end
