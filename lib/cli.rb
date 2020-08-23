require 'pry'

class CLI

  def welcome
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
      temp_state = State.find_or_create_state(state_name)
      puts temp_state
      welcome
    when "2"
      return
    else
      welcome
    end
  end

end
