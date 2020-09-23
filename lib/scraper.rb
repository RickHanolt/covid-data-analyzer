require 'pry'
require 'nokogiri'
require 'open-uri'
require 'httparty'

class Scraper

  @@api_data = {}

  def historical_case_scraper(input_state)
    doc = Nokogiri::HTML(open("https://apps.npr.org/dailygraphics/graphics/coronavirus-d3-us-map-20200312/table.html?initialWidth=1218&childId=responsive-embed-coronavirus-d3-us-map-20200312-table&parentTitle=Coronavirus%20Update%3A%20Maps%20Of%20US%20Cases%20And%20Deaths%20%3A%20Shots%20-%20Health%20News%20%3A%20NPR&parentUrl=https%3A%2F%2Fwww.npr.org%2Fsections%2Fhealth-shots%2F2020%2F03%2F16%2F816707182%2Fmap-tracking-the-spread-of-the-coronavirus-in-the-u-s
    "))
    historical_data = []
    doc.css('div.div-table div.cell-group.state').each do |state|
      location = state.css('div.cell.cell-inner.stateName').text.strip
      if location == input_state
        state.css('div.cell.sub-cell.week').each do |data_point|
            historical_data << data_point.text.strip
        end
      end
    end
    historical_data
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

  def state_abbreviation(input_state)
    @@all_states.find{|state| state[1] == input_state}[0]
  end

  def covid_tracking_api_last_3_weeks(input_state)

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
    response = response.select{|data_set| data_set['state'] == state_abbreviation(input_state)}
    pop_size = response.count - 21
    response.pop(pop_size)
    @@api_data[:"#{input_state}"] = response
    response
  end

  def api_data
    @@api_data
  end

  def most_recent_day_from_api(input_state)
    if api_data[:"#{input_state}"].find{|todays_data| todays_data[:date] == Date.today.strftime.tr('-','').to_i}
      most_recent_data = api_data[:"#{input_state}"].find{|todays_data| todays_data["date"] == Date.today.strftime.tr('-','').to_i}
    else
      most_recent_data = api_data[:"#{input_state}"].find{|todays_data| todays_data["date"] == (Date.today - 1).strftime.tr('-','').to_i}
    end
    most_recent_data
  end

  @@all_states = [["AK", "Alaska"],
              ["AL", "Alabama"],
              ["AR", "Arkansas"],
              ["AZ", "Arizona"],
              ["CA", "California"],
              ["CO", "Colorado"],
              ["CT", "Connecticut"],
              ["DE", "Delaware"],
              ["FL", "Florida"],
              ["GA", "Georgia"],
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
              ["RI", "Rhode Island"],
              ["SC", "South Carolina"],
              ["SD", "South Dakota"],
              ["TN", "Tennessee"],
              ["TX", "Texas"],
              ["UT", "Utah"],
              ["VA", "Virginia"],
              ["VT", "Vermont"],
              ["WA", "Washington"],
              ["WI", "Wisconsin"],
              ["WV", "West Virginia"],
              ["WY", "Wyoming"] ]
end
