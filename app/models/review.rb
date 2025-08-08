# frozen_string_literal: true

# ActiveRecord model for book reviews
class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, presence: true, length: { maximum: 1000 }

  default_scope { order(created_at: :desc) }
  scope :from_active_users, -> { joins(:user).where(users: { status: :active }) }
end
