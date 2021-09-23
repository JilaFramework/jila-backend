# frozen_string_literal: true

class LinkImageCreditToEntry < ActiveRecord::Migration[4.2]
  def change
    add_column :image_credits, :entry_id, :integer
  end
end
