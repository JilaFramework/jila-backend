class CreateImageCredits < ActiveRecord::Migration
  def change
    create_table :image_credits do |t|
      t.string :attribution_text
      t.string :link

      t.timestamps
    end
  end
end
