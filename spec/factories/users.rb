# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    status { :active }

    trait :banned do
      status { :banned }
    end
  end
end
