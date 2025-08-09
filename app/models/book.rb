# frozen_string_literal: true

# ActiveRecord model for books
class Book < ApplicationRecord
  validates :title, :author, :published_at, presence: true

  has_many :reviews, -> { from_active_users }, dependent: :destroy

  def displayed_rating
    rating.nil? ? 'Insufficient reviews' : rating
  end

  def update_rating!
    # NOTE: Reload is needed in case of multiple reviews in same request (only in tests)
    valid_reviews = reviews.reload.pluck(:rating)

    if valid_reviews.count < 3
      update_column(:rating, nil)
    else
      avg_rating = (valid_reviews.sum.to_f / valid_reviews.count).round(1)
      update_column(:rating, avg_rating)
    end
  end
end
