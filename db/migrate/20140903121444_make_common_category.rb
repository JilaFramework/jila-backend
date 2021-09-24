# frozen_string_literal: true

class MakeCommonCategory < ActiveRecord::Migration[4.2]
  def up
    ApiSweeper.disabled = true

    if Category.count.positive?
      Rails.logger.debug 'Existing category found with ID #1'
      first_category = Category.find_by id: 1
      last_category = Category.last

      first_category.id = last_category.id + 1
      first_category.save
    end

    Category.create id: 1, name: 'Common Phrases'

    ApiSweeper.disabled = false
  end

  def down; end
end
