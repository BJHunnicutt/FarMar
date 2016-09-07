#FarMar_spec.rb

require_relative 'Spec_helper'
require_relative '../far_mar'

describe 'Testing FarMar' do

##########-------------- Testing FarMar::Market ----------------##########

  it "Must return an array of all the Markets when .all is called" do
    expect(FarMar::Market.all).must_be_instance_of(Array)
  end

  it "Must find a Market object when given an id and return the name with .name" do
    market = FarMar::Market.find(249)
    expect(market).must_be_instance_of(FarMar::Market)
    expect(market.name).must_equal("Swain County Tailgate Market")
  end

  it "Must return an array of Vendor objects that go to a given market" do
    market = FarMar::Market.find(249)
    expect(market.vendors).must_be_instance_of(Array)
    expect(market.vendors[0].name).must_equal("Gutmann, Toy and Ziemann")
  end

  it "Must return a notice if asked to find an invalid ID" do
     FarMar::Market.find("780dsa890").must_equal("There are no markets with that ID")
  end


##########-------------- Testing FarMar::Vendor ----------------##########

  it "Must return an array of objects of all vendors" do
    all_vendors = FarMar::Vendor.all
    all_vendors.must_be_instance_of(Array)
    all_vendors[0].id.must_equal(1)
  end

  it "Must find a Vendor object when given an id" do
    vendor = FarMar::Vendor.find(17)
    vendor.must_be_instance_of(FarMar::Vendor)
    vendor.market_id.must_equal(5)
  end

  it "Must return a notice if asked to find an invalid ID" do
     FarMar::Vendor.find("780dsa890").must_equal("There are no vendors with that ID")
  end


##########-------------- Testing FarMar::Product ----------------##########

  it "Must return an array of objects of all products" do
    all_products = FarMar::Product.all
    all_products.must_be_instance_of(Array)
    all_products[0].name.must_equal("Dry Beets")
  end

  it "Must find a Product object when given an id" do
    product = FarMar::Product.find(17)
    product.must_be_instance_of(FarMar::Product)
    product.id.must_equal(17)
    product.vendor_id.must_equal(8)
  end

  it "Must return a notice if asked to find an invalid ID" do
     FarMar::Product.find("780dsa890").must_equal("There are no products with that ID")
  end


##########-------------- Testing FarMar::Sale ----------------##########

  it "Must return an array of objects of all sales" do
    all_sales = FarMar::Sale.all
    all_sales.must_be_instance_of(Array)
    all_sales[0].id.must_equal(1)
    all_sales[0].amount.must_equal(9290)
  end

  it "Must find a Sale object when given an id" do
    sale = FarMar::Sale.find(17)
    sale.must_be_instance_of(FarMar::Sale)
    sale.purchase_time.must_be_instance_of(DateTime)
    sale.purchase_time.strftime('%c').must_equal("Sun Nov 10 04:16:12 2013")
  end

  it "Must return a notice if asked to find an invalid ID" do
    FarMar::Sale.find("780dsa890").must_equal("There are no sales with that ID")
  end



##########-------------- Testing FarMar::Product ----------------##########

  # it "Must " do
  # end
  #
  # it "Must " do
  # end


##########-------------- Testing FarMar::Product ----------------##########

  # it "Must " do
  # end
  #
  # it "Must " do
  # end

 end
