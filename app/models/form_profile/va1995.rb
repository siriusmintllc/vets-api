# frozen_string_literal: true

class FormProfile::VA1995 < FormProfile
  def prefill(user)
    super
  end

  def metadata
    {
      version: 0,
      prefill: true,
      returnUrl: '/applicant/information'
    }
  end
end
