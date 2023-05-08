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
end
