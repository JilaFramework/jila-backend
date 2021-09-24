# frozen_string_literal: true

class AddDisplayOrderToEntries < ActiveRecord::Migration[4.2]
  def change
    add_column :entries, :display_order, :integer
  end
end
