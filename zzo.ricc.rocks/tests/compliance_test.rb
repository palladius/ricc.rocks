# Ruby compliance test to validate Hugo posts against zzo.ricc.rocks/TESTING.md rules.
#
# Called by: `just test`
# Expected to fail now due to missing frontmatter/image snippets.

require 'yaml'
require 'date'
require 'fileutils'
require 'uri'

def tagged_as_medium?(front_matter)
  tags = front_matter['tags'] || front_matter['Tags'] || []
  if tags.is_a?(Array)
    tags.any? { |t| t.to_s.downcase.gsub('#', '') == 'medium' }
  elsif tags.is_a?(String)
    tags.split(/,\s*/).any? { |t| t.downcase.gsub('#', '') == 'medium' }
  else
    false
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

  # --- Rule 2: Point to Medium article if tagged with #medium ---
  if tagged_as_medium?(front_matter)
    canonical_url = front_matter['canonicalURL']

    # Check if the end of the body points to the Medium article
    end_of_body = body[-1500..-1] || body
    unless end_of_body.include?('medium.com')
      errors << "Rule 2 Violation: Post is tagged as 'medium', but the end of the body does not point to it (no medium.com link in the last 1500 characters)."
    end

    if canonical_url.nil?
      errors << "Rule 2 Violation: Post is tagged as 'medium', but missing 'canonicalURL' frontmatter key. It must point to the Medium article URL."
    elsif !canonical_url.to_s.include?('medium.com')
      errors << "Rule 2 Violation: 'canonicalURL' frontmatter key does not point to a valid Medium URL (got: '#{canonical_url}')."
    end
  end

  # --- Rule 3: Series/train pointers if part of multiseries ---
  if front_matter['series']
    # Placeholder for series validation
  end

  # --- Rule 4: No broken local images ---
  # Extract all image references from the body.
  image_refs = []
  # Markdown images: ![alt](path) — optionally followed by title in quotes
  body.scan(/!\[.*?\]\(([^)]+)\)/) { |m| image_refs << m[0].strip.split(/\s+/).first }
  # HTML img tags: <img src="path" ...> or <img src='path' ...>
  body.scan(/<img\b[^>]*\bsrc=["']([^"']+)["']/i) { |m| image_refs << m[0].strip }
  # Hugo shortcode img/figure: {{< img src="..." >}} or {{< figure src="..." >}}
  body.scan(/\{\{<\s*(?:img|figure)\b[^>]*\bsrc=["']([^"']+)["']/i) { |m| image_refs << m[0].strip }

  post_dir = File.dirname(file_path)
  # Hugo content root: two levels up from tests/ -> zzo.ricc.rocks/content/
  content_dir = File.expand_path("../content", __dir__)
  # Hugo static root: two levels up from tests/ -> zzo.ricc.rocks/static/
  static_dir  = File.expand_path("../static", __dir__)

  image_refs.uniq.each do |ref|
    # Skip absolute URLs (http/https/protocol-relative)
    next if ref =~ /\Ahttps?:\/\//i
    next if ref =~ /\A\/\//  # protocol-relative
    next if ref.strip.empty?

    if ref.start_with?('/')
      # Site-absolute path: Hugo merges content/ and static/ at the site root.
      # Check both locations before flagging as broken.
      relative = ref.sub(/\A\//, '')
      candidate_content = File.expand_path(relative, content_dir)
      candidate_static  = File.expand_path(relative, static_dir)
      unless File.exist?(candidate_content) || File.exist?(candidate_static)
        errors << "Rule 4 Violation: Broken site-absolute image '#{ref}' not found in content/ or static/."
      end
    else
      # Relative path: resolve relative to post's own directory (for page bundles)
      candidate = File.expand_path(ref, post_dir)
      unless File.exist?(candidate)
        errors << "Rule 4 Violation: Broken local image reference '#{ref}' (resolved to '#{candidate}') does not exist."
      end
    end
  end

  errors
end

# Resolve files to test
if ARGV.empty?
  posts_dir = File.expand_path("../content/en/posts", __dir__)
  md_files = Dir.glob("#{posts_dir}/**/*.md")
  md_files.reject! { |f| File.basename(f).start_with?('_') || f.include?('removeme') }
  puts "Running compliance tests on #{md_files.count} posts..."
else
  repo_root = File.expand_path("../..", __dir__) # Root of the git repository
  md_files = ARGV.map do |arg|
    resolved = nil
    if File.file?(arg)
      resolved = File.expand_path(arg)
    elsif File.file?(File.expand_path(arg, repo_root))
      resolved = File.expand_path(arg, repo_root)
    elsif File.file?(File.expand_path(arg, File.expand_path("..", __dir__))) # inside zzo.ricc.rocks
      resolved = File.expand_path(arg, File.expand_path("..", __dir__))
    else
      resolved = File.expand_path(arg, Dir.pwd)
    end
    
    unless File.file?(resolved)
      puts "\e[31mError: File not found: '#{arg}' (resolved as '#{resolved}')\e[0m"
      exit(1)
    end
    resolved
  end
  puts "Running compliance tests on #{md_files.count} specified post(s)..."
end

all_errors = {}
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
