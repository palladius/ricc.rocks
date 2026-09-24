#!/usr/bin/env ruby
# frozen_string_literal: true

# Ruby test suite to validate homepage & about page links in zzo.ricc.rocks:
# 1. Apps Portfolio link (Desktop navbar, Mobile navbar, Footer, About page)
# 2. Curriculum Vitae (CV) links in both EN & IT (1-pager PDF, Full PDF, Extended HTML) + file existence
# 3. Social & Identity links (GitHub, LinkedIn, YouTube, Medium, StackOverflow, Twitter/X, Instagram, Email, Avatar)
# 4. Core Navigation, Language Switcher, RSS/Search Indexes, and Repo attribution
# 5. Zero broken local links (`<a href>`, `<img src>`, `<img data-src>`) and zero leaked shortcodes

require 'uri'

SITE_ROOT   = File.expand_path('..', __dir__)
PUBLIC_DIR  = File.join(SITE_ROOT, 'public')
PORTFOLIO_URL = 'https://portfolio-app-272932496670.europe-west1.run.app/about'

# Build site unless --no-build is passed
unless ARGV.include?('--no-build')
  puts '🔨 Building Hugo site (public/) for homepage link verification...'
  nvm_bins = Dir.glob(File.expand_path('~/.nvm/versions/node/*/bin')).last
  env_path = [nvm_bins, '/home/linuxbrew/.linuxbrew/bin', File.expand_path('~/.local/bin'), ENV['PATH']].compact.join(':')
  build_cmd = 'which hugo >/dev/null 2>&1 && hugo --minify --quiet || npx -y hugo-extended --minify --quiet'
  success = system({ 'PATH' => env_path }, "cd #{SITE_ROOT} && #{build_cmd}")
  unless success
    puts "\e[31m❌ Failed to build Hugo site before running homepage link tests!\e[0m"
    exit(1)
  end
end

$passed = 0
$failed = 0
$failures = []

def assert_test(description, condition, failure_detail = nil)
  if condition
    $passed += 1
    puts "  \e[32m✓\e[0m #{description}"
  else
    $failed += 1
    msg = failure_detail ? "#{description} — #{failure_detail}" : description
    $failures << msg
    puts "  \e[31m✗ #{msg}\e[0m"
  end
end

# Extract all href attributes from <a ...> tags in HTML (handles minified and quoted attributes)
def extract_anchor_hrefs(html)
  hrefs = []
  html.scan(/<a\b[^>]*>/i) do |a_tag|
    if a_tag =~ /\bhref=(?:"([^"]+)"|'([^']+)'|([^\s>]+))/i
      hrefs << ($1 || $2 || $3)
    end
  end
  hrefs.uniq
end

# Extract all local media src/data-src attributes from <img> tags
def extract_img_srcs(html)
  srcs = []
  html.scan(/<img\b[^>]*>/i) do |img_tag|
    if img_tag =~ /\bsrc=(?:"([^"]+)"|'([^']+)'|([^\s>]+))/i
      srcs << ($1 || $2 || $3)
    end
    if img_tag =~ /\bdata-src=(?:"([^"]+)"|'([^']+)'|([^\s>]+))/i
      srcs << ($1 || $2 || $3)
    end
  end
  srcs.uniq
end

# Verify if a local path resolves to a file or directory/index.html inside PUBLIC_DIR
def local_target_exists?(url_path, page_file)
  clean = url_path.split('?').first.split('#').first
  return true if clean.nil? || clean.empty?

  target = if clean.start_with?('/')
             File.join(PUBLIC_DIR, clean)
           else
             File.expand_path(clean, File.dirname(page_file))
           end

  File.file?(target) || File.file?(File.join(target, 'index.html'))
end

puts "\n\e[1;36m=== 1. Root & Language Homepages Existence ===\e[0m"
root_index = File.join(PUBLIC_DIR, 'index.html')
en_home    = File.join(PUBLIC_DIR, 'en/index.html')
it_home    = File.join(PUBLIC_DIR, 'it/index.html')
en_about   = File.join(PUBLIC_DIR, 'en/about/index.html')
it_about   = File.join(PUBLIC_DIR, 'it/about/index.html')

assert_test('Root public/index.html exists and redirects to /en/', File.file?(root_index) && File.read(root_index).include?('/en/'))
assert_test('English homepage (public/en/index.html) exists', File.file?(en_home) && File.size(en_home) > 1000)
assert_test('Italian homepage (public/it/index.html) exists', File.file?(it_home) && File.size(it_home) > 1000)
assert_test('English About page (public/en/about/index.html) exists', File.file?(en_about) && File.size(en_about) > 1000)
assert_test('Italian About page (public/it/about/index.html) exists', File.file?(it_about) && File.size(it_about) > 1000)

en_html = File.file?(en_home) ? File.read(en_home) : ''
it_html = File.file?(it_home) ? File.read(it_home) : ''
en_about_html = File.file?(en_about) ? File.read(en_about) : ''
it_about_html = File.file?(it_about) ? File.read(it_about) : ''

