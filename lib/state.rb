require 'pry'

class State
attr_reader :data, :name, :population
attr_accessor :avg_case_3wk, :avg_case_2wk, :avg_case_1wk, :avg_case_current

@@all = []

  def initialize(state)
    @name = state
    temp_scraper = Scraper.new
    @population = temp_scraper.state_population(state)
    @data = temp_scraper.state_scraper(state)[state.to_sym]
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
end
