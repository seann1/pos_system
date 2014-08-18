class AddManagerAndPassword < ActiveRecord::Migration
  def change
    add_column :cashiers, :manager, :boolean
    add_column :cashiers, :password, :string
  end
end
