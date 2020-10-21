
#u
input_file = "lexique_dict.txt"
csv_file = "parsed_lexique.csv"

File.delete(csv_file) if File.exist?(csv_file)
line_num = 0
require 'csv'
CSV.open(csv_file, "w") do |csv|
    File.open(input_file,:encoding => 'utf-8').each do |line|
        #print "#{line_num += 1} #{line}"
        if not (line.include? "Category")
            line = line.gsub("\n", "Category: None\n")
        end

        result = line.scan(/(\S+)\W+\[(.+)\]\W+([^.]+)\.(.+)Category:\W+([^.]+)/)
        actual_value = result.first()
        csv << actual_value
        print result
        print "\n\n"
    end
end


