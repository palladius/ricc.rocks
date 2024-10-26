# Written b gemini
require 'yaml'
require 'fileutils'

def validate_yaml_front_matter(file_path)
  puts("💾 Evaluating file: #{file_path}")
  File.open(file_path) do |file|
    front_matter_found = false
    front_matter_content = ""

    file.each_line do |line|
      if line.strip == "---"
        front_matter_found = !front_matter_found
        next
      end

      if front_matter_found
        front_matter_content += line
      end
    end

    # If we found front matter, attempt to parse it as YAML
    if front_matter_found
      begin
        YAML.safe_load(front_matter_content)
      rescue Psych::SyntaxError => e
#        raise "Invalid YAML front matter in #{file_path}: #{e.message}"
        puts "Invalid YAML front matter in #{file_path}:\n#{e.backtrace.join("\n")}"
        raise 'paput!'
      end
    end
  end
end

# Iterate through all .txt files in the .cache directory
Dir.glob('.cache/*.txt').each do |file_path|
  validate_yaml_front_matter(file_path)
end

puts "All YAML front matter is valid!"
