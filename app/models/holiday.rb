class Holiday < PublicEvent
  validate do |holiday|
    errors.add(:duration, 'Must be a single day') unless holiday.duration.nil? || holiday.duration.count == 1
  end

  def date
    return nil if duration.nil?
    duration.begin
  end

  def date=(new_date)
    self.duration = new_date..new_date
  end
end
