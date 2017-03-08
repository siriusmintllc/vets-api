# frozen_string_literal: true
require 'common/models/redis_store'
require 'mvi/service_factory'

class Mvi < Common::RedisStore
  redis_store REDIS_CONFIG['mvi_store']['namespace']
  redis_ttl REDIS_CONFIG['mvi_store']['each_ttl']
  redis_key :uuid

  attr_accessor :user
  attribute :uuid
  attribute :response

  def self.from_user(user)
    mvi = Mvi.find_or_build(user.uuid)
    mvi.user = user
    mvi
  end

  def edipi
    select_source_id(:edipi)
  end

  def icn
    select_source_id(:icn)
  end

  def participant_id
    select_source_id(:vba_corp_id)
  end

  def mhv_correlation_id
    mhv_correlation_ids&.first
  end

  def va_profile
    return nil unless @user.loa3?
    @memoize_response ||= response || query_and_cache_profile
  end

  private

  def mhv_correlation_ids
    return nil if va_profile.nil?
    ids = va_profile.mhv_ids
    ids = [] unless ids
    ids.map { |mhv_id| mhv_id.split('^')&.first }.compact
  end

  def select_source_id(correlation_id)
    return nil if va_profile.nil? || va_profile[correlation_id].nil?
    va_profile[correlation_id].split('^')&.first
  end

  def mvi_service
    @service ||= MVI::ServiceFactory.get_service(mock_service: Settings.mvi.mock)
  end

  def create_message
    raise Common::Exceptions::ValidationErrors, @user unless @user.valid?(:loa3_user)
    given_names = [@user.first_name]
    given_names.push @user.middle_name unless @user.middle_name.nil?
    MVI::Messages::FindCandidateMessage.new(
      given_names,
      @user.last_name,
      @user.birth_date,
      @user.ssn,
      @user.gender
    )
  end

  def query_and_cache_profile
    query_response = mvi_service.find_candidate(create_message)
    return nil unless query_response
    self.response = query_response
    save
    query_response
  rescue MVI::Errors::RecordNotFound
    Rails.logger.error "MVI record not found for user: #{@user.uuid}"
    raise
  rescue Common::Client::Errors::HTTPError => e
    Rails.logger.error "MVI HTTP error code: #{e.code} for user: #{@user.uuid}"
    raise MVI::Errors::ServiceError
  rescue MVI::Errors::ServiceError => e
    Rails.logger.error "MVI service error: #{e.message} for user: #{@user.uuid}"
    raise
  end
end
