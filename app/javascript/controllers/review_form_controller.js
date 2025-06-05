import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["ratingInput", "emotionInput", "characterInput"]

  selectStar(event) {
    const value = parseInt(event.currentTarget.dataset.value)
    this.ratingInputTarget.value = value
    for (let i = 1; i <= 5; i++) {
      const star = document.getElementById(`star-${i}`)
      star.classList.remove("fas")
      star.classList.add("far")
    }
    for (let i = 1; i <= value; i++) {
      const star = document.getElementById(`star-${i}`)
      star.classList.remove("far")
      star.classList.add("fas")
    }
  }

  selectEmotion(event) {
    const emotion = event.currentTarget.dataset.emotion
    const selectedId = event.currentTarget.dataset.id
    this.emotionInputTarget.value = emotion
    document.querySelectorAll("[id^='emotion-btn-']").forEach(btn => btn.classList.remove("active"))
    document.getElementById(`emotion-btn-${selectedId}`).classList.add("active")
  }

  selectCharacter(event) {
    const name = event.currentTarget.dataset.character
    const selectedId = event.currentTarget.dataset.id
    this.characterInputTarget.value = name
    document.querySelectorAll("[id^='char-btn-']").forEach(btn => btn.classList.remove("active"))
    document.getElementById(`char-btn-${selectedId}`).classList.add("active")
  }
}