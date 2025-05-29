import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]

  connect() {
    if (this.inputTarget.value) {
      this.updateSelectedAvatar(this.inputTarget.value)
    }
  }

  select(event) {
    const avatar = event.currentTarget.dataset.avatar
    this.inputTarget.value = avatar
    this.updateSelectedAvatar(avatar)
  }

  updateSelectedAvatar(avatar) {
    this.previewTargets.forEach((preview) => {
      const isSelected = preview.dataset.avatar === avatar
      preview.classList.toggle('selected', isSelected)
    })
  }
}
