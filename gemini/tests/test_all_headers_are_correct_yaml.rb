# Written b gemini
require 'yaml'
require 'fileutils'

puts("TODO import lib/tests/blah")
require_relative "../lib/tests/validate_markdowns"

# def validate_yaml_front_matter_for_dir(dir, extension: '.md')
#   Dir.glob('.cache/*.txt').each do |file_path|
#     validate_yaml_front_matter(file_path)
#   end
# end

validate_yaml_front_matter_for_dir(".cache/", extension: '.txt')
validate_yaml_front_matter_for_dir(".cache/", extension: '.md')

# Iterate through all .txt files in the .cache directory
# Dir.glob('.cache/*.txt').each do |file_path|
#   validate_yaml_front_matter(file_path)
# end

puts "All YAML front matter is valid!"
