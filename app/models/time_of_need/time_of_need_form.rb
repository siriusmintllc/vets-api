module TimeOfNeed
  class TimeOfNeedForm < TimeOfNeed::Base
    attribute :decedent, TimeOfNeed::Decedent
    attribute :contact, TimeOfNeed::Contact
    attribute :funeral_home, TimeOfNeed::FuneralHome
    attribute :next_of_kin, TimeOfNeed::NextOfKin
    attribute :veteran, TimeOfNeed::Veteran
    attribute :attachment, TimeOfNeed::Attachment
  end
end
