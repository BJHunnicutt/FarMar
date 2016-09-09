#FarMar_spec.rb

require_relative 'Spec_helper'
require_relative '../far_mar'

describe 'Testing FarMar' do

##########-------------- Testing FarMar::Market ----------------##########
  let(:market) { FarMar::Market.find(249) }

  it "Must return an array of all the Markets when .all is called" do
    expect(FarMar::Market.all).must_be_instance_of(Array)
  end

  it "Must find a Market object when given an id and return the name with .name" do
    # market = FarMar::Market.find(249)
    expect(market).must_be_instance_of(FarMar::Market)
    expect(market.name).must_equal("Swain County Tailgate Market")
  end

  it "Must return an array of Vendor objects that go to a given market" do
    # market = FarMar::Market.find(249)
    expect(market.vendors).must_be_instance_of(Array)
    expect(market.vendors[0].name).must_equal("Gutmann, Toy and Ziemann")
  end

  it "Must return a notice if asked to find an invalid ID" do
     FarMar::Market.find("780dsa890").must_equal("There are no markets with that ID")
  end

              ## Optional Enhancements ##

  it "Must returns an array of FarMar::Product instances sold by vendors at the market" do
    market.products.must_be_instance_of(Array)
    market.products[0].must_be_instance_of(FarMar::Product)
  end

  it "Must return a collection of FarMar::Market instances where the market name or vendor name contain the search_term" do
    school_markets = FarMar::Market.search('hills')
    school_markets.must_be_instance_of(Array)
    school_markets[0].name.must_equal("Scottdale Farmers Market")

    # Test search more thoroughly
    search_worked = false
    if school_markets[0].name.downcase.include?('hills')
      search_worked = true
    else
      school_markets[0].vendors.each do |vendor|
        if vendor.name.downcase.include?('hills')
          search_worked = true
        end
      end
    end
    search_worked.must_equal(true)

  end

  it "Must return the vendor with the highest revenue at that market, with the option of a specific day" do
    market.preferred_vendor.must_be_instance_of(FarMar::Vendor)
    market.preferred_vendor.name.must_equal("Gutmann, Toy and Ziemann")

    # This is a different vendor than market.preferred_vendor without a date (above) returns
    market.preferred_vendor(DateTime.parse("2013-11-07 08:12:16 -0800")).name.must_equal("Satterfield and Sons")

    # Return nil if there's no vendors with revenue
    market.preferred_vendor(DateTime.parse("2016-11-07 08:12:16 -0800")).must_equal(nil)

    # Making sure the input is DateTime if given
    err = ->{market.preferred_vendor("2013-11-10 08:12:16 -0800")}.must_raise(ArgumentError)

    err.message.must_match(/To search only a specific day, a DateTime input is required/)
  end

  it "Must return the vendor with the lowest revenue (on a date if given)" do
    market.worst_vendor.name.must_equal("Satterfield and Sons")
    market.worst_vendor(DateTime.parse("2013-11-07 08:12:16 -0800")).name.must_equal("Gutmann, Toy and Ziemann")

    # Making sure the input is DateTime if given
    err = ->{market.worst_vendor("2013-11-10 08:12:16 -0800")}.must_raise(ArgumentError)

    err.message.must_match(/To search only a specific day, a DateTime input is required/)

  end


##########-------------- Testing FarMar::Vendor ----------------##########
  let(:vendor) { FarMar::Vendor.find(17) }

  it "Must return an array of objects of all vendors" do
    all_vendors = FarMar::Vendor.all
    all_vendors.must_be_instance_of(Array)
    all_vendors[0].id.must_equal(1)
  end

  it "Must find a Vendor object when given an id" do
    # vendor = FarMar::Vendor.find(17)
    vendor.must_be_instance_of(FarMar::Vendor)
    vendor.market_id.must_equal(5)
  end

  it "Must return a notice if asked to find an invalid ID" do
     FarMar::Vendor.find("780dsa890").must_equal("There are no vendors with that ID")
  end

  it "Must return the Market instance from the market_id of this vendor" do
    vendor.market.must_be_instance_of(FarMar::Market)
    vendor.market.id.must_equal(5)
  end

  it "Must return an array of FarMar::Product objects that are associated by the FarMar::Product vendor_id field" do
    vendor.products.must_be_instance_of(Array)
    vendor.products[0].must_be_instance_of(FarMar::Product)
  end

  it "Must return an array of FarMar::Sale objects that are associated by the FarMar::Product vendor_id field" do
    vendor.sales.must_be_instance_of(Array)
    vendor.sales[0].must_be_instance_of(FarMar::Sale)
    ap vendor.sales[0].id.must_equal(88)
  end

  it "Must return the the sum of all of the vendor's sales (in cents)" do
    vendor.revenue.must_be_instance_of(Fixnum)
    vendor.revenue.must_equal(24883)
  end

  it "Must return all of the vendors associated with given market_id" do
    market_vendors = FarMar::Vendor.by_market(2)
    market_vendors.must_be_instance_of(Array)
    market_vendors[0].must_be_instance_of(FarMar::Vendor)
    market_vendors[0].market_id.must_equal(2)
  end

            ## Optional Enhancements ##

  it "Must only return the revenue for a given day if a DateTime argument is passed to .revenue" do
    vendor.revenue(DateTime.parse("2013-11-10 08:12:16 -0800")).must_be_instance_of(Fixnum)
    vendor.revenue(DateTime.parse("2013-11-10 08:12:16 -0800")).must_equal(7803)

    vendor.revenue(DateTime.parse("2016-11-10")).must_be_instance_of(Fixnum)
    vendor.revenue(DateTime.parse("2016-11-10")).must_equal(0)

    # Making sure the input is DateTime if given
    err = ->{vendor.revenue("2013-11-10 08:12:16 -0800")}.must_raise(ArgumentError)
    err.message.must_match(/To search only a specific day, a DateTime input is required/)
  end

  # NOTE: these tests TAKE 2.5 MINUTES (each) to run, so i'm commenting them unless I want it specifically
  # it "Must return the top n vendor instances ranked by total revenue" do
  #   top_vendors = FarMar::Vendor.most_revenue(3)
  #   top_vendors.length.must_equal(3)
  #   top_vendors[0].id.must_equal(2590)
  # end
  #
  # it "Must return the top n vendor instances ranked by total revenue" do
  #   top_vendors = FarMar::Vendor.most_items(3)
  #   top_vendors.length.must_equal(3)
  #   top_vendors[0].id.must_equal(2683)
  # end
  #
  # it "Must return the total revenue for that date across all vendors" do
  #   total_revenue = FarMar::Vendor.revenue(DateTime.parse("2013-11-07 08:12:16 -0800"))
  #   total_revenue.must_be_instance_of(Fixnum)
  #   total_revenue.must_equal(9060582)
  #
  #   # Making sure the input is DateTime if given
  #   err = ->{FarMar::Vendor.revenue("2013-11-10 08:12:16 -0800")}.must_raise(ArgumentError)
  #   err.message.must_match(/To search only a specific day, a DateTime input is required/)
  # end
  #
  # ## This one takes 8 minutes...
  # it "Must return the top n vendor instances ranked by total revenue" do
  #   top_products = FarMar::Product.most_revenue(20)
  #   top_products.length.must_equal(20)
  #   top_products[0].id.must_equal(7848)
  # end

