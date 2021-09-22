class AddExtrasToEntries < ActiveRecord::Migration[4.2]
  def change
    add_column :entries, :extras, :text, default: "{alternate_translations: []}"
  end
end
