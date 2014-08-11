class MakeCommonCategory < ActiveRecord::Migration
  def up
    ApiSweeper.disabled = true

    if Category.count > 0
      puts "Existing category found with ID #1"
      first_category = Category.find_by_id 1
      last_category = Category.last

      first_category.id = last_category.id + 1
      first_category.save
    end

    new_category = Category.create id: 1, name: 'Common Phrases'

    ApiSweeper.disabled = false
  end

  def down

  end
end
