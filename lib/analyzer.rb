require 'pry'

class Analyzer

  def seven_day_testing_average(state)
    temp_scraper = Scraper.new
    data_last_three_weeks = temp_scraper.covid_tracking_api_last_3_weeks(state)
    daily_tests_last_3_weeks = data_last_three_weeks.map{|daily_data| daily_data["totalTestResultsIncrease"]}
    weekly_average = []
    tests_this_week = 0
    tests_last_week = 0
    tests_two_weeks_ago = 0
    daily_tests_last_3_weeks.each_with_index do |daily_tests,index|
      tests_this_week += daily_tests if index < 7
      tests_last_week += daily_tests if (index > 6 && index < 14)
      tests_two_weeks_ago += daily_tests if (index > 13 && index < 21)
    end
      weekly_average << (tests_this_week / 7)
      weekly_average << (tests_last_week / 7)
      weekly_average << (tests_two_weeks_ago / 7)

      weekly_average
  end

  def seven_day_testing_change(state)
    one_week_testing_change = (seven_day_testing_average(state)[0] - seven_day_testing_average(state)[1]) / seven_day_testing_average(state)[1].to_f
    one_week_testing_change_percent = one_week_testing_change * 100
  end

  def seven_day_case_change(state)
    avg_case = 0.0
    State.all.each do |s|
      if s.name == state
        avg_case_current = s.avg_case_current.gsub(",","").to_f
        avg_case_1wk = s.avg_case_1wk.gsub(",","").to_f
        avg_case = (avg_case_current - avg_case_1wk) / avg_case_1wk
      end
    end
    avg_case_percent = avg_case * 100 if avg_case
  end

end
