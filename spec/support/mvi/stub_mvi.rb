# frozen_string_literal: true
def stub_mvi
  allow_any_instance_of(Mvi).to receive(:query_and_cache_profile).and_return(
    build(:va_profile_lincoln)
  )
end

def stub_mvi_not_found
  allow_any_instance_of(Mvi).to receive(:query_and_cache_profile).and_raise(MVI::Errors::RecordNotFound)
end
