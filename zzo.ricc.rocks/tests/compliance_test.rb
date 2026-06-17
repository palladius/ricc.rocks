# Ruby compliance test to validate Hugo posts against zzo.ricc.rocks/TESTING.md rules.
#
# Called by: `just test`
# Expected to fail now due to missing frontmatter/image snippets.

require 'yaml'
require 'date'
require 'fileutils'

def has_medium_link?(front_matter, body)
  return true if front_matter['canonicalURL'] && front_matter['canonicalURL'].to_s.include?('medium.com')
  return true if front_matter['medium-site'] && front_matter['medium-site'].to_s.include?('medium.com')
  # Check if there is an explicit Medium article link in the body
  # Excluding author profile page and feeds
  medium_urls = body.scan(%r{https?://(?:[a-zA-Z0-9-]+\.)?medium\.com/(\S+)})
  medium_urls.any? do |path_match|
    path = path_match.first
    path && !path.start_with?('@') && !path.include?('feed')
  end
end

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

  body = content.sub(/\A---.*?---/m, '').strip

  # --- Rule 1: Initial snippet should NOT contain images and word count should be similar ---
  # Snippet extraction logic simulating Hugo:
  snippet = ""
  source_type = :none

  if front_matter['summary'] && !front_matter['summary'].strip.empty?
    snippet = front_matter['summary']
    source_type = :front_matter
  elsif body =~ /<!--\s*more\s*-->/i
    snippet = body.split(/<!--\s*more\s*-->/i).first || ""
    source_type = :more_tag
  else
    # Fallback to 70 words, stripping HTML comments first
    clean_body = body.gsub(/<!--.*?-->/m, '')
    words = clean_body.strip.split(/\s+/)
    snippet = words[0...70].join(" ")
    source_type = :fallback_70_words
  end

  # Check for images in the extracted snippet
  if snippet =~ /!\[.*?\]\(.*?\)/ || snippet =~ /<img\s+/i || snippet =~ /\{\{\s*[<%]\s*(figure|img|image|photo)\b/i
    errors << "Rule 1 Violation: Initial snippet (via #{source_type}) contains an image or image shortcode."
  end

  # Check word count of the snippet to ensure they are similar/reasonable
  word_count = snippet.split(/\s+/).reject(&:empty?).size
  if word_count < 10
    errors << "Rule 1 Violation: Snippet (via #{source_type}) is too short (#{word_count} words). Must be at least 10 words."
  elsif word_count > 120
    errors << "Rule 1 Violation: Snippet (via #{source_type}) is too long (#{word_count} words). Must be at most 120 words."
  end

  # --- Rule 2: Point to Medium article or have `medium-site: absent` ---
  medium_linked = has_medium_link?(front_matter, body)
  medium_site = front_matter['medium-site']

  if medium_linked
    # Check if the end of the body points to the Medium article
    end_of_body = body[-1500..-1] || body
    unless end_of_body.include?('medium.com')
      errors << "Rule 2 Violation: This post has a Medium article, but the end of the body does not point to it (no medium.com link in the last 1500 characters)."
    end

    if medium_site.nil?
      errors << "Rule 2 Violation: Missing 'medium-site' frontmatter key. Since a Medium link exists, 'medium-site' must point to the Medium article URL."
    elsif medium_site == 'absent'
      errors << "Rule 2 Violation: 'medium-site' is set to 'absent', but a Medium link was found in the content/frontmatter."
    elsif !medium_site.to_s.include?('medium.com')
      errors << "Rule 2 Violation: 'medium-site' frontmatter key does not point to a valid Medium URL (got: '#{medium_site}')."
    end
  else
    if medium_site.nil?
      errors << "Rule 2 Violation: Missing 'medium-site' frontmatter key. If there is no Medium article, specify: `medium-site: absent`."
    elsif medium_site != 'absent'
      errors << "Rule 2 Violation: 'medium-site' is set to '#{medium_site}', but no Medium link was found. Set to 'absent' if there is no Medium article."
    end
  end

  # --- Rule 3: Series/train pointers if part of multiseries ---
  if front_matter['series']
    # Placeholder for series validation
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
