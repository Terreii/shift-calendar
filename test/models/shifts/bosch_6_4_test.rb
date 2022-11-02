require "test_helper"

class Shifts::Bosch64Test < ActiveSupport::TestCase
  test "returns the shifts of every group for a day" do
    month = Shifts::Bosch64.new year: 2022, month: 8
    assert_equal [:free, :morning, :evening, :night, :free], month.at(22)
    assert_equal [:evening, :morning, :night, :free, :free], month.at(23)

    month2 = Shifts::Bosch64.new year: 2023, month: 12
    assert_equal [:night, :evening, :free, :free, :morning], month2.at(8)
  end

  test "should have a [] method" do
    month = Shifts::Bosch64.new year: 2022, month: rand(1..12)
    day = rand(1..month.size)
    assert_equal month.at(day), month[day]
  end

  test "it iterates through all days in a month" do
    month = Shifts::Bosch64.new year: 2022, month: 9
    month.each_with_index do |day, index|
      assert_equal month.at(index + 1), day
    end
  end

  test "should return self from each" do
    month = Shifts::Bosch64.new year: 2022, month: 9
    result = month.each { |day| }
    assert_equal month, result
  end

  test "should have an each_with_date method" do
    month = Shifts::Bosch64.new year: 2022, month: 9
    month.each_with_date do |day, date|
      assert_equal month.at(date.day), day
      assert_instance_of Date, date
    end
  end

  test "should have a work_days_count method" do
    month = Shifts::Bosch64.new year: 2022, month: 10
    assert_equal [18, 19, 19, 19, 18], month.work_days_count
  end

  test "should have a current_working_shift method" do
    month = Shifts::Bosch64.new year: 2022, month: 10

    travel_to Time.zone.parse("2022-10-10 #{rand(0..5)}:00:00")
    assert_equal [:night, Date.yesterday], month.current_working_shift

    travel_to Time.zone.parse("2022-10-10 #{rand(6..13)}:00:00")
    assert_equal [:morning, Date.current], month.current_working_shift

    travel_to Time.zone.parse("2022-10-10 #{rand(14..21)}:00:00")
    assert_equal [:evening, Date.current], month.current_working_shift

    travel_to Time.zone.parse("2022-10-10 #{rand(22..23)}:00:00")
    assert_equal [:night, Date.current], month.current_working_shift
  end

  test "should have a shifts_times method" do
    month = Shifts::Bosch64.new year: 2022, month: 10

    shifts = {
      morning: {
        start: [6, 0],
        finish: [14, 30]
      },
      evening: {
        start: [14, 0],
        finish: [22, 30]
      },
      night: {
        start: [22, 0],
        finish: [6, 30]
      }
    }
    assert_equal shifts, month.shifts_times
  end
end
