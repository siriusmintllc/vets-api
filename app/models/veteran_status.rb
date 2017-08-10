# frozen_string_literal: true
require 'emis/veteran_status_service'
require 'common/models/redis_store'
require 'common/models/concerns/cache_aside'

class VeteranStatus < Common::RedisStore
  include Common::CacheAside

  redis_config_key :veteran_status_response

  attr_accessor :user

  attr_accessor :emis_response

  def self.for_user(user)
    veteran_status = VeteranStatus.new
    veteran_status.user = user
    veteran_status
  end

  def veteran?
    raise VeteranStatus::Unauthorized unless @user.loa3?
    any_veteran_indicator?(emis_response.items.first)
  end

  def post911_combat_indicator?
    emis_response.items.first.post911_combat_indicator == 'Y'
  end

  private

  def any_veteran_indicator?(item)
    item.post911_deployment_indicator == 'Y' ||
      item.post911_combat_indicator == 'Y' ||
      item.pre911_deployment_indicator == 'Y'
  end

  def emis_response
    @emis_response ||= lambda do
      response = response_from_redis_or_service
      raise response.error if response.error?
      raise VeteranStatus::RecordNotFound if !response.error? && response.empty?

      response
    end.call
  end

  def response_from_redis_or_service
    do_cached_with(key: @user.uuid) do
      unless @user.edipi || @user.icn
        raise ArgumentError, 'could not make veteran status call, user has no edipi or icn'
      end
      options = {}
      @user.edipi ? options[:edipi] = @user.edipi : options[:icn] = @user.icn
      veteran_status_service.get_veteran_status(options)
    end
  end

  def veteran_status_service
    @service ||= EMIS::VeteranStatusService.new
  end

  class RecordNotFound < StandardError
  end

  class NotAuthorized < StandardError
  end
end
