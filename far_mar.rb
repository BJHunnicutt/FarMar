# gems your project needs
require 'csv'
require 'awesome_print'
require 'date'
require 'chronic'
require 'benchmark'
  # puts Benchmark.measure { -code to measure in here- }

# our namespace module
module FarMar
end

# # all of our data classes that live in the module
require './lib/farmar_market'
require './lib/farmar_vendor'
require './lib/farmar_product'
require './lib/farmar_sale'



## ---- Testing FarMar::Market ---- ##
  # all_markets = FarMar::Market.all
  # ap all_markets.class
  #
  market = FarMar::Market.find(249)
  # ap market.name
  #
  # vendors = market.vendors
  # ap vendors
  # ap vendors[0].name
  # ap market.products

  # school_markets = FarMar::Market.search('school')
  # ap school_markets

  # ap market.preferred_vendor
  # pref = market.preferred_vendor(DateTime.parse("2013-11-07 08:12:16 -0800"))
  # ap "Preferred Vendor : #{pref.name}"
  # ap pref.revenue(DateTime.parse("2013-11-07 08:12:16 -0800"))
  # ap market.preferred_vendor("2013-11-10 08:12:16 -0800")

  # worst = market.worst_vendor(DateTime.parse("2013-11-07 08:12:16 -0800"))
  # ap "Worst Vendor : #{worst.name}"
  # ap worst.revenue(DateTime.parse("2013-11-07 08:12:16 -0800"))

## ---- Testing FarMar::Vendor ---- ##
  # all_vendors = FarMar::Vendor.all
  # ap all_vendors[0].id
  #
  # vendor = FarMar::Vendor.find(17)
  # ap vendor
  # ap vendor.market_id
  # market_vendors = FarMar::Vendor.by_market(2)
  # ap market_vendors
  # ap vendor.sales
  # ap vendor.revenue(DateTime.parse("2013-11-10 08:12:16 -0800"))
  # ap vendor.revenue("2013-11-10 08:12:16 -0800")

## ---- Testing FarMar::Product ---- ##

  # all_products = FarMar::Product.all
  # ap all_products[0].name
  #
  # product = FarMar::Product.find(17)
  # ap product
  # ap product.vendor_id

## ---- Testing FarMar::Sale ---- ##

  # all_sales = FarMar::Sale.all
  # ap all_sales[0].id
  # ap all_sales[0].amount
  #
  # sale = FarMar::Sale.find(17)
  # ap sale
  # ap sale.purchase_time.strftime('%c')

  # errortest = FarMar::Sale.find('432hjk')
  # ap errortest

  # sales_between = FarMar::Sale.between(DateTime.parse("2013-11-07 08:12:16 -0800"), DateTime.parse("2013-11-07 12:33:41 -0800"))
  # ap sales_between.length
