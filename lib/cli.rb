require 'pry'

class CLI

  def self.welcome
    user_selection = ""
    puts "Welcome! What would you like to do?"
    while user_selection == ""
      puts "1. Get data for a state"
      puts "2. Exit"
      user_selection = gets.strip
    end

    case user_selection
    when "1"
      puts "What state would you like data for?"
      state_name = gets.strip
      if State.all.none?{|state| state.name == state_name}
        State.new(state_name).data.each{|key, value| puts "#{key}: #{value}"}
      else
        temp_state_display = State.all.detect{|state| state.name == state_name}
        temp_state_display.data.each{|key, value| puts "#{key}: #{value}"}
        binding.pry
      end
      welcome
    when "2"
      return
    else
      welcome
    end
  end
end
