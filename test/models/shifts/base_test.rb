require "test_helper"

class Shifts::BaseTest < ActiveSupport::TestCase
  test "should have a method to select and create shifts by id" do
    shift = Shifts::Base.create "bosch-6-6", year: 2022, month: 8
    assert_instance_of Shifts::Bosch66, shift

    shift = Shifts::Base.create "bosch-6-4", year: 2022, month: 8
    assert_instance_of Shifts::Bosch64, shift
  end

  test "should return nil for unknown shift models" do
    assert_nil Shifts::Base.create("some-other", year: 2022, month: 8)
  end

  test "should support symbol keys" do
    shift = Shifts::Base.create :bosch66, year: 2022, month: 8
    assert_instance_of Shifts::Bosch66, shift

    shift = Shifts::Base.create :bosch64, year: 2022, month: 8
    assert_instance_of Shifts::Bosch64, shift
  end

  test "should have a work_days_count method" do
    month = Shifts::Base.new year: 2022, month: 10
    assert_equal [], month.work_days_count
  end

  test "should have a size and length method" do
    month = Shifts::Base.new year: 2022, month: 10
    assert_equal 31, month.size
    assert_equal 31, month.length

    month = Shifts::Base.new year: 2022, month: 9
    assert_equal 30, month.size
    assert_equal 30, month.length
  end
end
