class CreateProduct < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.column :name, :string
      t.column :price, :integer

      t.timestamps
    end
  end
end
