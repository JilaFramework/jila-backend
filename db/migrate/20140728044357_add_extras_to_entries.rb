class AddExtrasToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :extras, :text, default: {alternate_translations: []}
  end
end
