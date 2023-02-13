class Holiday < PublicEvent
  def self.all_in_month(year, month)
    PublicEvent.where(type: Holiday.name).all_in_month year, month
  end

  def self.all_in_year(year)
    PublicEvent.where(type: Holiday.name).all_in_year year
  end

  def date
    return nil if duration.nil?
    duration.begin
  end

  def date=(new_date)
    self.duration = new_date..new_date
  end
end
