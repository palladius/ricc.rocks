
=begin
  Currently used by ricc in his top blog page: ricc.rocks
  Not updated for 3 years -> i might ditch this one

  * GH: https://github.com/zzossig/hugo-theme-zzo
  * https://zzo-docs.vercel.app/zzo

  Front Matte: https://zzo-docs.vercel.app/zzo/userguide/subtitle/

  title:
  author: https://zzo-docs.vercel.app/zzo/userguide/author/

...
author: # author name
authorEmoji: 🤖 # emoji for subtitle, summary meta data
authorImage: "/images/whoami/avatar.jpg" # image path in the static folder
authorImageUrl: "" # your image url. We use `authorImageUrl` first. If not set, we use `authorImage`.
authorDesc: # author description
socialOptions: # override params.toml file socialOptions
  email: ""
  facebook: ""
  ...

   TOC: https://zzo-docs.vercel.app/zzo/userguide/tableofcontents/

enableToc: true
hideToc: false
tocFolding: true
tocPosition: "outer"
enableTocSwitch: true
tocLevels = ["h2", "h3", "h4"]
---

=end

class Hugo::FrontMatter::ZzoTheme < Hugo::FrontMatter::BaseTheme




  def example_sites
    [
      'https://github.com/zzossig/hugo-theme-zzo/tree/master/exampleSite'
    ]
  end

  def front_matter
    base = super()
    base[:ricc_overrideme] = 'ZZO override me'
    base[:ricc_ext_description] = 'ZZO is ricc favorite. Unfortunately it hasnt been updated since May 2021'

  end


end
