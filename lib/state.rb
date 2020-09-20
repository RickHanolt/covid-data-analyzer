require 'pry'

class State
attr_reader :name, :population, :cases, :negative_tests, :currently_hospitalized, :cumulitive_hospitalized, :current_icu, :cumulitive_icu, :current_ventilator, :cumulitive_ventilator, :recovered, :deaths, :total_test_results, :avg_case_3wk, :avg_case_2wk, :avg_case_1wk, :avg_case_current, :state_link, :testing_avg_current, :testing_avg_last_week, :testing_avg_two_weeks_ago, :one_week_testing_change, :one_week_case_change, :percent_positive

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
    @percent_positive = (@cases.to_f / @total_test_results) * 100
    @@all << self
    @one_week_case_change = temp_analyzer.seven_day_case_change(state)
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
    temp_scraper = Scraper.new
    data = temp_scraper.most_recent_day_from_api(state)
    @cases = data["positiveIncrease"]
    @negative_tests = data["negativeIncrease"]
    @currently_hospitalized = data["hospitalizedCurrently"]
    @cumulitive_hospitalized = data["hospitalizedCumulative"]
    @current_icu = data["inIcuCurrently"]
    @cumulitive_icu = data["inIcuCumulative"]
    @current_ventilator = data["onVentilatorCurrently"]
    @cumulitive_ventilator = data["onVentilatorCumulative"]
    @recovered = data["recovered"]
    @deaths = data["death"]
    @total_test_results = data["totalTestResultsIncrease"]
  end

  def self.find_or_create_state(state)
    @@all.map{|state| state.name}.include?(state)? @@all.find{|temp_state| temp_state.name == state} : State.new(state)
  end

end
