
input_file = "lexique_dict.txt"

line_num = 0

File.open(input_file).each do |line|
    print "#{line_num += 1} #{line}"
    if not (line.include? "Category")
        line = line.gsub("\n", "Category: None\n")
    end

    result = line.scan(/(\S+)\W+\[(.+)\]\W+([^.]+)\.(.+)Category:\W+([^.]+)/)
    print result
    print "\n\n"
end
