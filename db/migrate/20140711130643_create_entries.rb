class CreateEntries < ActiveRecord::Migration[4.2]
  def change
    create_table :entries do |t|
      t.string :entry_word
      t.string :word_type
      t.string :translation
      t.text :description
      t.boolean :published?

      t.timestamps
    end
  end
end
