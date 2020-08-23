require 'pry'

class State
attr_reader :data, :name, :population, :cases, :negative_tests, :pending_tests, :currently_hospitalized, :cumulitive_hospitalized, :current_icu, :cumulitive_icu, :current_ventilator, :cumulitive_ventilator, :recovered, :deaths, :total_test_results, :avg_case_3wk, :avg_case_2wk, :avg_case_1wk, :avg_case_current

@@all = []

  def initialize(state)
    @name = state
    temp_scraper = Scraper.new
    @population = temp_scraper.state_population(state)
    current_data(state)
    historical_cases(state)
    @@all << self
  end

  def self.all
    @@all
  end

  def historical_cases(state)
    counter = 0
    temp_scraper = Scraper.new
    temp_scraper.historical_case_scraper(state).each do |time_frame|
      if counter == 0
        @avg_case_3wk = time_frame
      elsif counter == 1
        @avg_case_2wk = time_frame
      elsif counter == 2
        @avg_case_1wk = time_frame
      elsif counter == 3
        @avg_case_current = time_frame
      end
      counter += 1
    end
  end

  def current_data(state)
    counter = 0
    temp_scraper = Scraper.new
    temp_scraper.state_scraper(state).each do |data_point|
      if counter == 0
        @cases = data_point
      elsif counter == 1
        @negative_tests = data_point
      elsif counter == 2
        @pending_tests = data_point
      elsif counter == 3
        @currently_hospitalized = data_point
      elsif counter == 4
        @cumulitive_hospitalized = data_point
      elsif counter == 5
        @current_icu = data_point
      elsif counter == 6
        @cumulitive_icu = data_point
      elsif counter == 7
        @current_ventilator = data_point
      elsif counter == 8
        @cumulitive_ventilator = data_point
      elsif counter == 9
        @recovered = data_point
      elsif counter == 10
        @deaths = data_point
      elsif counter == 11
        @total_test_results = data_point
      end
      counter += 1
    end
  end

end
