# frozen_string_literal: true

class Book < ApplicationRecord
  validates :title, :author, :published_at, presence: true

  attribute :reviews, :integer, array: true, default: []

  def rating
    avg = average_rating_from_valid_reviews
    return 'Insufficient reviews' if avg.nil?

    avg
  end

  private

  def average_rating_from_valid_reviews
    return nil if reviews.count < 3

    sum = reviews.sum
    count = reviews.count
    (sum.to_f / count).round(1)
  end
end
