# frozen_string_literal: true

module VeteranVerification
  module V0
    class ServiceHistoryController < ApplicationController
      before_action { authorize :emis, :access? }

      def show
        response = ServiceHistory.from_user(@current_user)

        render json: response, serializer: ServiceHistorySerializer
      end
    end
  end
end