##########-------------- Testing FarMar::Product ----------------##########
  let(:product) { FarMar::Product.find(17) }

  it "Must return an array of objects of all products" do
    all_products = FarMar::Product.all
    all_products.must_be_instance_of(Array)
    all_products[0].name.must_equal("Dry Beets")
  end

  it "Must find a Product object when given an id" do
    # product = FarMar::Product.find(17)
    product.must_be_instance_of(FarMar::Product)
    product.id.must_equal(17)
    product.vendor_id.must_equal(8)
  end

  it "Must return a notice if asked to find an invalid ID" do
     FarMar::Product.find("780dsa890").must_equal("There are no products with that ID")
  end

  it "Must return the FarMar::Vendor instance that is associated with this FarMar::Product" do
    product.vendor.must_be_instance_of(FarMar::Vendor)
    product.vendor.id.must_equal(8)
  end

  it "Must return an array of FarMar::Sale instances associated with the product_id" do
    product.sales.must_be_instance_of(Array)
    product.sales[0].must_be_instance_of(FarMar::Sale)
  end

  it "Must return the number of times this product has been sold" do
    product.number_of_sales.must_be_instance_of(Fixnum)
    product.number_of_sales.must_equal(4)
  end

  it "Must return all of the products with the given vendor_id" do
    vendor_products = FarMar::Product.by_vendor(2)
    vendor_products.must_be_instance_of(Array)
    vendor_products[0].must_be_instance_of(FarMar::Product)
    vendor_products[0].vendor_id.must_equal(2)
  end

                ## Optional Enhancements ##


##########-------------- Testing FarMar::Sale ----------------##########
  let(:sale) { FarMar::Sale.find(17) }
  it "Must return an array of objects of all sales" do
    all_sales = FarMar::Sale.all
    all_sales.must_be_instance_of(Array)
    all_sales[0].id.must_equal(1)
    all_sales[0].amount.must_equal(9290)
  end

  it "Must find a Sale object when given an id" do
    # sale = FarMar::Sale.find(17)
    sale.must_be_instance_of(FarMar::Sale)
    sale.purchase_time.must_be_instance_of(String)
    DateTime.parse(sale.purchase_time).strftime('%c').must_equal("Sun Nov 10 04:16:12 2013")
  end

  it "Must return a notice if asked to find an invalid ID" do
    FarMar::Sale.find("780dsa890").must_equal("There are no sales with that ID")
  end

  it "Must return the FarMar::Vendor instance that is associated with this sale" do
    sale.vendor.must_be_instance_of(FarMar::Vendor)
    sale.vendor.id.must_equal(sale.vendor_id)
  end

  it "Must return the FarMar::Vendor instance that is associated with this sale" do
    sale.product.must_be_instance_of(FarMar::Product)
    sale.product.id.must_equal(sale.product_id)
  end

  it "Must return an array of FarMar::Sale objects where the purchase time is between the two times given as arguments" do
    sales_between = FarMar::Sale.between(DateTime.parse("2013-11-07 08:12:16 -0800"), DateTime.parse("2013-11-07 12:33:41 -0800"))
    sales_between.must_be_instance_of(Array)
    sales_between[0].must_be_instance_of(FarMar::Sale)
    sales_between.length.must_equal(323)
  end

              ## Optional Enhancements ##


##########-------------- Testing FarMar::Product ----------------##########

  # it "Must " do
  # end
  #
  # it "Must " do
  # end

 end
