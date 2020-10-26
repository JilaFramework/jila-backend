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
    return value.lstrip.strip().gsub("'", "''")
end

def extract_all_translations(sentences)
    splits = sentences.split(".")
    if splits.length != 3 # exceptional cases - just treat everything  as "translation"
        translation =  sentences.lstrip.strip
        # print("\nEXCEPTION traslation!", translation)
        return translation, nil, nil
    end
    translation = splits[0].lstrip.strip
    example = nil
    example_translation = nil
    if splits.length() >= 2
        example = splits[1].lstrip.strip
    end
    if splits.length() >= 3
        example_translation = splits[2].lstrip.strip
    end
    # print("\nsplits", splits)
    # print("\ntranslation: ", translation, "\nexample: ", example, ";\nexample_translation:", example_translation)
    return translation, example, example_translation
end

def save_entry_to_db(entry)
        # Example of an entry:
        # Bambarrwarn  	[Bam-barr-warn] nominal. Goosehole. billabong southwest of the Fitzroy Crossing Lodge. Bambarrwarn gamba goorroorla. Goosehole is a billabong.

    return if (!entry)
    word = sanitise(entry[0])
    pronunciation = sanitise(entry[1])
    word_type = sanitise(entry[2])
    translation, example, example_translation = extract_all_translations(sanitise(entry[3]))
    category_value = sanitise(entry[4])

    category = Category.find_or_create_by(name: category_value)

    entry = Entry.create(
        entry_word: word,
        word_type: word_type,
        translation: translation,
        example: example,
        example_translation: example_translation,
        categories: [category],
        pronunciation: pronunciation
    )

end

File.delete(csv_file) if File.exist?(csv_file)
line_num = 0

CSV.open(csv_file, "w") do |csv|
    File.open(input_file,:encoding => 'utf-8').each do |line|
        if line_num > 50
            break
        end
        puts "Skip line!" if (line.include? "1 •") or (line.include? "2 •")
        next if (line.include? "1 •") or (line.include? "2 •")

        if not (line.include? "Category")
            line = line.gsub("\n", "Category: None\n")
        end

        result = line.scan(/(\S+)\W+\[(.+)\]\W+([^.]+)\.(.+)Category:\W+([^.]+)/)
        actual_value = result.first()
        if actual_value
            save_entry_to_db(actual_value)
            csv << actual_value
        end
        print "\n\n"
        line_num += 1
    end
end