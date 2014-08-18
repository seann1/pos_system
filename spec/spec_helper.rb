require 'active_record'
require 'rspec'
require 'shoulda-matchers'

require 'product'
require 'cashier'
require 'sale'
require 'receipt'

database_configurations = YAML::load(File.open('./db/config.yml'))
test_configuration = database_configurations['test']
ActiveRecord::Base.establish_connection(test_configuration)

RSpec.configure do |config|
  config.after(:each) do
    Product.all.each { |looplord| looplord.destroy }
    Cashier.all.each { |looplord| looplord.destroy }
    Sale.all.each { |looplord| looplord.destroy }
  end
end
