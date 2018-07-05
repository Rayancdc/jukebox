require "open-uri"
require "nokogiri"

def scrape_youtube(track_name)
  url = "https://www.youtube.com/results?search_query=" + track_name.downcase.split.join("+")
  html_file = open(url).read
  html_doc = Nokogiri::HTML(html_file)

  link = html_doc.search('h3 a').attribute('href').text
end

def generate_embed_url(path)
  str = path.scan(/=(.+)/).join
  url = "https://www.youtube.com/embed/#{str}?controls=0"
end
