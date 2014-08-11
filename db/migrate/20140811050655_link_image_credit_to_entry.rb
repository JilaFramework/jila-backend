class LinkImageCreditToEntry < ActiveRecord::Migration
  def change
    add_column :image_credits, :entry_id, :integer
  end
end
