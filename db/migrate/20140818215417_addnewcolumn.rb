class Addnewcolumn < ActiveRecord::Migration
  def change
    add_column :sales, :receipt_id, :integer
  end
end
