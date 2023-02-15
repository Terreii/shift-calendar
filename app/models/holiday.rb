class Holiday < PublicEvent
  def date
    return nil if duration.nil?
    duration.begin
  end

  def date=(new_date)
    self.duration = new_date..new_date
  end
end
