class Product < ActiveRecord::Base
  has_many :sales
  before_save :downcase_name

  validates :price, presence: true, numericality: true

  def downcase_name
    name.downcase!
  end
end
