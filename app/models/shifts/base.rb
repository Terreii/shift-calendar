class Shifts::Base
  include Enumerable

  def self.create(key, options)
    case key
    when "bosch-6-6", :bosch66
      Shifts::Bosch66
    when "bosch-6-4", :bosch64
      Shifts::Bosch64
    else
      return nil
    end.new(**options)
  end

  attr_reader :year, :month

  def initialize(year:, month:)
    @year = year.to_i
    @month = month.to_i
  end

  def groups
    0
  end

  def at(day)
    []
  end

  def [](day)
    at(day)
  end

  def size
    Time.days_in_month(@month, @year)
  end
  alias_method :length, :size

  def each
    month_data.each do |data|
      yield data
    end
    self
  end

  def each_with_date
    each_with_index do |data, index|
      yield data, Date.new(@year, @month, index + 1)
    end
  end

  def work_days_count
    return @work_data unless @work_data.nil?
    work_data = Array.new(groups, 0)
    month_data.each_with_index do |data, index|
      data.each_with_index do |shift, index|
        work_data[index] += 1 unless shift == :free
      end
    end
    @work_data = work_data.freeze
  end

  def current_working_shift
    now = Time.zone.now
    date = now.to_date
    case now.hour
    when 0..5
      # night shift of last day
      return :night, date.yesterday
    when 6..13
      return :morning, date
    when 14..21
      return :evening, date
    else
      return :night, date
    end
  end

  def shifts_times
    {
      morning: {
        start: [6, 0],
        finish: [14, 30]
      },
      evening: {
        start: [14, 0],
        finish: [22, 30]
      },
      night: {
        start: [22, 0],
        finish: [6, 30]
      }
    }
  end

  private

    def month_data
      return @data unless @data.nil?
      @data = Array.new size do |index|
        at(index + 1).freeze
      end.freeze
    end
end
