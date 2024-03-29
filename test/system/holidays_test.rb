require "application_system_test_case"

class HolidaysTest < ApplicationSystemTestCase
  setup do
    @holiday = holidays(:one)
  end

  test "visiting the index" do
    visit holidays_url
    assert_selector "h1", text: "Holidays"
  end

  test "should create holiday" do
    visit holidays_url
    click_on "New holiday"

    fill_in "Date", with: @holiday.date
    fill_in "Name", with: @holiday.name
    click_on "Create Holiday"

    assert_text "Holiday was successfully created"
    click_on "cancel"
  end

  test "should update Holiday" do
    visit holidays_url
    click_on "Edit this holiday", match: :first

    fill_in "Date", with: @holiday.date
    fill_in "Name", with: @holiday.name
    click_on "Update Holiday"

    assert_text "Holiday was successfully updated"
  end

  test "should destroy Holiday" do
    visit holidays_url
    page.accept_confirm do
      click_on "Destroy this holiday", match: :first
    end

    assert_text "Holiday was successfully destroyed"
  end
end
