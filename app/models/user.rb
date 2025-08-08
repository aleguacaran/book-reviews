# frozen_string_literal: true

# ActiveRecord model for users
class User < ApplicationRecord
  validates :name, :status, presence: true

  enum status: { active: :active, banned: :banned }, default: :active
end
