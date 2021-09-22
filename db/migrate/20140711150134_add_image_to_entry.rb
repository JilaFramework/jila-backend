class AddImageToEntry < ActiveRecord::Migration[4.2]
  def change
  	change_table :entries do |t|
      t.attachment :image
    end
  end
end
