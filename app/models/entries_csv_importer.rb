# frozen_string_literal: true

require 'csv'

class EntriesCSVImporter
  class << self
    def convert_caracters(value)
      value.force_encoding('ASCII-8BIT').encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
    end

    def convert_save(csv_data)
      csv_file = csv_data.read
      CSV.parse(csv_file) do |row|
        word = convert_caracters(row[0])
        pronunciation = convert_caracters(row[1])
        word_type = convert_caracters(row[2])
        meaning = convert_caracters(row[3])
        category_name = convert_caracters(row[4])

        category = Category.find_or_create_by(name: category_name)

        Entry.create(entry_word: word, pronunciation: pronunciation, word_type: word_type, meaning: meaning, categories: [category])
      end
    end
  end
end
