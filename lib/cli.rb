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
    while user_selection == ""
      puts "Welcome! What would you like to do?"
      puts "1. Get data for a state"
      puts "2. Exit"
      user_selection = gets.strip
      puts "Invalid Entry." if user_selection == ""
    end

    case user_selection
    when "1"
      puts "What state would you like data for?"
      state_name = gets.strip
      if state_name == ""
        state_name = "."
      end
      temp_verifier = StateVerifier.new
      best_matches = temp_verifier.state_checker(state_name)
      best_matches = [[0],[0]] if best_matches == []
      if @@all_states.any?{|state| state[1] == state_name}
        data_output(state_name)
      elsif @@all_states.none?{|state| state[1] == state_name} && best_matches[0][0] == 1
        state_name = best_matches[0][1]
        data_output(state_name)
      elsif best_matches[0][0] >= 0.50
        user_input = 0
        until user_input >= 1 && user_input <= (best_matches.count + 1)
        puts "Did you mean:"
        best_matches.each_with_index do |match, index|
          puts "#{index + 1}: #{best_matches[index][1]}"
        end
        puts "#{best_matches.count + 1}: None of the above"
          user_input = gets.strip.to_i
          if user_input >= 1 && user_input  <= (best_matches.count)
            state_name = best_matches[user_input - 1][1]
            data_output(state_name)
          else
          end
        end
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

  def data_output(state_name)
    puts "Retrieving state data..."
    temp_state = State.find_or_create_state(state_name)
    temp_state_abbreviation = @@all_states.find{|state| state[1] == temp_state.name}[0]
    puts " "
    puts "- #{state_name} -"
    puts " "
    puts "Change in case count vs. prior week: #{temp_state.one_week_case_change.round(2)}%"
    puts "Change in testing vs. prior week: #{temp_state.one_week_testing_change.round(2)}%"
    puts "Percent positive: #{temp_state.percent_positive.round(2)}%"
    puts "For more information, please visit https://covidactnow.org/us/#{temp_state_abbreviation} ."
    puts "Press <Return> key to continue"
    gets
  end
end
