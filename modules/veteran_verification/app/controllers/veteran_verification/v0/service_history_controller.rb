# frozen_string_literal: true

module VeteranVerification
  module V0
    class ServiceHistoryController < ApplicationController
      before_action { authorize :emis, :access? }

      def index
        response = ServiceHistory.for_user(@current_user).formatted_episodes

        render json: response, each_serializer: ServiceHistorySerializer
      end
    end
  end
end
