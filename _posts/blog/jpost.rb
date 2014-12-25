layout = "layout: post"
date = "date: #{Time.now.strftime("%F %T")}"

puts "Hello, feel free to use jpost script."
###post filename
puts "Please enter the file name"
pre_name = $stdin.gets
next_name = pre_name.split(" ").join("-")
time = Time.now.strftime("%F").concat("-")
filename = time+next_name+".md"
puts "your post filename is #{filename}"
###post filename

###post title
puts "Please enter the post title"
title = $stdin.gets
next_title = "title: #{title}"
puts "your post title is #{title}"
###post title

###post categroy
puts "Please enter the post category"
category = $stdin.gets
next_category = "category: #{category}"
puts "your post categroy is #{category}"
###post categroy

###post descripiton
puts "Please enter the post description"
description = $stdin.gets
next_description = "description: #{description}"
puts "your post description is #{description}"
###post description



File.open(filename, "w+") do |f|     
	f.write('---')
	f.write("\n")
	f.write(layout)
	f.write("\n")
	f.write(next_title)
	f.write(next_category)
	f.write(next_description)
	f.write(date)
	f.write("\n")
	f.write('---')   
end
