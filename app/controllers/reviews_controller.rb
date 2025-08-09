# frozen_string_literal: true

# Controller actions for reviews
class ReviewsController < ApplicationController
  before_action :set_book
  before_action :set_review, only: %i[edit update destroy]

  rescue_from ActiveRecord::RecordNotFound do |_exception|
    flash[:error] = 'Review not found'
    redirect_to @book
  end

  # GET /books/:book_id/reviews/new
  def new
    @review = @book.reviews.build
    @users = User.active
  end

  # GET /books/:book_id/reviews/:id/edit
  def edit
    @users = User.active
  end

  # POST /books/:book_id/reviews
  def create
    @review = @book.reviews.build(review_params)

    respond_to do |format|
      if @review.save
        format.html { redirect_to @book, notice: 'Review was successfully created.' }
        format.json { render json: @review, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/:book_id/reviews/:id
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @book, notice: 'Review was successfully updated.' }
        format.json { render json: @review, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/:book_id/reviews/:id
  def destroy
    @review.destroy!

    respond_to do |format|
      format.html { redirect_to @book, status: :see_other, notice: 'Review was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  def set_book
    @book = Book.find(params.expect(:book_id))
  end

  def set_review
    @review = @book.reviews.find(params.expect(:id))
  end

  def review_params
    params.expect(review: %i[user_id rating comment])
  end
end
