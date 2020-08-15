require 'pry'

class CLI

  def self.welcome
    get_data = ""
    puts "Welcome! What would you like to do?"
    while get_data == ""
      puts "1. Get data for a state"
      puts "2. Exit"
      get_data = gets.strip
    end

    case get_data
    when "1"
      puts "What state would you like data for?"
      get_data = gets.strip
      puts State.new(get_data).data
      welcome
    when "2"
      return
    else
      welcome
    end
  end
end
