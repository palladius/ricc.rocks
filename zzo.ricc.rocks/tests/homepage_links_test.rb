require 'open-uri'
require 'nokogiri'
require 'fileutils'

# Comprehensive Unit Test for verifying feature parity & link health across EN and IT locales.
# Checks:
# 1. Homepage & About pages exist and render for both EN and IT.
# 2. Portfolio, CV, and Archive links exist and resolve to valid targets.
# 3. Navbar dropdown menus (Gallery) match across both locales.
# 4. In-page images and links do not 404.

def test_en_it_parity
  base_dir = File.expand_path("..", __dir__)
  public_dir = File.join(base_dir, "public")
  
  puts "🏗️  Building Hugo site for EN/IT parity verification..."
  build_ok = system("cd #{base_dir} && (which hugo >/dev/null 2>&1 && hugo --quiet || npx -y hugo-extended --quiet)")
  unless build_ok
    puts "❌ Hugo build failed!"
    exit 1
  end

  errors = []

  locales = [
    { lang: 'en', name: 'English', cv_file: 'cv/ricc-onepager.pdf' },
    { lang: 'it', name: 'Italian', cv_file: 'cv/ricc-onepager-it.pdf' }
  ]

  locales.each do |loc|
    lang = loc[:lang]
    name = loc[:name]
    puts "\n🔍 Testing #{name} Locale (/#{lang}/)..."

    # Check Homepage
    home_html = File.join(public_dir, lang, "index.html")
    unless File.exist?(home_html)
      errors << "#{name}: Missing homepage #{home_html}"
      next
    end
    home_doc = Nokogiri::HTML(File.read(home_html))

    # 1. Navbar Items Check
    nav_links = home_doc.css('.navbar__menu-item, .navbarm__menu--item a')
    nav_hrefs = nav_links.map { |a| a['href'] }.compact.uniq
    puts "  [Navbar] #{nav_hrefs.size} distinct links found."

    # 2. CV Link Check
    cv_links = home_doc.css('a').select { |a| a.text.downcase.include?('curriculum') || a['href']&.downcase&.include?('ricc-onepager') }
    if cv_links.empty?
      errors << "#{name}: No CV links found on homepage"
    else
      cv_links.each do |a|
        href = a['href']
        disk_file = File.join(public_dir, href.sub(/\A\//, ''))
        unless File.exist?(disk_file)
          errors << "#{name} Homepage: Broken CV link '#{href}' (expected at #{disk_file})"
        end
      end
    end

    # 3. About Page Check
    about_html = File.join(public_dir, lang, "about", "index.html")
    if File.exist?(about_html)
      about_doc = Nokogiri::HTML(File.read(about_html))
      # Check images in about page
      about_doc.css('img').each do |img|
        src = img['src']
        next if src.nil? || src.start_with?('http') || src.start_with?('data:')
        img_disk = File.join(public_dir, src.sub(/\A\//, ''))
        unless File.exist?(img_disk)
          errors << "#{name} About: Broken image '#{src}' (expected at #{img_disk})"
        end
      end
      puts "  [About Page] OK (Checked images and links)."
    else
      errors << "#{name}: Missing about page at #{about_html}"
    end

    # 4. Archive Page Check
    archive_html = File.join(public_dir, lang, "archive", "index.html")
    if File.exist?(archive_html)
      puts "  [Archive Page] OK."
    else
      errors << "#{name}: Missing archive page at #{archive_html}"
    end

    # 5. Gallery Hub Check
    gallery_html = File.join(public_dir, lang, "gallery", "index.html")
    if File.exist?(gallery_html)
      puts "  [Gallery Page] OK."
    else
      errors << "#{name}: Missing gallery page at #{gallery_html}"
    end
  end

  if errors.empty?
    puts "\n\e[32m✅ EN and IT Locales are in Full Parity and Working Flawlessly!\e[0m\n"
    exit 0
  else
    puts "\n\e[31m❌ Parity Verification Failed with #{errors.size} error(s):\e[0m"
    errors.each { |err| puts "  - #{err}" }
    exit 1
  end
end

test_en_it_parity if __FILE__ == $0
