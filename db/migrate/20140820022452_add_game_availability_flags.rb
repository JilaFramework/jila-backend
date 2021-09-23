# frozen_string_literal: true

class AddGameAvailabilityFlags < ActiveRecord::Migration[4.2]
  def change
    add_column :categories, :image_game_available?, :boolean, default: true
    add_column :categories, :audio_game_available?, :boolean, default: true
  end
end
