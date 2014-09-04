class LinkImageCreditsToCategories < ActiveRecord::Migration
  def change
    add_column :image_credits, :category_id, :integer
  end
end
