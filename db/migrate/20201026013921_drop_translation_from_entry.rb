# frozen_string_literal: true

class DropTranslationFromEntry < ActiveRecord::Migration[4.2]
  def change
    remove_column :entries, :translation
  end
end
