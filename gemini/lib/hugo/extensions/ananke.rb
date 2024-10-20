=begin

 FrontMatter:
 * use featured_image = '/images/gohugo-default-sample-hero-image.jpg'
 * toc: true
 * omit_header_text: true
 * background_color_class = "bg-blue"

 Sample siteS:
 * https://github.com/theNewDynamic/gohugo-theme-ananke/tree/main/exampleSite

=end
class Hugo::FrontMatter::AnankeTheme


  def creation_prompt(toc: true, bg_color: 'blue', omit_header_text: false)
    "You're a helpful Hugo Theme for Ananke validator. I want you to sanitize and include
    configurations that are typical of Ananke.

    Some confgiuration notes. Ensure that:
    - toc is #{toc}: `toc: #{toc}`
    - Background Color is #{bg_color}: `background_color_class = #{bg_color}`
    - Omit Header Text is #{omit_header_text}: `omit_header_text: #{omit_header_text}`
    - Configure read_more_copy: ` read_more_copy = \"Read more about this succulent entry\"`
    "
  end

  def example_sites
    [
      'https://github.com/theNewDynamic/gohugo-theme-ananke/tree/main/exampleSite'
    ]
  end

end
