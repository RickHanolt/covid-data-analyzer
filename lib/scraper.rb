require 'pry'
require 'nokogiri'
require 'open-uri'

class Scraper

  def jhu_state_links
    doc = Nokogiri::HTML(open('https://coronavirus.jhu.edu/data/new-cases-50-states'))
    states = []
    base = 'https://coronavirus.jhu.edu'
    doc.css('g.cartesianlayer g g.plot').each do |state|
      states << base + (state.css('a').attr('href').value)
    end
  end

end
