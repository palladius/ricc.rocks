# I want create a smart debug function in ruby, called def debf(str).
# It should print some debug string plus the name of the function calling 'debf()'.
# For example: within my_func(), a debf('blah') should print:

# def my_func(..)
#   debf('blah')
# end
# # =>  "my_func(): blah"

# Can you help me write this function?

CLASSES_EXPLAINATION = {
  work: '💼 Google and work (something that might go to linkedin wihtout you getting embarassed)',
  blog: '🕸️🧑🏻‍💻 Something personal, like Spag Bol should exist or not? Could go on personal blog, FB and occasionally LI',
  dunno_yet: '🤷‍♂️ not set (think NIL)',
  family: '🤰🧑‍🧑‍🧒‍🧒 Family oriented. Can go on a Blog but its somewhat more private.',
  all: '☯️ All of them. Welcome to Asia!'
}
# Classes can be:
# - WORK -
# - BLoG
# - WORK
# - WORK

def classify_article(file:, front_matter:)
  #front_matter, body = parse_frontmatter(file) # rescue [{ruby_error: $!}, 'nil']
  #debf("FM keys: #{front_matter.keys.count} / BoydCount: #{body.size}")
  #puts("Class: #{front_matter.class}")
  # if front_matter.is_a? Array # array?
  #   puts front_matter[1].inspect
  # end
  # if front_matter.has_key?('carlessian') # and front_matter['carlessian'].has_key? "main_class"
  #   puts("1. Carlessian detected!")
  # end
  if front_matter.has_key?('carlessian') and front_matter['carlessian'].has_key? "main_class"
    carlessian_value = front_matter['carlessian']["main_class"]
    debf "👋🏽 Auto-detected carlessian class found: #{carlessian_value} for #{file}"
    #print(carlessian_value)
    return carlessian_value
  end

  # invent - from file
  debf("carlessian value not found - I'll jave to do with file regex.. I know it sucks. Let me do some regexing now..")
  return 'work' if file =~ /posts.*medium/

  return :dunno_yet
end

#
def aruspicami(file:)
  debf("file: #{file}")

  front_matter, body = parse_frontmatter(file) # rescue [{ruby_error: $!}, 'nil']
  debf("FM keys: #{front_matter.keys.count} / BoydCount: #{body.size}")

  priority = front_matter['carlessian']['priority'] rescue 6   # priority       1..10
  completion = (front_matter['carlessian'] || {}).fetch 'completion', 97  # completion pct 1..100
  title = front_matter.fetch 'title', '⛔️'
  draft = front_matter.fetch 'draft', 'false'

  # Now lets detect everything we can about the file...
  article_class = classify_article(file:, front_matter:)
  class_explaination = '⛔️'
  if CLASSES_EXPLAINATION.key?(article_class.to_sym)
    class_explaination = CLASSES_EXPLAINATION[article_class.to_sym]
  end

  return {
    article_class: ,
    class_explaination: ,
    emoji: class_explaination[0],
    priority:,
    completion: ,
    title:,
    draft:,
  }
end


def print_fancy_file_stats(file:, file_stats:, verbose: false)
  completion = file_stats[:completion]
  priority = file_stats[:priority]
  title = file_stats[:title]
  draft = file_stats[:draft]
  draftmoji = draft.to_s == 'true' ? '📂' : '🗂️'   # 📂💾🗂️✅ 🟩
  classmoji = file_stats[:emoji]
  str = "#{draftmoji} #{completion.to_s.rjust(3, ' ')}% P#{priority} #{classmoji} #{Rainbow(file).cyan}: '#{Rainbow(title).yellow}'"
  str += "#{file_stats}" if verbose
  puts(str)
end
