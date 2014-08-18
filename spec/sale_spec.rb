require 'spec_helper'

describe Sale do
  it 'belongs to a cashier and product and receipt' do
    product = Product.create({:name => "milk", :price => 4})
    cashier = Cashier.create({:name => 'bob'})
    sale = Sale.create({:product_id => product.id, :cashier_id => cashier.id})
    product.sales.should eq [sale]
    cashier.sales.should eq [sale]
    receipt.sales.should eq [sale]
  end
end
