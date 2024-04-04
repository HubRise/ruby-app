# frozen_string_literal: true
FactoryBot.define do
  sequence(:ref) { |n| "ref_#{n}" }
end

class Object
  def generate_ref
    FactoryBot.generate(:ref)
  end

  def with_ref(string)
    [string, "-", generate_ref].join
  end
end
