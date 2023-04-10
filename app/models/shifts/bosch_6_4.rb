class Shifts::Bosch64 < Shifts::Base
  mattr_reader :groups, :identifier

  @@identifier = "bosch-6-4"
  @@start_date = Date.new(2010, 1, 1)
  @@group_offsets = {
    1 => 3,
    2 => 5,
    3 => 7,
    4 => 9,
    5 => 1
  }
  @@shift_cycle_length = 10
  @@groups = 5

  # Get shifts data for a day im month.
  # Returns a Hash with shifts: Array => Shifts of every group
  # And with closed: Boolean => If on that day is a closing day
  def at(day)
    days = days_in_cycle(day)
    shifts = Array.new @@groups do |index|
      group = index + 1
      days_offsetted = days + group_offset(group)
      days_offsetted -= @@shift_cycle_length if days_offsetted >= @@shift_cycle_length
      shift group, days_offsetted
    end
    { closed: closed?(day), shifts: }
  end

  private

  def days_in_cycle(day)
    days_since_start = Date.new(@year, @month, day.to_i) - @@start_date
    days_since_start.to_i % @@shift_cycle_length
  end

  def shift(group, offset)
    return night_shifts(offset) if group == 1
    return day_shifts(offset) if group == 2
    full_shifts(offset)
  end

  def night_shifts(offset)
    case offset
    when 0..1
      :evening
    when 2..5
      :night
    else
      :free
    end
  end

  def day_shifts(offset)
    case offset
    when 0..3
      :morning
    when 4..5
      :evening
    else
      :free
    end
  end

  def full_shifts(offset)
    case offset
    when 0..1
      :morning
    when 2..3
      :evening
    when 4..5
      :night
    else
      :free
    end
  end

  def group_offset(group)
    @@group_offsets[group] if @@group_offsets.has_key? group
  end
end
