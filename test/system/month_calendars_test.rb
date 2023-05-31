require "application_system_test_case"

class MonthCalendarsTest < ApplicationSystemTestCase
  test "visiting a month calendar url" do
    visit month_calendar_path(id: "bosch_6_6", year: 2022, month: 8)

    assert_selector "#month_2022-8 caption", text: "August - 2022"
    assert_selector "#day_2022-08-13 > :first-child", text: "13"
    assert_selector "#day_2022-08-13 > :nth-child(2)", text: "Saturday\nSat"
    # Groups
    ['', 'N', '', 'E', '', 'M'].each_with_index do |text, index|
      assert_selector "#day_2022-08-13 > :nth-child(#{index + 3})", text:
    end

    within "#month_2022-8 tfoot" do
      [17, 14, 15, 16, 13, 18].each_with_index do |work_days, index|
        assert_selector "td:nth-child(#{index + 2})", text: work_days
      end
    end
  end

  test "visiting the calendar url shows the current month" do
    visit root_path
    click_on "Shifts"
    click_on "Bosch 6 - 6"

    today = Date.current

    table = find("#month_#{today.year}-#{today.month}").native.attribute('outerHTML')
    assert_not_empty table

    visit month_calendar_path(id: "bosch_6_6", year: today.year, month: today.month)
    assert_equal find("#month_#{today.year}-#{today.month}").native.attribute('outerHTML'), table
  end

  test "visiting a month calendar url shows the selected shift" do
    visit month_calendar_path(id: "bosch_6_4", year: 2022, month: 8)

    ['E', 'M', 'N', '', ''].each_with_index do |text, index|
      assert_selector "#day_2022-08-13 > :nth-child(#{index + 3})", text:
    end
  end

  test "visiting a calendar url shows the selected shift" do
    visit root_path
    click_on "Shifts"
    click_on "Bosch 6 - 4"
    today = Date.current
    shift = Shift.new(:bosch_6_4, year: today.year, month: today.month)

    shift.at(today.day)[:shifts].each_with_index do |shift, index|
      unless shift == :free
        assert_selector "#day_#{today.iso8601} > :nth-last-child(#{5 - index})", text: shift.to_s.upcase
      end
    end
  end

  test "month calendar url loads last and next two months" do
    visit month_calendar_path(id: "bosch_6_4", year: 2021, month: 4)

    assert_selector "#month_2021-3 caption", text: "March - 2021"
    assert_selector "#month_2021-4 caption", text: "April - 2021"
    assert_selector "#month_2021-5 caption", text: "May - 2021"
    assert_selector "#month_2021-6 caption", text: "June - 2021"
  end

  test "should highlight today" do
    visit calendar_path(id: "bosch_6_4")

    # Border for the row
    assert_selector "tr#day_#{Date.current.iso8601}.today"
    # highlight current working shift
    if Time.current.hour < 6
      assert_selector "#day_#{Date.yesterday.iso8601} > .current_shift"
    else
      assert_selector "#day_#{Date.current.iso8601} > .current_shift"
    end
  end

  test "should highlight today in year_calendar_path" do
    visit year_calendar_path(id: "bosch_6_4", year: Date.current.year)

    # Border for the row
    assert_selector "tr#day_#{Date.current.iso8601}.today"
    # highlight current working shift
    if Time.current.hour < 6
      assert_selector "#day_#{Date.yesterday.iso8601} > .current_shift"
    else
      assert_selector "#day_#{Date.current.iso8601} > .current_shift"
    end
  end

  test "should display tooltip for events" do
    visit month_calendar_path(id: "bosch_6_6", year: 2023, month: 3)

    assert_selector "td.daylight_saving"
    element = find("td.daylight_saving")
    element.hover

    assert_not_nil element["aria-describedby"], "should have a tooltip description"
    assert find("div.tooltip##{element["aria-describedby"]}").visible?, "should show a tooltip"
  end
end
