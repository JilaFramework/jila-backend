class AddAudioToEntries < ActiveRecord::Migration
  def change
  	change_table :entries do |t|
      t.attachment :audio
    end
  end
end
