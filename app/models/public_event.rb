class PublicEvent < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2 }
  validates :duration, presence: true
end
