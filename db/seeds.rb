require 'active_record'
require 'csv'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#

#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

input_file = "db/lexique_dict.txt"
csv_file = "db/parsed_lexique.csv"

def sanitise(value)
    return value.strip().sub("'", "''")
end

def save_to_db(entry)
    print("entry", entry)
    word = sanitise(entry[0])
    word_type = sanitise(entry[2])
    translation = sanitise(entry[3])
    #new_word = ActiveRecord::Base.connection.quote(entry[0])

    sql = "INSERT INTO entries(entry_word, word_type, translation) VALUES('#{word}',
    '#{word_type}', '#{translation}')"
    print("Execute SQL", sql)
    ActiveRecord::Base.connection.execute(sql)
end

File.delete(csv_file) if File.exist?(csv_file)
line_num = 0

CSV.open(csv_file, "w") do |csv|
    File.open(input_file,:encoding => 'utf-8').each do |line|
        #print "#{line_num += 1} #{line}"
        if not (line.include? "Category")
            line = line.gsub("\n", "Category: None\n")
        end

        result = line.scan(/(\S+)\W+\[(.+)\]\W+([^.]+)\.(.+)Category:\W+([^.]+)/)
        actual_value = result.first()
        save_to_db(actual_value)
        csv << actual_value
        # print result
        print "\n\n"
    end
end