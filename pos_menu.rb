require 'active_record'
require './lib/product'
require './lib/cashier'
require './lib/sale'
require './lib/receipt'
require 'pry'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
  @cashier_id = nil
  puts '~~~~~~~~~~~~~POS TRACKER~~~~~~~~~~~~~'
  login_start
end

def login_start
  choice = nil
  until choice == 'x'
    puts "~~~~~~~~~~~~~~LOG IN~~~~~~~~~~~~~~"
    puts "Press 'l' to login as a cashier"
    puts "Press 'm' to login as a manager"
    puts "Press 'a' to add a new user"
    puts "Press 'x' to exit"
    choice = gets.chomp
    case choice
    when 'l'
      cashier_login
    when 'm'
      manager_login
    when 'a'
      puts "Press 'm' for manager"
      puts "press 'c' for cashier"
      user_choice = gets.chomp
      if user_choice == 'm'
        add_manager
      elsif user_choice == 'c'
        add_cashier
      else
        puts "NOT VALID"
        welcome
      end
    when 'x'
      exit
    end
  end
end

def menu
  choice = nil
  until choice == 'x'
    puts "Press 'p' to enter a product"
    puts "Press 'c' to add a cashier"
    puts "Press 's' to enter a sale"
    puts "Press 'lp' to list product inventory"
    puts "Press 'd' to delete a product"
    puts "Press 'dc' to delete a cashier"
    puts "Press 'ls' to see all sales"
    puts "Press 'x' to logout"
    puts "Press 'xx' to exit"
    choice = gets.chomp
    case choice
    when 'l'
      login
    when 'p'
      add_product
    when 's'
      add_sale
    when 'lp'
      list_products
    when 'd'
      delete_product
    when 'dc'
      delete_cashier
    when 'c'
      add_cashier
    when 'x'
      logout
    when 'xx'
      puts "Good Bye"
      exit
    when 'cc'
      current_cashier
    when 'ls'
      list_sales
    end
  end
end

def cashier_login
  list_cashiers
  puts "Enter user name"
  name_input = gets.chomp
  puts "Enter Password"
  user_password = gets.chomp
  current_cashier = Cashier.find_by(name: name_input)
  if current_cashier.password == user_password
    @cashier_id = current_cashier.id
    @manager = current_cashier.manager
    menu
  else
    puts "YOUR PASSWORD IS NOT CORRECT"
    login_start
  end
end

def manager_login
  list_managers
  puts "Enter user name"
  name_input = gets.chomp
  puts "Enter Password"
  user_password = gets.chomp
  current_cashier = Cashier.find_by(name: name_input)
  if current_cashier.password == user_password
    @cashier_id = current_cashier.id
    @manager = current_cashier.manager
    menu
  else
    puts "YOUR PASSWORD IS NOT CORRECT"
    login_start
  end
end

def logout
  @cashier_id = nil
  puts "You are logged out"
end

def add_product
  if @manager == true
    puts "ENTER PRODUCT NAME"
    pro_name = gets.chomp
    puts "ENTER PRODUCT PRICE"
    pro_price = gets.chomp
    product = Product.new({:name => pro_name, :price => pro_price})
    Product.all.each do |i|
      if pro_name == i.name
        puts "That product already exists"
        welcome
      end
    end
    if product.save
      puts "#{product.name} has been added to your inventory."
    else
      puts "Please enter valid input for the product."
    end
  else
    puts "YOU ARE NOT AUTHORIZED TO DO THIS"
  end
end

def add_sale
  current_receipt = Receipt.create
  list_products
  puts "Enter product id with '-' as a seperation i.e., 302-89-21"
  sold_id = gets.chomp
  individual_id = sold_id.split('-')
  if @cashier_id == nil
    puts "You must log in first"
    menu
  else
    individual_id.each do |i|
      found_product = Product.find_by({:id => i.to_i})
      sale = Sale.create({:product_id => found_product.id, :cashier_id => @cashier_id, :receipt_id => current_receipt.id})
    end
  end
  puts "Your receipt number is: #{current_receipt.id}"
end

def current_cashier
  if @cashier_id == nil
    puts "Nobody is logged in."
  else
    cashier = Cashier.find_by({id: @cashier_id})
    puts "Current cashier: #{cashier.name}"
  end
end

def add_cashier
  puts "ENTER CASHIER NAME"
  cash_name = gets.chomp
  puts "ADD A PASSWORD WHICH IS CASE SENSITIVE"
  pass_input = gets.chomp
  cashier = Cashier.new({:name => cash_name, :manager => false, :password => pass_input})
  if cashier.save
    puts "#{cashier.name} has been added to your servitude"
  else
    puts "Please enter a valid name"
  end
end

def add_manager
  puts "ENTER MANAGER NAME"
  cash_name = gets.chomp
  puts "ADD A PASSWORD WHICH IS CASE SENSITIVE"
  pass_input = gets.chomp
  cashier = Cashier.new({:name => cash_name, :manager => true, :password => pass_input})
  if cashier.save
    puts "#{cashier.name} has been added to your servitude"
  else
    puts "Please enter a valid name"
  end
end

def delete_product
  Product.all.each do |i|
    puts "#{i.name}"
  end
  puts "ENTER PRODUCT TO REMOVE"
  user_product = gets.chomp
  entry_to_delete = Product.find_by(name: user_product)
  entry_to_delete.destroy
end

def delete_cashier
  Cashier.all.each do |i|
    puts "#{i.name}"
  end
  puts "ENTER A CASHIER TO SACK"
  cash_name = gets.chomp
  cash_to_delete = Cashier.find_by(name: cash_name)
  cash_to_delete.destroy
end

def list_products
  puts "~~~~~~~~~~INVENTORY~~~~~~~~~~"
  Product.all.each do |i|
    puts "#{i.id}: #{i.name}, $#{i.price}"
  end
end

def list_managers
  puts "~~~~~~~~~~MANAGERS~~~~~~~~~~"
  managers = Cashier.where(:manager => true)
  managers.each do |i|
    puts "#{i.name}"
  end
end

def list_cashiers
  puts "~~~~~~~~~~CASHIERS~~~~~~~~~~"
  cashiers = Cashier.where(:manager => false)
  cashiers.each do |i|
    puts "#{i.name}"
  end
end

def list_sales
  total = 0
  current_cashier
  current_sales = Sale.where(:cashier_id => @cashier_id)
  current_sales.each do |i|
    current_products = Product.where(:id => i.product_id)
    puts "#{current_products.first.name}: $#{current_products.first.price}"
    total += current_products.first.price
  end
  puts "~~~~~TOTAL SALES: $#{total}~~~~~"
end


welcome

