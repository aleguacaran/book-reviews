# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    author { Faker::Book.author }
    published_at { Faker::Date.between(from: 2.years.ago, to: Date.current) }

    trait :with_reviews do
      after :build do |instance|
        build_list(:review, 4, book: instance)
        build_list(:review, 1, :from_banned_user, book: instance)
      end
    end
  end
end
