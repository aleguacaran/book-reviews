# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    book
    user

    rating { rand(1..5) }
    comment { Faker::Lorem.paragraph(sentence_count: 3) }

    trait :excellent do
      rating { 5 }
      comment { 'This book is absolutely amazing! I couldn\'t put it down.' }
    end

    trait :poor do
      rating { 1 }
      comment { 'Really disappointed with this book. Would not recommend.' }
    end

    trait :from_banned_user do
      association :user, factory: [:user, :banned]
    end
  end
end
