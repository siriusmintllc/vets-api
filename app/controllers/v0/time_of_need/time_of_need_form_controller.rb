module V0
  module TimeOfNeed
    class TimeOfNeedFormController < TimeOfNeedController
      def create
        form = ::TimeOfNeed::TimeOfNeedForm.new(time_of_need_form_params)
        #todo: use the service to post to Salesforce
      end

      private

      # need to restrict params
      def time_of_need_form_params
        params.require(:time_of_need).permit(
          decedent: ::TimeOfNeed::Decedent.permitted_params,
          contact: ::TimeOfNeed::Contact.permitted_params,
          funeral_home: ::TimeOfNeed::FuneralHome.permitted_params,
          next_of_kin: ::TimeOfNeed::NextOfKin.permitted_params,
          veteran: ::TimeOfNeed::Veteran.permitted_params,
          attachment: ::TimeOfNeed::Attachment.permitted_params
        )
      end
    end
  end
end
