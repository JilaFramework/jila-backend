class LinkImageCreditsToCategories < ActiveRecord::Migration[4.2]
  def change
    add_column :image_credits, :category_id, :integer
  end
end
