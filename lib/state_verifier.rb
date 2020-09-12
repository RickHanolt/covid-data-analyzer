require 'pry'

class StateVerifier
  attr_reader :temp_state

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

  def state_checker(state_input)
    matching = nil
    best_match = []
    @state_input = state_input.gsub(" ","").downcase.split('').sort.join
    limit = @state_input.length
    @@all_states.each do |state|
      temp_state = state[1].gsub(" ","").downcase.split('').sort.join
      lower_limit = temp_state.length
      limit > lower_limit ? lower_limit : lower_limit = limit
      counter = 0
      matching = 0
      while counter < (lower_limit + 1)
        if @state_input[counter] == temp_state[counter]
          binding.pry if state = "Ohio"
          matching += 1
        end
        counter += 1
      end
      best_match << [matching, state[1]]
    end
    binding.pry
    matching = matching.to_f/state_input.length
    matching.round(2)
  end

end
