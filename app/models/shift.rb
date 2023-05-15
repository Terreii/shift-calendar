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

  # Returns an array with the count of days every group works in this month.
  def work_days_count
    return @work_data unless @work_data.nil?
    work_data = Array.new(groups, 0)
    month_data.each do |data|
      data[:shifts].each_with_index do |shift, index|
        work_data[index] += 1 unless shift == :free
      end
    end
    @work_data = work_data.freeze
  end

  # Returns a tuple of the current shift symbol and a date.
  # The date is today or yesterday, depending on the day the shift started.
  # It always returns the tuple, even if this shift is not for the current month.
  def current_working_shift
    now = Time.zone.now
    hour = now.hour
    key, value = shifts_times.find do |key, times|
      start = times[:start]
      finish = times[:finish]
      if start[0] > finish[0] # if shift goes into the next day
        next start[0] <= hour || finish[0] > hour
      end
      start[0] <= hour && finish[0] > hour
    end
    date = now.to_date
    start_date = value[:start][0] > value[:finish][0] && hour < value[:finish][0] ? date.yesterday : date
    [key, start_date]
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
      is_closed = @config[:closing_days].any? do |closing_day|
        if closing_day.key? :date
          month, day_in_month = closing_day[:date]
          month == @month && day_in_month == day
        else
          false
        end
      end
      return true if is_closed
      if @month == 3 || @month == 4
        days_in = day + (month == 4 ? 31 : 0)
        return easter.include?(days_in)
      end
      false
    end

    # Gauss's Easter algorithm  https://en.wikipedia.org/wiki/Computus#Gauss's_Easter_algorithm
    def easter
      return @easter unless @easter.nil?
      year_float = @year.to_f
      k = @year / 100
      m = 15 + k - (k / 3) - (k / 4)
      n = 5
      a = ((year_float / 19).modulo(1) * 19).round
      b = ((year_float / 4).modulo(1) * 4).round
      c = ((year_float / 7).modulo(1) * 7).round
      d = (((19 * a + m).to_f / 30).modulo(1) * 30).round
      e = (((2 * b + 4 * c + 6 * d + n).to_f / 7.0).modulo(1) * 7).round
      easter_sunday = 22 + d + e
      @easter = (easter_sunday - 2)..(easter_sunday + 1)
    end
end
