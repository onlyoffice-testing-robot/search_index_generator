# frozen_string_literal: true

require 'json'
require 'nokogiri'

folder = ARGV[0]
output = ARGV[1] || 'result.json'

def file_list(folder)
  Dir["#{folder}/**/*.htm*"].sort
end

def get_title(file)
  data = Nokogiri::HTML(File.read(file))
  data.search('//h1').first.text
end

def get_body(file)
  data = Nokogiri::HTML(File.read(file))
  body = data.xpath('//body')
  body.search('h1').remove
  text_dirty = body.to_s.gsub(/<\/?[^>]*>/, '')
  text_dirty.split.join(' ')
end

def format_out(results)
  json = results.to_json
  out = JSON.parse(json)
  JSON.pretty_generate(out)
end

results = []
file_list(folder).each do |file|
  file_data = {}
  file_data['id'] = file
  file_data['title'] = get_title(file)
  file_data['body'] = get_body(file)
  results << file_data
end

output = File.open(output, 'w')
output << format_out(results)
output.close
