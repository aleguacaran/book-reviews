# frozen_string_literal: true

# Create reviews table
class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.integer :rating, null: false
      t.text :comment, null: false, limit: 1000

      t.timestamps
    end
  end
end
