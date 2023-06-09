require "test_helper"

class ShiftTest < ActiveSupport::TestCase
  test "should have a all method to list all shifts" do
    assert_equal [
      :bosch_6_6,
      :bosch_6_4
    ], Shift.all
  end

  test "should have a size and length method" do
    month = Shift.new(:bosch_6_6, year: 2022, month: 10)
    assert_equal 31, month.size
    assert_equal 31, month.length

    month = Shift.new(:bosch_6_6, year: 2022, month: 9)
    assert_equal 30, month.size
    assert_equal 30, month.length
  end

  test "should raise an exception if shift model key is unknown" do
    assert_raises(Shift::ModelUnknown) { Shift.new(:abcdf, year: 2022, month: 2) }
    
    assert_not_nil Shift.new("bosch_6_4", year: 2023, month: 12)
  end

  test "should have a groups method" do
    month = Shift.new :bosch_6_6, year: 2022, month: 10
    assert_equal 6, month.groups

    Shift.all.each do |model|
      month = Shift.new model, year: 2022, month: 9
      assert_equal Rails.configuration.x.shifts[model][:group_offsets].size, month.groups
    end
  end

  test "should have a shift_times method" do
    month = Shift.new :bosch_6_6, year: 2022, month: 10
    shifts = {
      m: {
        start: [6, 0],
        finish: [14, 30]
      },
      e: {
        start: [14, 0],
        finish: [22, 30]
      },
      n: {
        start: [22, 0],
        finish: [6, 30]
      }
    }
    assert_equal shifts, month.shifts_times
  end

  test "returns the shifts of every group for a day" do
    month = Shift.new :bosch_6_6, year: 2022, month: 8
    assert_equal ({
      closed: false,
      shifts: [:free, :m, :n, :free, :e, :free]
    }), month.at(22), "bosch_6_6 2022-08-22"
    assert_equal ({
      closed: false,
      shifts: [:free, :e, :free, :m, :n, :free]
    }), month.at(23), "bosch_6_6 2022-08-23"

    month = Shift.new :bosch_6_6, year: 2023, month: 12
    assert_equal ({
      closed: false,
      shifts: [:m, :free, :free, :n, :free, :e]
    }), month.at(8), "bosch_6_6 2023-12-08"
    assert_equal ({
      closed: true,
      shifts: [:n, :free, :e, :free, :m, :free]
    }), month.at(24), "bosch_6_6 2023-12-24"

    # Other model
    month = Shift.new :bosch_6_4, year: 2022, month: 8
    assert_equal ({
      closed: false,
      shifts: [:free, :m, :e, :n, :free]
    }), month.at(22), "bosch_6_4 2022-08-22"
    assert_equal ({
      closed: false,
      shifts: [:e, :m, :n, :free, :free]
    }), month.at(23), "bosch_6_4 2022-08-23"

    month = Shift.new :bosch_6_4, year: 2023, month: 12
    assert_equal ({
      closed: false,
      shifts: [:n, :e, :free, :free, :m]
    }), month.at(8), "bosch_6_4 2022-12-08"
    assert_equal ({
      closed: true,
      shifts: [:free, :m, :e, :n, :free]
    }), month.at(24), "bosch_6_4 2022-12-24"
  end

  test "should have a [] method" do
    month = Shift.new :bosch_6_6, year: 2022, month: 8
    day = rand(1..month.size)
    assert_equal month.at(day), month[day]
  end

  test "it iterates through all days in a month" do
    month = Shift.new :bosch_6_6, year: 2022, month: 8
    month.each_with_index do |day, index|
      assert_equal month.at(index + 1), day
    end
  end

  test "should return self from each" do
    month = Shift.new :bosch_6_4, year: 2022, month: 8
    result = month.each { |day| }
    assert_equal month, result
  end

  test "should have an each_with_date method" do
    month = Shift.new :bosch_6_4, year: 2022, month: 8
    month.each_with_date do |day, date|
      assert_equal month.at(date.day), day
      assert_instance_of Date, date
    end
  end

  test "should have a work_days_count method" do
    month = Shift.new :bosch_6_6, year: 2022, month: 10
    assert_equal [18, 13, 16, 15, 14, 17], month.work_days_count
  end

  test "should have a current_working_shift method" do
    month = Shift.new :bosch_6_6, year: 2022, month: 10

    travel_to Time.zone.local(2022, 10, 10, rand(0..5), 0, 0)
    assert_equal [:n, Date.yesterday], month.current_working_shift

    travel_to Time.zone.local(2022, 10, 8, rand(6..13), 0, 0)
    assert_equal [:m, Date.current], month.current_working_shift

    travel_to Time.zone.local(2023, 2, 14, rand(14..21), 0, 0)
    assert_equal [:e, Date.current], month.current_working_shift

    travel_to Time.zone.local(2023, 2, 14, rand(22..23), 0, 0)
    assert_equal [:n, Date.current], month.current_working_shift
  end

  test "should have closing days" do
    [:bosch_6_6, :bosch_6_4].each do |model|
      month = Shift.new model, year: 2022, month: 12
      assert month.at(Faker::Number.within(range: 24..26))[:closed], "X-mas #{model}"

      month = Shift.new model, year: 2023, month: 4
      assert month.at(Faker::Number.within(range: 7..10))[:closed], "Easter 2023 #{model}"

      month = Shift.new model, year: 2022, month: 4
      assert month.at(Faker::Number.within(range: 15..18))[:closed], "Easter 2022 #{model}"
    end
  end
  
  test "should have an identifier method" do
    [:bosch_6_6, :bosch_6_4].each do |model|
      month = Shift.new model, year: 2023, month: 5
      assert_equal model, month.identifier
    end
  end
end
