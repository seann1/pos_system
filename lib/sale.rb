class Sale < ActiveRecord::Base

  belongs_to :products
  belongs_to :chasiers
  belongs_to :receipts
end
