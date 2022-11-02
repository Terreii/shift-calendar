require "test_helper"

class Shifts::Bosch66Test < ActiveSupport::TestCase
  test "returns the shifts of every group for a day" do
    month = Shifts::Bosch66.new year: 2022, month: 8
    assert_equal [:free, :morning, :night, :free, :evening, :free], month.at(22)
    assert_equal [:free, :evening, :free, :morning, :night, :free], month.at(23)

    month2 = Shifts::Bosch66.new year: 2023, month: 12
    assert_equal [:morning, :free, :free, :night, :free, :evening], month2.at(8)
  end

  test "should have a [] method" do
    month = Shifts::Bosch66.new year: 2022, month: rand(1..12)
    day = rand(1..month.size)
    assert_equal month.at(day), month[day]
  end

  test "it iterates through all days in a month" do
    month = Shifts::Bosch66.new year: 2022, month: 9
    month.each_with_index do |day, index|
      assert_equal month.at(index + 1), day
    end
  end

  test "should return self from each" do
    month = Shifts::Bosch66.new year: 2022, month: 9
    result = month.each { |day| }
    assert_equal month, result
  end

  test "should have an each_with_date method" do
    month = Shifts::Bosch66.new year: 2022, month: 9
    month.each_with_date do |day, date|
      assert_equal month.at(date.day), day
      assert_instance_of Date, date
    end
  end

  test "should have a work_days_count method" do
    month = Shifts::Bosch66.new year: 2022, month: 10
    assert_equal [18, 13, 16, 15, 14, 17], month.work_days_count
  end

  test "should have a current_working_shift method" do
    month = Shifts::Bosch66.new year: 2022, month: 10

    travel_to Time.zone.local(2022, 10, 10, rand(0..5), 0, 0)
    assert_equal [:night, Date.yesterday], month.current_working_shift

    travel_to Time.zone.local(2022, 10, 8, rand(6..13), 0, 0)
    assert_equal [:morning, Date.current], month.current_working_shift

    travel_to Time.zone.local(2023, 2, 14, rand(14..21), 0, 0)
    assert_equal [:evening, Date.current], month.current_working_shift

    travel_to Time.zone.local(2023, 2, 14, rand(22..23), 0, 0)
    assert_equal [:night, Date.current], month.current_working_shift
  end

  test "should have a shifts_times method" do
    month = Shifts::Bosch66.new year: 2022, month: 10

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
