require 'open-uri'
require 'nokogiri'
require 'fileutils'

# Unit test for checking important homepage links in ricc.rocks (EN & IT).
# Verifies that:
# 1. Apps Portfolio link is present and points to valid URL.
# 2. CV EN and IT links in navbar/footer exist as physical static files in public/ and are not 404 broken links.

def test_homepage_links
  base_dir = File.expand_path("..", __dir__)
  public_dir = File.join(base_dir, "public")
  
  # Ensure Hugo build is fresh
  puts "🏗️  Building Hugo site for homepage links testing..."
  build_ok = system("cd #{base_dir} && (which hugo >/dev/null 2>&1 && hugo --quiet || npx -y hugo-extended --quiet)")
  unless build_ok
    puts "❌ Hugo build failed!"
    exit 1
  end

  errors = []
  
  pages_to_check = {
    "English Homepage" => {
      html_file: File.join(public_dir, "en", "index.html"),
      cv_expected_file: "cv/ricc-onepager.pdf"
    },
    "Italian Homepage" => {
      html_file: File.join(public_dir, "it", "index.html"),
      cv_expected_file: "cv/ricc-onepager-it.pdf"
    }
  }

  pages_to_check.each do |page_name, info|
    puts "\n🔍 Testing #{page_name} (#{info[:html_file]})..."
    unless File.exist?(info[:html_file])
      errors << "#{page_name}: HTML file not found at #{info[:html_file]}"
      next
    end

    doc = Nokogiri::HTML(File.read(info[:html_file]))

    # 1. Check Apps Portfolio Link
    portfolio_links = doc.css('a').select { |a| a.text.downcase.include?('portfolio') || a['href']&.include?('portfolio') }
    if portfolio_links.empty?
      errors << "#{page_name}: No portfolio link found on page"
    else
      portfolio_links.each do |link|
        href = link['href']
        puts "  Found portfolio link: #{href}"
        if href.nil? || href.strip.empty?
          errors << "#{page_name}: Empty portfolio href"
        end
      end
    end

    # 2. Check CV Links (Navbar and elsewhere)
    cv_links = doc.css('a').select { |a| a.text.downcase.include?('curriculum') || a['href']&.downcase&.include?('ricc-onepager') }
    if cv_links.empty?
      errors << "#{page_name}: No CV link found on page"
    else
      cv_links.each do |link|
        href = link['href']
        puts "  Found CV link: #{href} (text: '#{link.text.strip}')"
        
        # Test if href points to an actual file on disk
        # href could be e.g. "/cv/ricc-onepager.pdf", "/en/cv/ricc-onepager.pdf", etc.
        relative_path = href.sub(/\A\//, '')
        target_file = File.join(public_dir, relative_path)
        
        unless File.exist?(target_file)
          errors << "#{page_name}: Broken CV link '#{href}'! File does not exist on disk at '#{target_file}'"
        end
      end
    end
  end

  if errors.empty?
    puts "\n\e[32m✅ All Homepage Links Unit Tests Passed!\e[0m\n"
    exit 0
  else
    puts "\n\e[31m❌ Homepage Links Unit Test Failed with #{errors.size} error(s):\e[0m"
    errors.each { |err| puts "  - #{err}" }
    exit 1
  end
end

test_homepage_links if __FILE__ == $0
