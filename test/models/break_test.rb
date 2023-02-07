require "test_helper"

class BreakTest < ActiveSupport::TestCase
  test "should create a new break" do
    school_break = Break.new name: Faker::Ancient.god,
      duration: Date.new(2022, 4, 14)..Date.new(2022, 4, 24)
    assert school_break.save
  end

  test "should require a name" do
    school_break = Break.new duration: Date.new(2022, 4, 14)..Date.new(2022, 4, 24)
    assert_not school_break.save
  end 

  test "should require a duration" do
    school_break = Break.new name: Faker::Ancient.god
    assert_not school_break.save
  end
end
