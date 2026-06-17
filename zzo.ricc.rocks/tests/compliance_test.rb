# Ruby compliance test to validate Hugo posts against zzo.ricc.rocks/TESTING.md rules.
#
# Called by: `just test`
# Expected to fail now due to missing frontmatter/image snippets.

require 'yaml'
require 'date'
require 'fileutils'

def check_post_compliance(file_path)
  errors = []
  content = File.read(file_path)
  
  # Parse YAML Front Matter
  front_matter = {}
  if content =~ /\A---(.*?)---/m
    yaml_str = $1
    begin
      front_matter = YAML.safe_load(yaml_str, permitted_classes: [Date, Time]) || {}
    rescue => e
      errors << "Failed to parse YAML front matter: #{e.message}"
      return errors
    end
  else
    # Skip files without standard front matter (like _index.md sometimes)
    return []
  end

  # --- Rule 1: Initial snippet should NOT contain images ---
  # Snippet is defined as text before <!--more--> or the beginning of content.
  body = content.sub(/\A---.*?---/m, '').strip
  snippet = body.split(/<!--\s*more\s*-->/i).first || ""
  
  # Check for images in snippet
  if snippet =~ /!\[.*?\]\(.*?\)/ || snippet =~ /<img\s+/i || snippet =~ /\{\{\s*<\s*(figure|img|image|photo)\b/i
    errors << "Rule 1 Violation: Initial snippet contains an image or image shortcode."
  end

  # --- Rule 2: Point to Medium article or have `medium-site: absent` ---
  # TESTING.md: "Ensure the end of the R.R. Page points to the Medium article, if there is one. 
  # Otherwise the frontmatter should say explicitly: `medium-site: absent` and this needs to be done by a human, not by AI."
  medium_site = front_matter['medium-site']
  if medium_site.nil?
    errors << "Rule 2 Violation: Missing 'medium-site' frontmatter key. Must be a Medium URL or 'absent'."
  elsif medium_site != 'absent' && !(medium_site =~ %r{\Ahttps?://(.*\.)?medium\.com/})
    errors << "Rule 2 Violation: 'medium-site' must be either 'absent' or a valid Medium URL (got: '#{medium_site}')."
  end

  # --- Rule 3: Series/train pointers if part of multiseries ---
  # TESTING.md: "If this is a part of a multiseries article, ensure that article 1 points to article 2 and v.v. in a narrative 'train'."
  # If 'series' is specified in frontmatter, verify we have some narrative link or structure.
  if front_matter['series']
    # Just a placeholder check: if in a series, make sure body references other series pages or train structure.
    # We can warn or enforce. Let's make it a warning or check if there is references.
  end

  errors
end

# Find all markdown files recursively in content/en/posts/
posts_dir = File.expand_path("../content/en/posts", __dir__)
md_files = Dir.glob("#{posts_dir}/**/*.md")

# Filter out _index.md or files containing 'removeme' in name
md_files.reject! { |f| File.basename(f).start_with?('_') || f.include?('removeme') }

all_errors = {}

puts "Running compliance tests on #{md_files.count} posts..."
md_files.each do |file_path|
  relative_path = file_path.sub(File.expand_path("..", __dir__) + "/", "")
  errors = check_post_compliance(file_path)
  unless errors.empty?
    all_errors[relative_path] = errors
  end
end

if all_errors.empty?
  puts "\n\e[32m✅ Compliance tests passed successfully!\e[0m"
  exit(0)
else
  puts "\n\e[31m❌ Compliance tests failed!\e[0m"
  puts "Please fix the following issues:"
  all_errors.each do |file, errors|
    puts "\n  \e[36m#{file}\e[0m:"
    errors.each do |err|
      puts "    - #{err}"
    end
  end
  exit(1)
end
