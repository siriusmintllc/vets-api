module V0
  module TimeOfNeed
    class TimeOfNeedSubmissionController < TimeOfNeedController
      def create
        form = ::TimeOfNeed::TimeOfNeedSubmission.new(time_of_need_form_params)
        #todo: use the service to post to Salesforce

      end

      private

      # need to restrict params
      def time_of_need_form_params
        params.require('newCase').permit(
          :burial_activity_type,
          :remains_type,
          :emblem_code,
          :subsequent_indicator,
          :liner_type,
          :liner_size,
          :cremains_type,
          :cemetery_type,
          # decedent: ::TimeOfNeed::Decedent.permitted_params,
          # contact: ::TimeOfNeed::Contact.permitted_params,
          # funeral_home: ::TimeOfNeed::FuneralHome.permitted_params,
          # next_of_kin: ::TimeOfNeed::NextOfKin.permitted_params,
          # veteran: ::TimeOfNeed::Veteran.permitted_params,
          # attachment: ::TimeOfNeed::Attachment.permitted_params
        )
      end
    end
  end
end
