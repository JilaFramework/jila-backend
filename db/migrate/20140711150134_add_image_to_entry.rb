class AddImageToEntry < ActiveRecord::Migration
  def change
  	change_table :entries do |t|
      t.attachment :image
    end
  end
end
