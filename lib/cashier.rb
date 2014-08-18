class Cashier < ActiveRecord::Base

  has_many :sales
  before_save :downcase_name
  validates :name, presence: true, :length => { :maximum => 50 }

  def downcase_name
    name.downcase!
  end
end
