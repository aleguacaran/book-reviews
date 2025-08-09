import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="star-rating"
export default class extends Controller {
  static targets = ["star", "input"]
  static values = { rating: Number }

  connect() {
    this.updateStars()
  }

  ratingValueChanged() {
    this.updateStars()
  }

  hover(event) {
    const value = parseInt(event.currentTarget.dataset.value)
    this.highlightStars(value)
  }

  leave() {
    this.updateStars()
  }

  click(event) {
    const value = parseInt(event.currentTarget.dataset.value)
    this.ratingValue = value

    // Update the hidden input field
    const ratingInput = document.querySelector('.rating-input')
    if (ratingInput) {
      ratingInput.value = value
    }
  }

  highlightStars(rating) {
    this.starTargets.forEach((star, index) => {
      if (index < rating) {
        star.classList.add('active')
        star.classList.remove('filled')
      } else {
        star.classList.remove('active', 'filled')
      }
    })
  }

  updateStars() {
    this.starTargets.forEach((star, index) => {
      if (index < this.ratingValue) {
        star.classList.add('filled')
        star.classList.remove('active')
      } else {
        star.classList.remove('active', 'filled')
      }
    })
  }
}
