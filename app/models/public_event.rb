class PublicEvent < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2 }
  validates :duration, presence: true

  # Queries all PublicEvents of the given month.
  # Returns them in a Hash grouped by month
  def self.all_in_month(year, month)
    days = Time.days_in_month month, year
    date_range = Date.new(year, month, 1)..Date.new(year, month, days)
    where("duration && ?::daterange", PublicEvent.connection.type_cast(date_range)).group_by { month }
  end

  # Queries all PublicEvents of the given year.
  # Returns them in a Hash grouped by month
  def self.all_in_year(year)
    date_range = Date.new(year, 1, 1)..Date.new(year, 12, 31)
    events = where("duration && ?::daterange", PublicEvent.connection.type_cast(date_range))
    months = Hash.new
    (1..12).each do |month|
      data = []
      days = Time.days_in_month month, year
      month_range = Date.new(year, month, 1)..Date.new(year, month, days)
      events.each do |event|
        data << event if event.duration.overlaps? month_range
      end
      months[month] = data
    end
    months
  end
end
