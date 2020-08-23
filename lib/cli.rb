require 'pry'

class CLI
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
      state_name = gets.strip.capitalize
      if @@all_states.any?{|state| state[1] == state_name}
        temp_state = State.find_or_create_state(state_name)
        puts "For more information, please visit #{temp_state.state_link} ."
      else
        puts "Invalid state name. Please enter a valid state."
      end
      welcome
    when "2"
      return
    else
      welcome
    end
  end

end
