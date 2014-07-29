class MakeCommonCategory < ActiveRecord::Migration
  def change
    if Category.count > 0
      first_category = Category.find_by_id 1
      last_category = Category.last

      first_category.id = last_category.id + 1
      first_category.save!
    end

    Category.create id: 1, name: 'Greetings/Common'
  end
end
