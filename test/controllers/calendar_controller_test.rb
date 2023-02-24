require "test_helper"

class CalendarControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get calendar_index_url
    assert_response :success
  end

  test "should get show" do
    get calendar_path(id: "bosch-6-6")
    assert_response :success
  end

  test "should get year" do
    get year_calendar_path(id: "bosch-6-6", year: 2022)
    assert_response :success

    12.times do |index|
      assert_match I18n.t("date.month_names")[index + 1], @response.body, "Find month #{index + 1} in body"
    end
  end

  test "should get month" do
    get month_calendar_path(id: "bosch-6-6", year: 2023, month: 2)
    assert_response :success
  end

  test "should select shift model" do
    get month_calendar_path(id: "bosch-6-6", year: 2022, month: 6)
    assert_response :success
  end

  test "should error if shift model doesn't exist" do
    assert_raises(ActionController::RoutingError) do 
      get month_calendar_path(id: "some-other", year: 2022, month: 6)
    end
  end

  test "should have last and next two months as turbo frame" do
    get month_calendar_path(id: "bosch-6-6", year: 2023, month: 2)
    assert_match "February - 2023", @response.body

    [1, 3, 4].each do |month|
      assert_match month_calendar_path(id: "bosch-6-6", year: 2023, month:), @response.body
    end
  end

  test "should have the daylight saving time switch" do
    get month_calendar_path(id: "bosch-6-6", year: 2022, month: 3)
    body = Nokogiri.parse @response.body
    elements = body.css("td.daylight_saving")
    assert_equal 1, elements.length
    assert_equal "day_2022-03-27", elements.first.parent[:id]
    assert_equal I18n.t("calendar.dls.forward"), elements.first[:title]

    get month_calendar_path(id: "bosch-6-6", year: 2022, month: 10)
    body = Nokogiri.parse @response.body
    element = body.at_css("td.daylight_saving")
    assert_equal "day_2022-10-30", element.parent[:id]
    assert_equal I18n.t("calendar.dls.back"), element[:title]
  end

  test "should highlight today" do
    travel_to Time.zone.parse("2022-10-10 04:00:00")
    get calendar_path(id: "bosch-6-4")
    body = Nokogiri.parse @response.body

    # Border for the row
    assert_not_nil body.at_css("tr#day_#{Date.current.iso8601}.today")
    # highlight current working shift
    assert_not_nil body.at_css("#day_#{Date.yesterday.iso8601} > .current_shift")
  end

  test "should highlight today in year_calendar_path" do
    travel_to Time.zone.parse("2022-10-10 04:00:00")
    get year_calendar_path(id: "bosch-6-4", year: 2022)
    body = Nokogiri.parse @response.body

    # Border for the row
    assert_not_nil body.at_css("tr#day_#{Date.current.iso8601}.today")
    # highlight current working shift
    assert_not_nil body.at_css("#day_#{Date.yesterday.iso8601} > .current_shift")
  end

  test "should mark holidays" do
    get month_calendar_path(id: "bosch-6-6", year: 2022, month: 5)
    body = Nokogiri.parse @response.body

    assert_not_nil body.at_css("tr#day_2022-05-01 > .holiday")
    assert_not_nil body.at_css("tr#day_2022-05-04 > .holiday")
    assert_equal 2, body.css(".holiday").size
  end

  test "should mark holidays in year" do
    get year_calendar_path(id: "bosch-6-4", year: 2022)
    body = Nokogiri.parse @response.body

    assert_not_nil body.at_css("tr#day_2022-05-01 > .holiday")
    assert_not_nil body.at_css("tr#day_2022-05-04 > .holiday")
    assert_not_nil body.at_css("tr#day_2022-08-08 > .holiday")
    assert_equal 3, body.css(".holiday").size
  end

  test "should support multiple public_events on a day" do
    get month_calendar_path(id: "bosch-6-6", year: 2022, month: 8)
    body = Nokogiri.parse @response.body

    assert_not_nil body.at_css("tr#day_2022-08-08 > .holiday.school_break")
  end
end
