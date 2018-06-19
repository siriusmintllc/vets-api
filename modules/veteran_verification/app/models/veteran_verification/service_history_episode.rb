module VeteranVerification
  class ServiceHistoryEpisode
    include ActiveModel::Serialization
    include Virtus.model

    attribute :id, Digest::UUID
    attribute :branch_of_service, String
    attribute :end_date, Date
    attribute :deployments, Array
    attribute :discharge_type, String
    attribute :start_date, Date

    def self.for_user(user)
      emis = EMISRedis::MilitaryInformation.for_user(user)
      handle_errors!(emis)
      episodes(emis, user)
    end

    def self.handle_errors!(emis)
      raise_error! unless emis.service_history.is_a?(Array)
    end

    def self.raise_error!
      raise Common::Exceptions::BackendServiceException.new(
              'EMIS_HIST502',
              source: self.class.to_s
            )
    end

    def self.episodes(emis, user)
      emis.service_episodes_by_date.map do |episode|
        deps = emis.deployments.select do |dep|
          dep.begin_date >= episode.begin_date and dep.end_date <= episode.end_date
        end.map do |dep|
          {
            start_date: dep.begin_date,
            end_date: dep.end_date,
            location: dep.locations[0].iso_alpha3_country,
          }
        end

        identifier = Digest::UUID.uuid_v5(
          'gov.vets.service-history-episodes',
          "#{user.uuid}-#{episode.begin_date}-#{episode.end_date}"
        )

        ServiceHistoryEpisode.new(
          id: identifier,
          branch_of_service: emis.build_service_branch(episode),
          end_date: episode.end_date,
          deployments: deps,
          discharge_type: episode.discharge_character_of_service_code,
          start_date: episode.begin_date
        )
      end
    end

    def discharge_status
      EMISRedis::MilitaryInformation::DISCHARGE_TYPES[discharge_type] || 'other'
    end
  end
end
