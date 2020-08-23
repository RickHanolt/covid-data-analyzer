require 'pry'
require 'nokogiri'
require 'open-uri'

class Scraper

  def jhu_state_link_scraper(input_state)
    doc = Nokogiri::HTML(open('https://coronavirus.jhu.edu/data/new-cases-50-states'))
    state_link = ""
    base = 'https://coronavirus.jhu.edu'
    doc.css('g.cartesianlayer g g.plot a').each do |state|
      state_link = base + state.attr('href') if state.attr('href').gsub(/\/data\/new-cases-50-states\//,"").capitalize == input_state
    end
    state_link
  end

  def state_scraper(input_state)
    doc = Nokogiri::HTML(open('https://covidtracking.com/data'))
    state_data = []
    doc.css("div.state-list-module--item--3j9Qs").each do |state|
      current_state = state.css("a").first.text
      if current_state == input_state
        state.css("td.table-module--align-left--Ya6ae").each do |data_point|
          state_data << data_point.text
        end
      end
    end
    state_data
  end

  def historical_case_scraper(input_state)
    doc = Nokogiri::HTML(open("https://apps.npr.org/dailygraphics/graphics/coronavirus-d3-us-map-20200312/table.html?initialWidth=1218&childId=responsive-embed-coronavirus-d3-us-map-20200312-table&parentTitle=Coronavirus%20Update%3A%20Maps%20Of%20US%20Cases%20And%20Deaths%20%3A%20Shots%20-%20Health%20News%20%3A%20NPR&parentUrl=https%3A%2F%2Fwww.npr.org%2Fsections%2Fhealth-shots%2F2020%2F03%2F16%2F816707182%2Fmap-tracking-the-spread-of-the-coronavirus-in-the-u-s
    "))
    state_data = []
    doc.css('div.div-table div.cell-group.state').each do |state|
      location = state.css('div.cell.cell-inner.stateName').text.strip
      if location == input_state
        state.css('div.cell.sub-cell.week').each do |data_point|
            state_data << data_point.text.strip
        end
      end
    end
    state_data
  end

  def state_population(input_state)
    doc = Nokogiri::HTML(open("https://www.infoplease.com/us/states/state-population-by-rank"))
    doc = doc.css("table.sgmltable tbody tr")
    current_state = ""
    population = ""
    doc[1..-1].each do |state|
        population = state.css("td")[2].text if state.css("td")[1].text == input_state
    end
    population
  end

end

#state_abbreviations = ["AL", "AK", "AS", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL", "GA", "GU", "HI", "ID", "IL", "IN",
#                        "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM",
#                         "NY", "NC", "ND", "MP", "OH", "OK", "OR", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "VI", "UT", "VT",
#                          "VA", "WA", "WV", "WI", "WY"]
