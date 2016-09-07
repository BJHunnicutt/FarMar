# lib/farmar_sale.rb
# require_relative '../far_mar'

class FarMar::Sale
  ## Initialize a new instance of an object
  attr_reader :id, :amount, :purchase_time, :vendor_id, :product_id
  def initialize(sale_hash)
    @id = sale_hash[:id]
    @amount = sale_hash[:amount]
    @purchase_time = sale_hash[:purchase_time]
    @vendor_id = sale_hash[:vendor_id]
    @product_id = sale_hash[:product_id]
  end

  ## Class Method to return a collection of instances for all objects described in the CSV
  def self.all
    # Initialize an array that will hold objects
    sales = []
    # Go through each line of the csv, create an object, and add it to the array
    CSV.foreach("support/sales.csv", "r") do |line|
      sale = {id: line[0].to_i, amount: line[1].to_i, purchase_time: DateTime.parse(line[2]), vendor_id: line[3].to_i, product_id: line[4].to_i}
      sales << self.new(sale)
    end

    return sales

  end

  ## Class Method to return an object instance for the given ID
  def self.find(id)
    sales = self.all
    sales.each do |sale|
      if sale.id == id
        return sale
      end
    end
    return "There are no sales with that ID"
  end

  # Instance Method to return the FarMar::Vendor instance that is associated with this sale
  def vendor
    vendor_id = self.vendor_id
    vendor = FarMar::Vendor.find(vendor_id)
    return vendor
  end

  # Instance Method to return the FarMar::Product instance associated with this sale
  def product
    product_id = self.product_id
    product = FarMar::Product.find(product_id)
    return product
  end

  # Class Method to return an array of FarMar::Sale objects where the purchase time is between the two times given as arguments
  def self.between(beginning_time, end_time)
    sales = self.all
    sales_between = []
    sales.each do |sale|
      if sale.purchase_time >= beginning_time && sale.purchase_time <= end_time
        sales_between << sale
      end
    end
    return sales_between
  end

end
