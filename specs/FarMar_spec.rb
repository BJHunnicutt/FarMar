#FarMar_spec.rb

require_relative 'Spec_helper'
# require_relative '../far_mar'
require_relative '../lib/farmar_market'
# require_relative '../lib/farmar_product'
# require_relative '../lib/farmar_sale'


describe "Testing FarMar" do

  ##########------------------- Wave 1 ------------------------##########

  it "Must return total score for given word" do
    m1 = FarMar::Market.new
    expect(m1.market).must_be_instance_of(Array)
  end
end
