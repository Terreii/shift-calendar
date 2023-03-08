# == Schema Information
#
# Table name: public_events
#
#  id         :bigint           not null, primary key
#  duration   :daterange
#  name       :string
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_public_events_on_duration           (duration) USING gist
#  index_public_events_on_type               (type)
#  index_public_events_on_type_and_duration  (type,duration)
#
require "test_helper"

class SchoolBreakTest < ActiveSupport::TestCase
  test "should create a new break" do
    school_break = SchoolBreak.new name: Faker::Ancient.god,
      duration: Date.new(2022, 4, 14)..Date.new(2022, 4, 24)
    assert school_break.save
  end

  test "should require a name" do
    school_break = SchoolBreak.new duration: Date.new(2022, 4, 14)..Date.new(2022, 4, 24)
    assert_not school_break.save
  end 

  test "should require a duration" do
    school_break = SchoolBreak.new name: Faker::Ancient.god
    assert_not school_break.save
  end
end
