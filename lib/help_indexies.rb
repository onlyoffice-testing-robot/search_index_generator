require 'json'
require 'nokogiri'

folder = ARGV[1] || '/home/lobashov/sources/web-apps-pro/apps/documenteditor/main/resources/help/ru'

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

results = "[\n"
file_list(folder).each do |file|
  file_data = {}
  file_data['id'] = file
  file_data['title'] = get_title(file)
  file_data['body'] = get_body(file)
  results << JSON.pretty_generate(file_data) + ", \n"
end
results = results.chomp.chop.chop
results << ']'

output = File.open('result.json', 'w')
output << results
output.close
