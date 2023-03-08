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
class SchoolBreak < PublicEvent
end
