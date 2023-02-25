require "test_helper"

class PublicEventTest < ActiveSupport::TestCase
  test "all_in_month finds all PublicEvents of a month" do
    events = PublicEvent.all_in_month 2022, 8
    event = school_breaks(:multi_month_break)
    assert_equal event, events[Date.new(2022, 8, 1)].first

    random_date = date_in_august_that_is_not_cat_day
    assert_equal event, events[random_date].first, "random date"
    assert_instance_of SchoolBreak, events[random_date].first
  end

  test "all_in_year finds all PublicEvents in a year" do
    events = PublicEvent.all_in_year 2022

    in_month_break = school_breaks(:break_in_month)
    random_date = Faker::Date.between(from: in_month_break.duration.begin, to: in_month_break.duration.end.yesterday)
    assert_equal in_month_break, events[random_date].first

    summer_break = school_breaks(:multi_month_break)
    random_date = date_in_august_that_is_not_cat_day
    assert_equal summer_break, events[Date.new(2022, 7, 29)].first
    assert_equal summer_break, events[random_date].first
    assert_equal summer_break, events[Date.new(2022, 9, 11)].first

    winter_break = school_breaks(:over_year_break)
    assert_equal winter_break, events[Date.new(2022, 12, 21)].first
  end

  test "should have a start_date method" do
    random_date = Faker::Date.in_date_period(year: 2022, month: 8)
    event = SchoolBreak.new(
      name: Faker::Games::DnD.alignment,
      duration: random_date..(random_date + 5.days)
    )
    assert_equal random_date, event.start_date
  end

  test "should be updatable by start_date" do
    event = school_breaks(:break_in_month)
    duration = event.duration
    new_start = duration.begin - 2.days
    event.start_date = new_start
    assert_equal new_start...duration.end, event.duration
  end

  test "start_date= should work if duration is nil" do
    event = SchoolBreak.new name: "Test"
    event.start_date = Faker::Date.in_date_period(year: 2022, month: 8)
    assert_not_nil event.duration
  end

  test "should have a end_date method" do
    random_date = Faker::Date.in_date_period(year: 2022, month: 8)
    event = SchoolBreak.new(
      name: Faker::Games::DnD.alignment,
      duration: (random_date - 5.days)...random_date
    )
    assert_equal random_date.yesterday, event.end_date
  end

  test "should be updatable by end_date" do
    event = school_breaks(:break_in_month)
    duration = event.duration
    new_end = duration.end + 2.days
    event.end_date = new_end
    assert_equal duration.begin...new_end.tomorrow, event.duration
  end

  test "end_date= should work if duration is nil" do
    event = SchoolBreak.new name: "Test"
    event.end_date = Faker::Date.in_date_period(year: 2022, month: 8)
    assert_not_nil event.duration
  end

  test "start_date= and end_date= should work with strings" do
    event = school_breaks(:break_in_month)
    date = Faker::Date.in_date_period(year: 2022, month: 8)
    end_date = date + 2.days
    event.start_date = date.iso8601
    event.end_date = end_date.iso8601
    assert_equal date...end_date.tomorrow, event.duration
  end

  def date_in_august_that_is_not_cat_day
    loop do
      random_date = Faker::Date.in_date_period(year: 2022, month: 8)
      return random_date unless random_date == Date.new(2022, 8, 8)
    end
  end
end
