class GiveCategoriesToEntries < ActiveRecord::Migration[4.2]
  def change
  	create_table :categories_entries do |t|
  		t.belongs_to :category
  		t.belongs_to :entry
  	end
  end
end
