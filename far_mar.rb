# gems your project needs
require 'csv'
require 'awesome_print'
require 'date'
require 'chronic'
require 'benchmark'
  # puts Benchmark.measure { -code to measure in here- }
require_relative 'helpers'

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
  # market = FarMar::Market.find(249)
  # ap market.name
  #
  # vendors = market.vendors
  # ap vendors
  # ap vendors[0].name
  # ap market.products

  # print_memory_usage do
  #   print_time_spent do
  #     @school_markets = FarMar::Market.search('school')
  #   end
  # end
  # ap @school_markets

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

## WOW: this took 30 minutes to run... need to make faster
  # print_memory_usage do
  #   print_time_spent do
  #     @top_rev_vendors = FarMar::Vendor.most_revenue(3)
  #   end
  # end
  # ap @top_rev_vendors
  # ap first = FarMar::Vendor.find(2590).revenue
  # ap second = FarMar::Vendor.find(2575).revenue
  # ap third = FarMar::Vendor.find(2672).revenue

  # print_memory_usage do
  #   print_time_spent do
  #     @top_item_vendors = FarMar::Vendor.most_items(20)
  #   end
  # end
  #
  # ap @top_item_vendors
  # ap @top_item_vendors[0].sales.length
  # ap @top_item_vendors[1].sales.length

  # vendor = FarMar::Vendor.find(2683)
  # ap vendor.sales.length
  # vendor = FarMar::Vendor.find(1325)
  # ap vendor.sales.length

  # print_memory_usage do
  #   print_time_spent do
  #     ap FarMar::Vendor.revenue(DateTime.parse("2013-11-07 08:12:16 -0800"))
  #   end
  # end


  # print_memory_usage do
  #   print_time_spent do
  #     ap products = FarMar::Product.most_revenue(20)
  #     ap products[0].sales.length
  #     ap products[5].sales.length
  #     ap products[10].sales.length
  #
  #   end
  # end

## ----- testing /optimizing efficiency ----- ##
## STEP 1: Locate the problem
  # print_memory_usage do
  #   print_time_spent do
  #     @all_sales = FarMar::Sale.all
  #     ap "sales.all"
  #   end
  # end
  # print_memory_usage do
  #   print_time_spent do
  #     @vendor = FarMar::Vendor.find(17)
  #     ap "vendor.find"
  #   end
  # end
  # print_memory_usage do
  #   print_time_spent do
  #     @vendor.revenue
  #     ap "vendor.revenue"
  #   end
  # end
  # print_memory_usage do
  #   print_time_spent do
  #     @all_sales[0].amount
  #     ap "sale.amount"
  #   end
  # end
  #
  # @vendor_set = []
  # 5.times {@vendor_set << @vendor}
  #
  # print_memory_usage do
  #   print_time_spent do
  #     all_revenues = {}
  #     ap "vendor.revenue LOOP twice"
  #     @vendor_set.each do |vendor|
  #       all_revenues[vendor] = vendor.revenue
  #       print "."
  #     end
  #   end
  # end

  # *** sales.all is definitely the problem. ***

  ## STEP 2: Fix the problem
  # print_memory_usage do
  #   print_time_spent do
  #     all_sales = FarMar::Sale.all_PRE_optimized
  #     puts
  #     ap "sales.all_PRE_optimized"
  #     ap all_sales.length
  #     puts "first sale amount: #{all_sales[0].amount}"
  #   end
  # end
  #
  # print_memory_usage do
  #   print_time_spent do
  #     all_sales = FarMar::Sale.all #_optimized
  #     puts
  #     ap "sales.all   #_optimized"
  #     ap all_sales.length
  #     puts "first sale amount: #{all_sales[0].amount}"
  #   end
  # end

  # print_memory_usage do
  #   print_time_spent do
  #     all_sales = FarMar::Sale.all_optimized_memory
  #     puts
  #     ap "sales.all_optimized_memory"
  #     ap all_sales.length
  #     puts "first sale amount: #{all_sales[0].amount}"
  #   end
  # end
  #
  #
  # print_memory_usage do
  #   print_time_spent do
  #     all_sales = FarMar::Sale.all_optimized_noHashRead
  #     puts
  #     ap "sales.all_optimized_noHashRead"
  #     ap all_sales.length
  #     puts "first sale amount: #{all_sales[0].amount}"
  #   end
  # end
  # puts

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
