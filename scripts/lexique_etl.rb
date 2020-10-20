
input_file = "lexique_dict.txt"

line_num = 0

File.open(input_file).each do |line|
    print "#{line_num += 1} #{line}"
    result = line.scan(/(\S+)\W+\[(.+)\]\W+(\w+)\.(.+)Category:\W+(.+)/)
    print result
    break
end

