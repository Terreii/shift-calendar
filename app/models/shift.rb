class Shift
  class ModelUnknown < StandardError; end

  def self.all
    Rails.configuration.x.shifts.keys
  end

  attr_reader :year, :month
  
  def initialize(shift_model, year:, month:)
    @shift_model = shift_model.to_sym
    @config = Rails.configuration.x.shifts[@shift_model]
    raise ModelUnknown if @config.nil?
    @year = year.to_i
    @month = month.to_i
  end

  # Number of days in that month
  def size
    Time.days_in_month(@month, @year)
  end
  alias_method :length, :size

  # Number of groups in this shift model
  def groups
    @config[:group_offsets].size
  end

  def shifts_times
    @config[:shifts].transform_values do |value|
      value.slice :start, :finish
    end
  end
end
