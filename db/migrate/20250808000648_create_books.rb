# frozen_string_literal: true

# Create books table
class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :author, null: false
      t.date :published_at, null: false

      t.timestamps
    end
  end
end
