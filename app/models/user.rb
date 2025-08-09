# frozen_string_literal: true

# ActiveRecord model for users
class User < ApplicationRecord
  has_many :reviews, dependent: :destroy

  validates :name, :status, presence: true

  enum :status, { active: 'active', banned: 'banned' }, default: :active

  after_save :update_reviewed_books

  private

  def update_reviewed_books
    return if previous_changes['status'].blank? || reviews.blank?

    book_ids = reviews.pluck(:book_id)
    Book.where(id: book_ids).find_each(&:update_rating!)
  end
end
