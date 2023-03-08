# == Schema Information
#
# Table name: public_events
#
#  id         :bigint           not null, primary key
#  duration   :daterange
#  name       :string
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_public_events_on_duration           (duration) USING gist
#  index_public_events_on_type               (type)
#  index_public_events_on_type_and_duration  (type,duration)
#
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
