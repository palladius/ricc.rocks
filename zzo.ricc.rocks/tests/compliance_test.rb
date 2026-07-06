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
  site_root   = File.expand_path("..", __dir__)          # zzo.ricc.rocks/
  # Hugo SOURCE resolution order for site-absolute paths (we check source, not build output):
  #   1. site content/  (page-bundle resources served at their content path)
  #   2. site static/   (static assets copied verbatim)
  #   3. theme static/  (theme-provided static assets)
  content_dir = File.join(site_root, "content")
  static_dir  = File.join(site_root, "static")
  # Detect active theme from config/_default/config.yaml
  theme_static_dir = nil
  config_file = File.join(site_root, "config/_default/config.yaml")
  if File.exist?(config_file)
    config_content = File.read(config_file)
    if config_content =~ /^theme:\s*(\S+)/
      active_theme = $1.strip.gsub(/['"]/, '')
      theme_static_dir = File.join(site_root, "themes", active_theme, "static")
    end
  end

  image_refs.uniq.each do |ref|
    # Skip absolute URLs (http/https/protocol-relative)
    next if ref =~ /\Ahttps?:\/\//i
    next if ref =~ /\A\/\//  # protocol-relative
    next if ref.strip.empty?

    if ref.start_with?('/')
      # Site-absolute path: check Hugo source dirs in resolution order
      relative = ref.sub(/\A\//, '')
      found = File.exist?(File.join(content_dir, relative)) ||
              File.exist?(File.join(static_dir, relative))  ||
              (theme_static_dir && File.exist?(File.join(theme_static_dir, relative)))
      unless found
        errors << "Rule 4 Violation: Broken site-absolute image '#{ref}' not found in source (content/, static/, or theme static/)."
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

def verify_wikimojis(file_path, site_root, wikimoji_config)
  errors = []
  return errors unless wikimoji_config && wikimoji_config['enabled']

  content = File.read(file_path)
  links = []
  content.scan(/\[([^\]]+)\]\(([^)]+)\)/) do |text, url|
    links << { text: text, url: url.strip }
  end

  return errors if links.empty?

  relative_path = file_path.sub(File.join(site_root, "content") + "/", "")
  html_relative = relative_path.sub(/\.md$/, "/index.html").gsub(/\/index\/index.html$/, "/index.html")
  if relative_path.end_with?("index.md")
    html_relative = relative_path.sub(/index\.md$/, "index.html")
  end
  
  html_path = File.join(site_root, "public", html_relative)

  unless File.exist?(html_path)
    return errors
  end

  html_content = File.read(html_path)

  links.each do |link|
    url = link[:url]
    text = link[:text]
    plain_text = text.gsub(/<[^>]*>/, '')

    matched_target = nil
    wikimoji_config['targets'].each do |target|
      next if matched_target
      has_pattern = target['patterns'].any? do |pattern|
        begin
          Regexp.new(pattern).match?(url)
        rescue
          url.include?(pattern)
        end
      end
      matched_target = target if has_pattern
    end

    next unless matched_target

    emoji = matched_target['emoji']
    svg_partial = matched_target['svg_partial']

    should_prepend = true
    if emoji && plain_text.start_with?(emoji)
      should_prepend = false
    end
    if plain_text.empty? || text =~ /\A<(img|picture|svg|iframe)/i
      should_prepend = false
    end

    next unless should_prepend

    url_path = URI.parse(url).path rescue url
    url_path = url if url_path.nil? || url_path.empty?
    escaped_url_path = Regexp.escape(url_path)

    if emoji
      pattern = /class="wikimoji-emoji"[^>]*>\s*#{Regexp.escape(emoji)}\s*<\/span>&nbsp;<a\s+[^>]*href=["'][^"']*#{escaped_url_path}[^"']*["']/
      unless html_content =~ pattern
        errors << "Wikimoji Violation: Link to '#{url}' ('#{text}') is missing the expected emoji '#{emoji}' in the built HTML."
      end
    elsif svg_partial
      pattern = /class="wikimoji-icon-wrapper"[^>]*>\s*<svg[^>]*>.*?<\/svg>\s*<\/span>&nbsp;<a\s+[^>]*href=["'][^"']*#{escaped_url_path}[^"']*["']/m
      unless html_content =~ pattern
        errors << "Wikimoji Violation: Link to '#{url}' ('#{text}') is missing the expected SVG icon '#{svg_partial}' in the built HTML."
      end
    end
  end

  errors
end

# Resolve files to test
if ARGV.empty?
  site_root  = File.expand_path("..", __dir__)   # zzo.ricc.rocks/
  posts_dir  = File.join(site_root, "content/en/posts")
  # Use git ls-files to respect .gitignore (skips public/, resources/, etc.)
  git_files = `git -C #{site_root} ls-files content/en/posts/`.strip.split("\n")
  if $?.success? && !git_files.empty?
    md_files = git_files
      .select { |f| f.end_with?('.md') }
      .reject { |f| File.basename(f).start_with?('_') || f.include?('removeme') }
      .map    { |f| File.join(site_root, f) }
  else
    # Fallback: plain glob (may include ignored dirs)
    md_files = Dir.glob("#{posts_dir}/**/*.md")
    md_files.reject! { |f| File.basename(f).start_with?('_') || f.include?('removeme') }
  end
  puts "Running compliance tests on #{md_files.count} posts (git-tracked only)..."
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

# Load Wikimoji config
wikimoji_config = nil
wikimoji_file = File.join(File.expand_path("..", __dir__), "data/wikimoji.yaml")
if File.exist?(wikimoji_file)
  begin
    wikimoji_config = YAML.load_file(wikimoji_file)
  rescue => e
    puts "Warning: Failed to load wikimoji.yaml: #{e.message}"
  end
end

# Build the site to ensure public/ is fresh for HTML-based tests
if wikimoji_config && wikimoji_config['enabled']
  puts "Building Hugo site to verify HTML output..."
  build_cmd = "which hugo >/dev/null 2>&1 && hugo --quiet || npx -y hugo-extended --quiet"
  system("cd #{File.expand_path("..", __dir__)} && #{build_cmd}")
end

all_errors = {}
md_files.each do |file_path|
  relative_path = file_path.sub(File.expand_path("..", __dir__) + "/", "")
  errors = check_post_compliance(file_path)
  
  if wikimoji_config && wikimoji_config['enabled']
    wikimoji_errors = verify_wikimojis(file_path, File.expand_path("..", __dir__), wikimoji_config)
    errors.concat(wikimoji_errors)
  end

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
