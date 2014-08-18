require 'spec_helper'

describe Cashier do
  it 'has many sales' do
    cashier = Cashier.create({:name => 'Bob'})
    sale = Sale.create({:product_id => 1, :cashier_id => cashier.id})
    cashier.sales.should eq [sale]
  end
end
