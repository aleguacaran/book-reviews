import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="character-counter"
export default class extends Controller {
  static targets = ["input", "counter"]
  static values = { max: Number }

  connect() {
    this.updateCounter()
  }

  updateCounter() {
    const currentLength = this.inputTarget.value.length
    const maxLength = this.maxValue || parseInt(this.inputTarget.getAttribute('maxlength')) || 1000

    this.counterTarget.textContent = `${currentLength}/${maxLength}`

    // Change color based on usage
    if (currentLength >= maxLength * 0.9) {
      this.counterTarget.classList.add('text-danger')
      this.counterTarget.classList.remove('text-warning', 'text-muted')
    } else if (currentLength >= maxLength * 0.7) {
      this.counterTarget.classList.add('text-warning')
      this.counterTarget.classList.remove('text-danger', 'text-muted')
    } else {
      this.counterTarget.classList.add('text-muted')
      this.counterTarget.classList.remove('text-danger', 'text-warning')
    }
  }
}
