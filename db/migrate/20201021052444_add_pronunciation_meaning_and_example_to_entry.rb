class AddPronunciationMeaningAndExampleToEntry < ActiveRecord::Migration
  def change
    change_table :entries do |t|
      t.string :pronunciation
      t.string :meaning
      t.string :example
      t.string :example_translation
    end
  end
end
