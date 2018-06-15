# frozen_string_literal: true

module VeteranVerification
  class ServiceHistorySerializer < ActiveModel::Serializer
    attribute :service_history

    def id
      nil
    end

    def service_history
      object
    end
  end
end
