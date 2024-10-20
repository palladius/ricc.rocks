#!/usr/bin/env ruby

require 'rainbow'
require 'langchain'
require 'net/http'

puts 'todo'

llm = Langchain::LLM::GoogleGemini.new(
  api_key: ENV["GEMINI_API_KEY"],
  default_options: {
    #temperature: 0.7,
    chat_completion_model_name: "gemini-1.5-pro"
  }
)

Langchain.logger.level = Logger::INFO

puts(llm)
# response = llm.embed(text: "Hello, world!")
# embedding = response.embedding
# puts(embedding)

# prompt = Langchain::Prompt::PromptTemplate.new(template: "Tell me a {adjective} joke about {content}.", input_variables: ["adjective", "content"])
# prompt.format(adjective: "funny", content: "chickens")
# puts(prompt.to_s)

prompt = Langchain::Prompt::PromptTemplate.new(
  template:File.read('etc/prompts/translate-to-italian.prompt'),
  input_variables: ["full_name", "language", "original_content"]
#  input_variables: [ "original_content"]
  )

pf = prompt.format(
  original_content: "funny chickens",
  language: 'French',
  full_name: 'Dr Riccardo Carlesso'
  )
puts(pf)
