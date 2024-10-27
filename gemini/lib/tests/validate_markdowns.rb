
def validate_yaml_front_matter_for_file(file_path)
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
        #raise 'paput!'
      end
    end
  end
end


def validate_yaml_front_matter_for_dir(dir, extension: '.md')
  #Dir.glob('.cache/*.txt').each do |file_path|
  Dir.glob("#{dir}/*#{extension}").each do |file_path|
    validate_yaml_front_matter_for_file(file_path)
  end
end
