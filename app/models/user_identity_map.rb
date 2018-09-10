# frozen_string_literal: true

require 'common/models/base'
require 'common/models/redis_store'

class UserIdentityMap < Common::RedisStore
  VALID_TYPES = %w[loa1 loa3]

  redis_store REDIS_CONFIG['user_identity_map_store']['namespace']
  redis_ttl REDIS_CONFIG['user_identity_map_store']['each_ttl']
  redis_key :uuid

  attribute :uuid
  attribute :types # array

  validates :uuid, presence: true
  validate :validate_types

  private

  def validate_types
    return true if types.is_a?(Array) && types.any? && (types - VALID_TYPES).empty?
    errors.add(:types, 'Must be an Array of valid types')
    false
  end

end
