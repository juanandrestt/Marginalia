import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["preview", "input"]

  connect() {
    // Si un avatar est déjà sélectionné, marquer l'option correspondante
    const currentAvatar = this.inputTarget.value
    if (currentAvatar) {
      this.previewTargets.forEach(preview => {
        if (preview.dataset.avatar === currentAvatar) {
          preview.classList.add('selected')
        }
      })
    }
  }

  select(event) {
    // Retirer la classe selected de tous les avatars
    this.previewTargets.forEach(preview => {
      preview.classList.remove('selected')
    })

    // Ajouter la classe selected à l'avatar cliqué
    event.currentTarget.classList.add('selected')

    // Mettre à jour la valeur du champ caché
    this.inputTarget.value = event.currentTarget.dataset.avatar
  }
}
