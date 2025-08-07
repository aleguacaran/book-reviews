# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    author { Faker::Book.author }
    published_at { Faker::Date.between(from: 2.years.ago, to: Date.current) }
    description { Faker::Lorem.paragraph(sentence_count: 3) }
  end
end
