class PublicEvent < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2 }
  validates :duration, presence: true

  # Queries all PublicEvents of the given month.
  # Like Hash#group_by but grouped by every day in the duration
  def self.all_in_month(year, month)
    days = Time.days_in_month month, year
    date_range = Date.new(year, month, 1)..Date.new(year, month, days)
    events = Hash.new
    where("duration && ?::daterange", PublicEvent.connection.type_cast(date_range)).each do |event|
      event.duration.each do |day|
        if events.has_key? day
          events[day] << event
        else
          events[day] = [event]
        end
      end
    end
    events
  end

  # Queries all PublicEvents of the given year.
  # Like Hash#group_by but grouped by every day in the duration
  def self.all_in_year(year)
    date_range = Date.new(year, 1, 1)..Date.new(year, 12, 31)
    events = Hash.new
    where("duration && ?::daterange", PublicEvent.connection.type_cast(date_range)).each do |event|
      # grouped by Date should be faster, because there are less days with event, then days with events
      # In the View it can then be looked up by events[Date]
      event.duration.each do |day|
        if events.has_key? day
          events[day] << event
        else
          events[day] = [event]
        end
      end
    end
    events
  end
end
