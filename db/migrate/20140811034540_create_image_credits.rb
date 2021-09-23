class CreateImageCredits < ActiveRecord::Migration[4.2]
  def change
    create_table :image_credits do |t|
      t.string :attribution_text
      t.string :link

      t.timestamps
    end
  end
end
