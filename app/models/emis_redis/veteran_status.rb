# frozen_string_literal: true

require 'emis/veteran_status_service'

module EMISRedis
  # Much of this class depends on the Title 38 Status codes, which are:
  #
  # V1 = Title 38 Veteran
  # V2 = VA Beneficiary
  # V3 = Military Person, not Title 38 Veteran, NOT DoD-Affiliated
  # V4 = Non-military person
  # V5 = EDI PI Not Found in VADIR (service response only not stored in table)
  # V6 = Military Person, not Title 38 Veteran, DoD-Affiliated
  #
  # @see https://github.com/department-of-veterans-affairs/vets.gov-team/blob/master/Products/SiP-Prefill/Prefill/eMIS_Integration/eMIS_Documents/MIS%20Service%20Description%20Document.docx
  #
  class VeteranStatus < Model
    CLASS_NAME = 'VeteranStatusService'

    def veteran?
      title38_status == 'V1'
    end

    def title38_status
      validated_response&.title38_status_code
    end

    # Returns boolean for user being/not being considered a military person, by eMIS,
    # based on their Title 38 Status Code.
    #
    # @return [Boolean]
    #
    def military_person?
      title38_status == 'V3' || title38_status == 'V6'
    end

    class NotAuthorized < StandardError
    end

    class RecordNotFound < StandardError
    end

    private

    # The emis_response call in this method returns an instance of the
    # EMIS::Responses::GetVeteranStatusResponse class. This response's `items`
    # is an array of one hash.  For example:
    #   [
    #     {
    #       :title38_status_code          => "V1",
    #       :post911_deployment_indicator => "Y",
    #       :post911_combat_indicator     => "N",
    #       :pre911_deployment_indicator  => "N"
    #     }
    #   ]
    #
    # @return [Hash] A hash of veteran status properties
    #
    def validated_response
      raise VeteranStatus::NotAuthorized unless @user.loa3?
      response = emis_response('get_veteran_status')

      raise VeteranStatus::RecordNotFound if response.empty?
      response.items.first
    end
  end
end