en_hrefs = extract_anchor_hrefs(en_html)
it_hrefs = extract_anchor_hrefs(it_html)

puts "\n\e[1;36m=== 2. Apps Portfolio Links (💼 Portfolio) ===\e[0m"
[
  ['EN Homepage (public/en/index.html)', en_html, en_hrefs],
  ['IT Homepage (public/it/index.html)', it_html, it_hrefs]
].each do |label, html, hrefs|
  assert_test(
    "#{label}: links to Apps Portfolio (#{PORTFOLIO_URL})",
    hrefs.include?(PORTFOLIO_URL),
    "Missing href='#{PORTFOLIO_URL}'"
  )
  assert_test(
    "#{label}: has Desktop Navbar Portfolio button (navbar__menu-item--portfolio)",
    html.include?('navbar__menu-item--portfolio') && html.include?(PORTFOLIO_URL),
    'Missing navbar__menu-item--portfolio class in desktop navbar'
  )
  assert_test(
    "#{label}: has Mobile Navbar Portfolio item (navbarm__menu--item--portfolio)",
    html.include?('navbarm__menu--item--portfolio'),
    'Missing navbarm__menu--item--portfolio class in mobile navbar'
  )
end

assert_test(
  'EN About page (public/en/about/index.html): links to Apps Portfolio',
  extract_anchor_hrefs(en_about_html).include?(PORTFOLIO_URL),
  "Missing #{PORTFOLIO_URL} in EN About page"
)
assert_test(
  'IT About page (public/it/about/index.html): links to Apps Portfolio',
  extract_anchor_hrefs(it_about_html).include?(PORTFOLIO_URL),
  "Missing #{PORTFOLIO_URL} in IT About page"
)

puts "\n\e[1;36m=== 3. Curriculum Vitae (CV) Links (EN & IT + Static Artifacts) ===\e[0m"
REQUIRED_CV_LINKS = {
  '/cv/ricc-onepager.pdf'    => 'English 1-Pager CV (PDF)',
  '/cv/ricc-onepager-it.pdf' => 'Italian 1-Pager CV (PDF)',
  '/cv/ricc-cv.pdf'          => 'English Full CV (PDF)',
  '/cv/ricc-cv-it.pdf'       => 'Italian Full CV (PDF)',
  '/cv/'                     => 'Extended Interactive CV (HTML)'
}.freeze

[
  ['EN Homepage', en_hrefs],
  ['IT Homepage', it_hrefs]
].each do |label, hrefs|
  REQUIRED_CV_LINKS.each do |cv_url, cv_desc|
    assert_test(
      "#{label}: links to #{cv_desc} (#{cv_url})",
      hrefs.include?(cv_url),
      "Missing link to #{cv_url} in #{label}"
    )
  end

  # Ensure relLangURL bug does NOT produce broken /en/cv/* or /it/cv/* links
  broken_lang_cv = hrefs.select { |h| h =~ %r{\A/(?:en|it|de|fr|jp)/cv/} }
  assert_test(
    "#{label}: has NO broken language-prefixed CV links (/en/cv/* or /it/cv/*)",
    broken_lang_cv.empty?,
    "Found broken language-prefixed CV links: #{broken_lang_cv.join(', ')}"
  )
end

# Verify CV files on disk in public/cv/
CV_ARTIFACTS = {
  'cv/ricc-onepager.pdf'    => 10_000,
  'cv/ricc-onepager-it.pdf' => 10_000,
  'cv/ricc-cv.pdf'          => 10_000,
  'cv/ricc-cv-it.pdf'       => 10_000,
  'cv/index.html'           => 5_000,
  'cv/ricc-onepager.html'   => 5_000,
  'cv/ricc-onepager-it.html'=> 5_000
}.freeze

CV_ARTIFACTS.each do |rel_path, min_bytes|
  full_path = File.join(PUBLIC_DIR, rel_path)
  exists_and_valid = File.file?(full_path) && File.size(full_path) >= min_bytes
  actual_size = File.file?(full_path) ? File.size(full_path) : 0
  assert_test(
    "Static CV artifact public/#{rel_path} exists and >= #{min_bytes} bytes (got #{actual_size} B)",
    exists_and_valid,
    "Missing or truncated file: #{full_path}"
  )
end

puts "\n\e[1;36m=== 4. Social & Author Identity Links (Sidebar Bio & Footer) ===\e[0m"
REQUIRED_SOCIAL_LINKS = {
  'GitHub'        => ->(hrefs) { hrefs.include?('https://github.com/palladius/') || hrefs.include?('https://github.com/palladius') },
  'LinkedIn'      => ->(hrefs) { hrefs.include?('https://www.linkedin.com/in/riccardocarlesso/') },
  'YouTube'       => ->(hrefs) { hrefs.include?('https://www.youtube.com/palladiusbonton') },
  'Medium'        => ->(hrefs) { hrefs.include?('https://medium.com/@palladiusbonton') },
  'StackOverflow' => ->(hrefs) { hrefs.include?('https://stackoverflow.com/users/362420/riccardo') },
  'Twitter/X'     => ->(hrefs) { hrefs.include?('https://twitter.com/palladius') },
  'Instagram'     => ->(hrefs) { hrefs.include?('https://www.instagram.com/palladius/') },
  'Email'         => ->(hrefs) { hrefs.include?('mailto:palladiusbonton@gmail.com') }
}.freeze

