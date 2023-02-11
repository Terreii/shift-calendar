require "test_helper"

class PublicEventTest < ActiveSupport::TestCase
  test "all_in_month finds all PublicEvents of a month" do
    events = PublicEvent.all_in_month 2022, 8
    event = breaks(:multi_month_break)
    assert_equal event, events[Date.new(2022, 8, 1)]
    random_date = Faker::Date.in_date_period(year: 2022, month: 8)
    assert_equal event, events[random_date], "random date"
    assert_instance_of Break, events[random_date]
  end

  test "all_in_year finds all PublicEvents in a year" do
    events = PublicEvent.all_in_year 2022

    in_month_break = breaks(:break_in_month)
    random_date = Faker::Date.between(from: in_month_break.duration.begin, to: in_month_break.duration.end)
    assert_equal in_month_break, events[random_date]

    summer_break = breaks(:multi_month_break)
    random_date = Faker::Date.in_date_period(year: 2022, month: 8)
    assert_equal summer_break, events[Date.new(2022, 7, 29)]
    assert_equal summer_break, events[random_date]
    assert_equal summer_break, events[Date.new(2022, 9, 11)]

    winter_break = breaks(:over_year_break)
    assert_equal winter_break, events[Date.new(2022, 12, 21)]
  end
end
