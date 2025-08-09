# frozen_string_literal: true

# ActiveRecord model for books
class Book < ApplicationRecord
  validates :title, :author, :published_at, presence: true

  has_many :reviews, -> { from_active_users }, dependent: :destroy

  def rating
    return 'Insufficient reviews' if reviews.count < 3

    avg_rating
  end

  private

  def avg_rating
    valid_reviews = reviews.pluck(:rating)
    sum = valid_reviews.sum
    count = valid_reviews.count
    (sum.to_f / count).round(1)
  end
end