[
  ['EN Homepage', en_hrefs],
  ['IT Homepage', it_hrefs]
].each do |label, hrefs|
  REQUIRED_SOCIAL_LINKS.each do |network, matcher|
    assert_test(
      "#{label}: contains #{network} profile link",
      matcher.call(hrefs),
      "Missing #{network} link in #{label}"
    )
  end
end

avatar_file = File.join(PUBLIC_DIR, 'images/ricc-logo.png')
assert_test(
  'Bio Avatar image (/images/ricc-logo.png) is referenced on homepage and exists in public/',
  en_html.include?('/images/ricc-logo.png') && File.file?(avatar_file),
  'Missing /images/ricc-logo.png in HTML or public/images/'
)

puts "\n\e[1;36m=== 5. Core Navigation, Feeds, Search Index & Repo Attribution ===\e[0m"
['about', 'archive', 'gallery', 'posts'].each do |section|
  assert_test("EN Homepage: has /en/#{section} navigation link", en_hrefs.include?("/en/#{section}"))
end
assert_test('IT Homepage: has /it/about navigation link', it_hrefs.include?('/it/about'))
assert_test('IT Homepage: has /it/archive navigation link', it_hrefs.include?('/it/archive'))
assert_test('IT Homepage: has working Gallery link (/en/gallery or /it/gallery)', it_hrefs.include?('/en/gallery') || it_hrefs.include?('/it/gallery'))
assert_test('IT Homepage: has working Posts link (/en/posts or /it/posts)', it_hrefs.include?('/en/posts') || it_hrefs.include?('/it/posts'))

assert_test('EN Homepage: links to RSS feed (https://ricc.rocks/en/index.xml)', en_hrefs.include?('https://ricc.rocks/en/index.xml') && File.file?(File.join(PUBLIC_DIR, 'en/index.xml')))
assert_test('IT Homepage: links to RSS feed (https://ricc.rocks/it/index.xml)', it_hrefs.include?('https://ricc.rocks/it/index.xml') && File.file?(File.join(PUBLIC_DIR, 'it/index.xml')))
assert_test('Search JSON indexes exist (public/en/index.json & public/it/index.json)', File.file?(File.join(PUBLIC_DIR, 'en/index.json')) && File.file?(File.join(PUBLIC_DIR, 'it/index.json')))
assert_test('Footer links to source repository (https://github.com/palladius/ricc.rocks)', en_hrefs.include?('https://github.com/palladius/ricc.rocks') && it_hrefs.include?('https://github.com/palladius/ricc.rocks'))

puts "\n\e[1;36m=== 6. Zero Broken Local Links & Zero Unrendered Shortcodes ===\e[0m"
[
  ['EN Homepage (public/en/index.html)', en_home, en_html, en_hrefs],
  ['IT Homepage (public/it/index.html)', it_home, it_html, it_hrefs],
  ['EN About Page (public/en/about/index.html)', en_about, en_about_html, extract_anchor_hrefs(en_about_html)],
  ['IT About Page (public/it/about/index.html)', it_about, it_about_html, extract_anchor_hrefs(it_about_html)]
].each do |label, file_path, html, hrefs|
  local_hrefs = hrefs.reject { |h| h.start_with?('http://', 'https://', 'mailto:', 'tel:', 'javascript:', '#', '//') }
  broken_hrefs = local_hrefs.reject { |h| local_target_exists?(h, file_path) }
  assert_test(
    "#{label}: all #{local_hrefs.size} local <a href> links resolve to existing files in public/",
    broken_hrefs.empty?,
    "Broken local links: #{broken_hrefs.join(', ')}"
  )

  img_srcs = extract_img_srcs(html).reject { |s| s.start_with?('http://', 'https://', 'data:', '//') }
  broken_imgs = img_srcs.reject { |s| local_target_exists?(s, file_path) }
  assert_test(
    "#{label}: all #{img_srcs.size} local <img> sources resolve to existing files in public/",
    broken_imgs.empty?,
    "Broken local images: #{broken_imgs.join(', ')}"
  )

  leaked_shortcode = html =~ /\{\{\s*[<%]|\{\s+\{\s*</
  assert_test(
    "#{label}: contains zero unrendered/broken Hugo shortcodes",
    !leaked_shortcode,
    'Found raw Hugo shortcode syntax in rendered HTML'
  )
end

puts "\n" + ('-' * 60)
if $failed.zero?
  puts "\e[1;32m✅ All #{$passed} homepage & essential link tests passed!\e[0m"
  exit(0)
else
  puts "\e[1;31m❌ #{$failed} test(s) failed (#{$passed} passed):\e[0m"
  $failures.each { |f| puts "  - #{f}" }
  exit(1)
end
