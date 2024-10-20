=begin

  Gemini Translator To-be class.

=end
require 'rainbow'
require 'pry'

def llm
  Langchain.logger.level = Logger::INFO

  Langchain::LLM::GoogleGemini.new(
    api_key: ENV["GEMINI_API_KEY"],
    default_options: {
      #temperature: 0.7,
      chat_completion_model_name: "gemini-1.5-pro"
    }
  )
end

def short_lang_to_long(lang:)
  return 'Italian' if lang == 'it'
  return 'English' if lang == 'en'
  return 'French' if lang == 'fr'
  raise "Unknown language: #{lang}"
end

def translate_with_gemini(file_name:, extension:, lang:, output_file: , overwrite: false)
  prompt_version = '1.0'
  puts(Rainbow("WARNING! overwrite is TRUE! Gemini will now overwrite markdown file #{output_file}!!").red) if overwrite
  markdown_content = File.read(file_name)
  comment_ad_minchiam = "translate_with_gemini(file_name: #{file_name}, extension: #{extension}, lang: #{lang}). MD_content: #{markdown_content.length/1024}KB. prompt_version=#{prompt_version}"

  prompt = Langchain::Prompt::PromptTemplate.new(
    template:File.read('etc/prompts/translate-to-another-language.prompt'),
    input_variables: ["full_name", "language", "original_content"]
  )

  formatted_prompt = prompt.format(
    original_content: markdown_content,
    language: short_lang_to_long(lang: ),
    full_name: 'Dr Riccardo Carlesso',
    )

  #puts(formatted_prompt)

#  binding.pry # .capture do

  messages = [
    #{ role: "system", content: "You are a formatted_promptul assistant." },
    { role: "user", parts: [{ text: formatted_prompt }]}
  ]
  response = llm.chat(messages: messages)

  #binding.pry

  gemini_output =  "# #{comment_ad_minchiam}\n\n#{response.chat_completion}" # + response

  # Write the modified content back to the output file
  puts("Writing MD to #{output_file}..")
  ret = File.write(output_file, gemini_output)
  return ret

end
