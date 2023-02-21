require "application_system_test_case"

class SchoolBreaksTest < ApplicationSystemTestCase
  setup do
    @school_break = school_breaks(:break_in_month)
  end

  test "visiting the index" do
    visit school_breaks_url
    assert_selector "h1", text: "School breaks"
  end

  test "should create school break" do
    visit school_breaks_url
    click_on "New School Break"

    fill_in "Start date", with: @school_break.start_date
    fill_in "End date", with: @school_break.end_date
    fill_in "Name", with: @school_break.name
    click_on "Create School break"

    assert_text "School break was successfully created"
    click_on "cancel"
  end

  test "should update School break" do
    visit school_breaks_url
    click_on "Edit this school break", match: :first

    fill_in "Start date", with: @school_break.start_date
    fill_in "End date", with: @school_break.end_date
    fill_in "Name", with: @school_break.name
    click_on "Update School break"

    assert_text "School break was successfully updated"
  end

  test "should destroy School break" do
    visit school_breaks_url
    click_on "Destroy this school break", match: :first

    assert_text "School break was successfully destroyed"
  end
end
