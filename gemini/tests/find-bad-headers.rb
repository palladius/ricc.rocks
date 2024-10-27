

require 'fileutils'

def validate_markdown_files(directory)
  Dir.glob("#{directory}/**/*.md").each do |file|
    puts "Validating file: #{file}"
    File.open(file) do |f|
      first_line = f.readline.strip
      unless first_line == "---" || first_line == "+++"
        raise "Invalid Markdown file: #{file}. First line should be '---' or '+++'"
      end
    end
  end
end

# Replace 'your_directory' with the actual directory path
validate_markdown_files('../zzo.ricc.rocks/')
