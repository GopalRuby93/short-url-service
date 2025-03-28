class ShortUrl < ApplicationRecord
  belongs_to :user, optional:false
  validates :original_url, presence: true
  PERMITTED_ATTRIBUTES = %i[original_url user_id].freeze
end
