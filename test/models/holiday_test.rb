require "test_helper"

class HolidayTest < ActiveSupport::TestCase
  test "should create a new holiday" do
    holiday = Holiday.new name: Faker::Games::Zelda.location, date: Date.current
    assert holiday.save
  end

  test "should require a name" do
    holiday = Holiday.new date: Date.current
    assert_not holiday.save
  end

  test "should require a date" do
    holiday = Holiday.new name: Faker::Games::Zelda.location
    assert_not holiday.save
  end

  test "all_in_month finds all holidays in a month" do
    holidays = Holiday.all_in_month 2022, 5
    assert_equal 2, holidays.size
    assert_equal "Tag der Arbeit", holidays[Date.new(2022, 5, 1)].first.name
    assert_equal "Star Wars Day", holidays[Date.new(2022, 5, 4)].first.name
  end

  test "all_in_year finds all holidays in a year" do
    holidays = Holiday.all_in_year 2022
    assert_equal 3, holidays.size
    assert_equal "Tag der Arbeit", holidays[Date.new(2022, 5, 1)].first.name
    assert_equal "Star Wars Day", holidays[Date.new(2022, 5, 4)].last.name
    assert_equal "International Cat Day", holidays[Date.new(2022, 8, 8)].last.name
  end
end
