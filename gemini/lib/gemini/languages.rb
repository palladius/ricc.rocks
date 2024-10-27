
LanguageData = [
    { code: 'de', name: 'German', emoji: '🇩🇪' },
    { code: 'en', name: 'English', emoji: '🇬🇧' },
    { code: 'es', name: 'Spanish', emoji: '🇪🇸' },
    { code: 'fr', name: 'French', emoji: '🇫🇷' },
    { code: 'it', name: 'Italian', emoji: '🇮🇹' },
    { code: 'jp', name: 'Japanese', emoji: '🇯🇵' }
  ]

  # TODO add nice raise as below
def get_language_name(lang_code:)
  #puts("DEB lang_code=#{lang_code}")
  LanguageData.find { |lang| lang[:code] == lang_code }[:name]
end

def get_language_emoji(lang_code:)
  LanguageData.find { |lang| lang[:code] == lang_code }[:emoji]
end

# def short_lang_to_long(lang:)
#   return 'German' if lang == 'de'
#   return 'English' if lang == 'en'
#   return 'French' if lang == 'fr'
#   return 'Italian' if lang == 'it'
#   return 'Japanese' if lang == 'jp'
#   raise "Unknown language: #{lang}"
# end
