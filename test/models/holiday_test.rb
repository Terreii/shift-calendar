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

  test "should have a date method" do
    holiday = holidays(:one)
    assert_equal holiday.duration.begin, holiday.date
  end

  test "should allow to write to date" do
    holiday = holidays(:one)
    holiday.date = Date.today
    assert_equal Date.today, holiday.date
    assert_equal Date.today..Date.today, holiday.duration
    assert holiday.save
  end

  test "date should return nil if no duration is set" do
    holiday = Holiday.new
    assert_nil holiday.date
  end
end
