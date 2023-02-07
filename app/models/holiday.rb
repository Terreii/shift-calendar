class Holiday < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2 }
  validates :date, presence: true

  def self.all_in_month(year, month)
    days = Time.days_in_month month, year
    date_range = Date.new(year, month, 1)..Date.new(year, month, days)
    where(date: date_range).order(:date).group_by(&:date)
  end

  def self.all_in_year(year)
    date_range = Date.new(year, 1, 1)..Date.new(year, 12, 31)
    where(date: date_range).order(:date).group_by(&:date)
  end
end
