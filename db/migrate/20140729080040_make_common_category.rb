class MakeCommonCategory < ActiveRecord::Migration
  def up
    if Category.count > 0
      puts "Existing category found with ID #1"
      first_category = Category.find_by_id 1
      last_category = Category.last

      entries = first_category.entries.to_a

      first_category.id = last_category.id + 1
      first_category.save!

      entries.each do |e|
        puts "Moving entry '#{e.entry_word}' to #{first_category.id}"
        e.categories = [first_category]
        e.save
      end
    end

    Category.create id: 1, name: 'Greetings/Common'
  end

  def down

  end
end
