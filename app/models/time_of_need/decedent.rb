module TimeOfNeed
  class Decedent < TimeOfNeed::Base
    attribute :firstName, String
    attribute :lastName, String
    attribute :middleName, String

    def self.permitted_params
      [:firstName, :lastName, :middleName]
    end
  end
end
