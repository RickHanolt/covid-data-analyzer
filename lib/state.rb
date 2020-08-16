require 'pry'

class State
attr_reader :data, :name

@@all = []

  def initialize(state)
    @name = state
    temp_scraper = Scraper.new
    @data = temp_scraper.state_scraper[state.to_sym]
    temp_scraper.historical_data[state.to_sym].each do |key,value|
      @data[key] = value
    end
    @@all << self if State.all.none?{|state_name| state_name.name == state}
  end

  def self.all
    @@all
  end

end
