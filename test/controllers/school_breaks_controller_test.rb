require "test_helper"

class SchoolBreaksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @school_break = school_breaks(:break_in_month)
  end

  test "should get index" do
    get school_breaks_url
    assert_response :success
  end

  test "should get new" do
    get new_school_break_url
    assert_response :success
  end

  test "should create school_break" do
    random_date = Faker::Date.in_date_period(year: 2022, month: 8)
    assert_difference("SchoolBreak.count") do
      post school_breaks_url, params: {
        school_break: {
          name: Faker::Games::DnD.city,
          start_date: random_date,
          end_date: random_date + 7.days
        }
      }
    end

    assert_redirected_to school_break_url(SchoolBreak.last)
  end

  test "should show school_break" do
    get school_break_url(@school_break)
    assert_response :success
  end

  test "should get edit" do
    get edit_school_break_url(@school_break)
    assert_response :success
  end

  test "should update school_break" do
    random_date = Faker::Date.in_date_period(year: 2022, month: 8)
    patch school_break_url(@school_break), params: {
      school_break: {
        name: Faker::Games::DnD.city,
        start_date: random_date,
        end_date: random_date + 7.days
      }
    }
    assert_redirected_to school_break_url(@school_break)
  end

  test "should destroy school_break" do
    assert_difference("SchoolBreak.count", -1) do
      delete school_break_url(@school_break)
    end

    assert_redirected_to school_breaks_url
  end
end
