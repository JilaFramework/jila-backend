# frozen_string_literal: true

class AddAudioToEntries < ActiveRecord::Migration[4.2]
  def change
    change_table :entries do |t|
      t.attachment :audio
    end
  end
end
