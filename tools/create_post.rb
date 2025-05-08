#!/usr/bin/env ruby

require 'time'

def create_post(title)
  # Convert title to filename format
  filename = title.downcase.gsub(/[^a-z0-9\s-]/, '').gsub(/\s+/, '-')
  date = Time.now.strftime('%Y-%m-%d')
  full_filename = "#{date}-#{filename}.md"

  # Get current time in UTC
  current_time = Time.now.utc.strftime('%Y-%m-%d %H:%M:%S +0000')

  # Create post content
  content = <<~POST
    ---
    title: #{title}
    date: #{current_time}
    categories: []
    tags: []
    last_modified_at: #{current_time}
    ---

    Write your post content here...
  POST

  # Write to file
  File.write("_posts/#{full_filename}", content)
  puts "Created new post: _posts/#{full_filename}"
end

# Get title from command line argument
if ARGV.empty?
  puts "Please provide a title for the post:"
  title = gets.chomp
else
  title = ARGV.join(' ')
end

create_post(title)
