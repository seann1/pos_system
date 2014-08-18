require 'spec_helper'

describe Product do

  it { should validate_presence_of :price }

  it 'has many sales' do
    product = Product.create({:name => 'milk', :price => 4})
    sale = Sale.create({:product_id => product.id, :cashier_id => 1})
    product.sales.should eq [sale]
  end
end
