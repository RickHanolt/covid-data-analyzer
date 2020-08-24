require 'pry'
require 'nokogiri'
require 'open-uri'
require 'httparty'

class Scraper

  def jhu_state_link_scraper(input_state)
    doc = Nokogiri::HTML(open('https://coronavirus.jhu.edu/data/new-cases-50-states'))
    state_link = ""
    base = 'https://coronavirus.jhu.edu'
    doc.css('g.plot a').each do |state|
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

  def covid_tracking_api_last_3_weeks(input_state)
    state_abbreviation = @@all_states.find{|state| state[1] == input_state}[0]

    ## These variables convert date to yyyymmdd format.
    ## current_date = Date.today.strftime.tr('-','').to_i ##yyyymmdd format
    ## one_week_ago = (Date.today - 7).strftime.tr('-','').to_i
    ## two_weeks_ago = (Date.today - 14).strftime.tr('-','').to_i
    ## yesterday = (Date.today - 1).strftime.tr('-','').to_i
    ## eight_days_ago = (Date.today - 8).strftime.tr('-','').to_i
    ## fifteen_days_ago = (Date.today - 15).strftime.tr('-','').to_i

    url = 'https://api.covidtracking.com/v1/states/daily.json'
    response = HTTParty.get(url)
    response = response.parsed_response
    response = response.select{|data_set| data_set['state'] == state_abbreviation}
    pop_size = response.count - 21
    response.pop(pop_size)
    response
  end

  @@all_states = [["AK", "Alaska"],
                ["AL", "Alabama"],
                ["AR", "Arkansas"],
                ["AS", "American Samoa"],
                ["AZ", "Arizona"],
                ["CA", "California"],
                ["CO", "Colorado"],
                ["CT", "Connecticut"],
                ["DC", "District of Columbia"],
                ["DE", "Delaware"],
                ["FL", "Florida"],
                ["GA", "Georgia"],
                ["GU", "Guam"],
                ["HI", "Hawaii"],
                ["IA", "Iowa"],
                ["ID", "Idaho"],
                ["IL", "Illinois"],
                ["IN", "Indiana"],
                ["KS", "Kansas"],
                ["KY", "Kentucky"],
                ["LA", "Louisiana"],
                ["MA", "Massachusetts"],
                ["MD", "Maryland"],
                ["ME", "Maine"],
                ["MI", "Michigan"],
                ["MN", "Minnesota"],
                ["MO", "Missouri"],
                ["MS", "Mississippi"],
                ["MT", "Montana"],
                ["NC", "North Carolina"],
                ["ND", "North Dakota"],
                ["NE", "Nebraska"],
                ["NH", "New Hampshire"],
                ["NJ", "New Jersey"],
                ["NM", "New Mexico"],
                ["NV", "Nevada"],
                ["NY", "New York"],
                ["OH", "Ohio"],
                ["OK", "Oklahoma"],
                ["OR", "Oregon"],
                ["PA", "Pennsylvania"],
                ["PR", "Puerto Rico"],
                ["RI", "Rhode Island"],
                ["SC", "South Carolina"],
                ["SD", "South Dakota"],
                ["TN", "Tennessee"],
                ["TX", "Texas"],
                ["UT", "Utah"],
                ["VA", "Virginia"],
                ["VI", "Virgin Islands"],
                ["VT", "Vermont"],
                ["WA", "Washington"],
                ["WI", "Wisconsin"],
                ["WV", "West Virginia"],
                ["WY", "Wyoming"] ]
end
