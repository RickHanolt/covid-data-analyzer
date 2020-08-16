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

  def state_scraper
    doc = Nokogiri::HTML(open('https://covidtracking.com/data'))
    states = {}
    doc.css("div.state-list-module--item--3j9Qs").each do |state|
      current_state = state.css("a").first.text
      states[:"#{current_state}"] = {}
      counter = 0
      state.css("td.table-module--align-left--Ya6ae").each do |data_point|
        if counter == 0
          states[current_state.to_sym][:cases] = data_point.text
        elsif counter == 1
          states[current_state.to_sym][:negative_tests] = data_point.text
        elsif counter == 2
          states[current_state.to_sym][:pending_tests] = data_point.text
        elsif counter == 3
          states[current_state.to_sym][:currently_hospitalized] = data_point.text
        elsif counter == 4
          states[current_state.to_sym][:cumulitive_hospitalized] = data_point.text
        elsif counter == 5
          states[current_state.to_sym][:current_icu] = data_point.text
        elsif counter == 6
          states[current_state.to_sym][:cumulitive_icu] = data_point.text
        elsif counter == 7
          states[current_state.to_sym][:current_ventilator] = data_point.text
        elsif counter == 8
          states[current_state.to_sym][:cumulitive_ventilator] = data_point.text
        elsif counter == 9
          states[current_state.to_sym][:recovered] = data_point.text
        elsif counter == 10
          states[current_state.to_sym][:deaths] = data_point.text
        elsif counter == 11
          states[current_state.to_sym][:total_test_results] = data_point.text
        else
        end
        counter += 1
      end
    end
    states
  end

  def self.historical_data
    doc = Nokogiri::HTML(open("https://apps.npr.org/dailygraphics/graphics/coronavirus-d3-us-map-20200312/table.html?initialWidth=1218&childId=responsive-embed-coronavirus-d3-us-map-20200312-table&parentTitle=Coronavirus%20Update%3A%20Maps%20Of%20US%20Cases%20And%20Deaths%20%3A%20Shots%20-%20Health%20News%20%3A%20NPR&parentUrl=https%3A%2F%2Fwww.npr.org%2Fsections%2Fhealth-shots%2F2020%2F03%2F16%2F816707182%2Fmap-tracking-the-spread-of-the-coronavirus-in-the-u-s
    "))
    state = doc.css('div.div-table')
  end

end

#state_abbreviations = ["AL", "AK", "AS", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL", "GA", "GU", "HI", "ID", "IL", "IN",
#                        "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM",
#                         "NY", "NC", "ND", "MP", "OH", "OK", "OR", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "VI", "UT", "VT",
#                          "VA", "WA", "WV", "WI", "WY"]
