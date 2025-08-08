# frozen_string_literal: true

# ActiveRecord model for book reviews
class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :rating, :comment, presence: true
  validates :rating, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5,
                                    message: 'must be between 1 and 5' }
  validates :comment, length: { maximum: 1000 }

  default_scope { order(created_at: :desc) }
  scope :from_active_users, -> { joins(:user).where(users: { status: :active }) }
end
