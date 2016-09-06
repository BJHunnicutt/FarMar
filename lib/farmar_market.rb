# lib/farmar_market.rb
require_relative '../far_mar'

class FarMar::Market
  attr_reader :market
  def initialize
    @market = []
  end

end
