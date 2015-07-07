# == Dependencies ==============================================================

require 'rake'
require 'fileutils'

# == Configuration =============================================================

# Set "rake watch" as default task
task default: :hello

# == Helpers ===================================================================

# Execute a system command
def execute(command)
  system "#{command}"
end


# == Tasks =====================================================================
# rake post["Title"]
desc "Echo hello world in console"
task :hello do
  puts "============================="
  puts "Hi there. Boom shakalaka."
  puts "You can use this rake to generate post."
  puts "You can use this rake to sync your site as well."
  puts "============================="
  puts "Happy coding, living."
end

desc "Build the site and sync to the eurus ecs"
task :sync do
  execute("jekyll build")
  execute("rsync -vzr --delete _site/* deploy@eurus.cn:/var/www/lostpupil")
  execute("rsync -vzr --delete _site/* deploy@banana:/home/deploy/lostpupil")
end

date = "date: #{Time.now.strftime("%F %T")}"

desc "Create new post to the directories"
task :post , [:title, :category] do |t, args|
  # filename
  title = args[:title]
  name = title.split(" ").join("-")
  time = Time.now.strftime("%F").concat("-")
  filename = time+name+".md"
  puts "#{args[:author]} post filename is #{filename} and #{args[:author]} category is #{args[:category]}"
  # create file into category

  if Dir.exists?("#{Dir.getwd}/_posts/#{args[:category]}")
    File.open("#{Dir.getwd}/_posts/#{args[:category]}/#{filename}", "w+") do |f|
      f << "---\n"
      f << "layout: post\n"
      f << "#{date}\n"
      f << "title: #{title}\n"
      f << "category: #{args[:category]}\n"
      f << "description: \n"
      f << "---\n"
    end

  else
    raise 'Directory does not exist.'
  end
end
