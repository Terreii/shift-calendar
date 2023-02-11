class PublicEvent < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2 }
  validates :duration, presence: true

  # Queries all PublicEvents of the given month.
  # Returns them in a Hash grouped by every date in their duration
  def self.all_in_month(year, month)
    days = Time.days_in_month month, year
    date_range = Date.new(year, month, 1)..Date.new(year, month, days)
    events = Hash.new
    where("duration && ?::daterange", PublicEvent.connection.type_cast(date_range)).each do |event|
      event.duration.each do |day|
        events[day] = event
      end
    end
    events
  end

  # Queries all PublicEvents of the given year.
  # Returns them in a Hash grouped by every date in their duration
  def self.all_in_year(year)
    date_range = Date.new(year, 1, 1)..Date.new(year, 12, 31)
    events = Hash.new
    where("duration && ?::daterange", PublicEvent.connection.type_cast(date_range)).each do |event|
      # grouped by Date should be faster, because there are less days with event, then days with events
      # In the View it can then be looked up by events[Date]
      event.duration.each do |day|
        events[day] = event
      end
    end
    events
  end
end
