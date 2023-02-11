require "test_helper"

class PublicEventTest < ActiveSupport::TestCase
  test "all_in_month finds all PublicEvents of a month" do
    events = PublicEvent.all_in_month 2022, 8
    assert_equal 1, events.size
    assert_equal breaks(:multi_month_break).name, events[8].first.name
    assert_instance_of Break, events[8].first
  end

  test "all_in_year finds all PublicEvents in a year" do
    events = PublicEvent.all_in_year 2022
    assert_equal 12, events.size
    assert_equal breaks(:break_in_month).name, events[6].first.name
    # Event is in all of its months
    assert_equal breaks(:multi_month_break).name, events[7].first.name
    assert_equal breaks(:multi_month_break).name, events[8].first.name
    assert_equal breaks(:multi_month_break).name, events[9].first.name
    assert_equal breaks(:over_year_break).name, events[12].first.name
  end
end
