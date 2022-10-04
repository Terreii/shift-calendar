require "application_system_test_case"

class MonthCalendarsTest < ApplicationSystemTestCase
   test "visiting a month calendar url" do
     visit month_calendar_path(id: "bosch-6-6", year: 2022, month: 8)
  
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

     today = Date.today

     table = find("#month_#{today.year}-#{today.month}").native.attribute('outerHTML')
     assert_not_empty table

     visit month_calendar_path(id: "bosch-6-6", year: today.year, month: today.month)
     assert_equal find("#month_#{today.year}-#{today.month}").native.attribute('outerHTML'), table
   end

   test "visiting a month calendar url shows the selected shift" do
     visit month_calendar_path(id: "bosch-6-4", year: 2022, month: 8)

     ['E', 'M', 'N', '', ''].each_with_index do |text, index|
       assert_selector "#day_2022-08-13 > :nth-child(#{index + 3})", text:
     end
   end

   test "visiting a calendar url shows the selected shift" do
     visit root_path
     click_on "Shifts"
     click_on "Bosch 6 - 4"
     today = Date.today
     shift = Shifts::Bosch64.new(year: today.year, month: today.month)

     shift.at(today.day).each_with_index do |shift, index|
       unless shift == :free
         assert_selector "#day_#{today.iso8601} > :nth-child(#{index + 3})", text: I18n.t(shift, scope: "calendar.shifts")
       end
     end
   end

   test "month calendar url loads last and next two months" do
     visit month_calendar_path(id: "bosch-6-4", year: 2021, month: 4)

     assert_selector "#month_2021-3 caption", text: "March - 2021"
     assert_selector "#month_2021-4 caption", text: "April - 2021"
     assert_selector "#month_2021-5 caption", text: "May - 2021"
     assert_selector "#month_2021-6 caption", text: "June - 2021"
   end
end
