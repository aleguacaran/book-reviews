# frozen_string_literal: true

# ActiveRecord model for book reviews
class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :rating, :comment, presence: true
  # NOTE: Each numericality validation show different message
  validates :rating, numericality: true
  validates :rating, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5,
                                     message: 'must be between 1 and 5', allow_blank: true }
  validates :comment, length: { maximum: 1000 }

  default_scope { order(created_at: :desc) }
  scope :from_active_users, -> { joins(:user).where(users: { status: :active }) }
  scope :from_banned_users, -> { joins(:user).where(users: { status: :banned }) }

  after_save :update_book_rating
  after_destroy :update_book_rating

  private

  def update_book_rating
    book.update_rating!
  end
end
