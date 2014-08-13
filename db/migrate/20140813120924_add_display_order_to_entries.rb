class AddDisplayOrderToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :display_order, :integer
  end
end
