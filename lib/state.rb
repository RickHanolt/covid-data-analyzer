require 'pry'

class State
attr_reader :data, :name, :population, :cases, :negative_tests, :pending_tests, :currently_hospitalized, :cumulitive_hospitalized, :current_icu, :cumulitive_icu, :current_ventilator, :cumulitive_ventilator, :recovered, :deaths, :total_test_results, :avg_case_3wk, :avg_case_2wk, :avg_case_1wk, :avg_case_current, :state_link, :testing_avg_current, :testing_avg_last_week, :testing_avg_two_weeks_ago, :one_week_testing_change, :one_week_case_change

@@all = []

  def initialize(state)
    @name = state
    temp_scraper = Scraper.new
    temp_analyzer = Analyzer.new
    @population = temp_scraper.state_population(state)
    @testing_avg_current = temp_analyzer.seven_day_testing_average(state)[0]
    @testing_avg_last_week = temp_analyzer.seven_day_testing_average(state)[1]
    @testing_avg_two_weeks_ago = temp_analyzer.seven_day_testing_average(state)[2]
    @one_week_testing_change = temp_analyzer.seven_day_testing_change(state)
    current_data(state)
    historical_cases(state)
    jhu_state_link(state)
    @@all << self
    @one_week_case_change = temp_analyzer.seven_day_case_change(state)
    binding.pry
  end

  def self.all
    @@all
  end

  def jhu_state_link(state)
    temp_scraper = Scraper.new
    @state_link = temp_scraper.jhu_state_link_scraper(state)
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

  def self.find_or_create_state(state)
    @@all.map{|state| state.name}.include?(state)? @@all.find{|temp_state| temp_state.name == state} : State.new(state)
  end

end
