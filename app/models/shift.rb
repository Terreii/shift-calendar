class Shift
  include Enumerable

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

  # Get shifts data for a day im month.
  # Returns a Hash with shifts: Array => Shifts of every group
  # And with closed: Boolean => If on that day is a closing day
  def at(day)
    lilian_days = Date.new(@year, @month, day).ld
    shifts = group_offsets.each_with_index.map do |offset, group|
      group_cycle = group_shift_cycle(group)
      days_in_cycle = (lilian_days + offset) % group_cycle.length
      shift = group_cycle[days_in_cycle]
      shift.nil? ? :free : shift.to_sym
    end
    { closed: closed?(day), shifts: }
  end
  alias_method :[], :at

  # With a block given, calls the block with each day data; returns self.
  def each
    month_data.each do |data|
      yield data
    end
    self
  end

  # With a block given, calls the block with each day data and its Date instance; returns self.
  def each_with_date
    each_with_index do |data, index|
      yield data, Date.new(@year, @month, index + 1)
    end
  end

  private

    # Caches all calculated day data
    def month_data
      return @data unless @data.nil?
      @data = Array.new size do |index|
        at(index + 1).freeze
      end.freeze
    end

    def group_offsets
      @config[:group_offsets]
    end

    # Get the offset. If there is a :group_cycle for a group then it will be returned
    # Else the shift model cycle.
    def group_shift_cycle(group)
      if @config.key?(:group_cycles) && @config[:group_cycles].key?(group)
        return @config[:group_cycles][group]
      end
      @config[:cycle]
    end

    # Check if the day is a closing day
    def closed?(day)
      return true if @month == 12 && (24..26).include?(day)
      if @month == 3 || @month == 4
        days_in = day + (month == 4 ? 31 : 0)
        return easter.include?(days_in)
      end
      false
    end
end
