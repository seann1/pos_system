class Receipt < ActiveRecord::Base

  has_many :sales
end
