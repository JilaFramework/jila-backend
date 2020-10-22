require 'active_record'
require 'csv'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#

#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

input_file = "db/lexique_dict_full.txt"
csv_file = "db/parsed_lexique.csv"

ApiSweeper.disabled = true

def sanitise(value)
    return value.strip().gsub("'", "''")
end

def save_to_db(entry)
    return if (!entry)
    print("entry", entry)
    word = sanitise(entry[0])
    word_type = sanitise(entry[2])
    translation = sanitise(entry[3])
    category_value = sanitise(entry[3])

    # This solution works
    # # category_entry
    # sql = "INSERT INTO entries(entry_word, word_type, translation) VALUES('#{word}',
    # '#{word_type}', '#{translation}')"
    # print("Execute SQL", sql)
    # ActiveRecord::Base.connection.execute(sql)

    # This one
    category = Category.find_or_create_by(name: category_value)

    entry = Entry.create(
        entry_word: word,
        word_type: word_type,
        translation: translation,
        categories: [category]
    )

end

File.delete(csv_file) if File.exist?(csv_file)
line_num = 0

CSV.open(csv_file, "w") do |csv|
    File.open(input_file,:encoding => 'utf-8').each do |line|
        puts "Skip line!" if (line.include? "1 •") or (line.include? "2 •")
        next if (line.include? "1 •") or (line.include? "2 •")

        if not (line.include? "Category")
            line = line.gsub("\n", "Category: None\n")
        end

        result = line.scan(/(\S+)\W+\[(.+)\]\W+([^.]+)\.(.+)Category:\W+([^.]+)/)
        actual_value = result.first()
        if actual_value
            save_to_db(actual_value)
            csv << actual_value
        end
        print "\n\n"
    end
end