require 'spec_helper'

describe Receipt do
  it 'has many sales' do
    receipt = Receipt.create({:id => 409})
    sale = Sale.create({:product_id => 11, :cashier_id => 22, :receipt_id => receipt.id})
    cashier.sales.should eq [sale]
  end
end
