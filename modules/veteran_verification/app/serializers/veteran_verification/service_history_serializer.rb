# frozen_string_literal: true

module VeteranVerification
  class ServiceHistorySerializer < ActiveModel::Serializer
    attributes :branch_of_service, :start_date, :end_date, :dischange_status, :deployments

    def id
      nil
    end

  end
end
