# frozen_string_literal: true

# Add rating to books
class AddRatingToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :rating, :float
  end
end
