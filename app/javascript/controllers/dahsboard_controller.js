import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    tooltipTriggerList.map(function (tooltipTriggerEl) {
      return new bootstrap.Tooltip(tooltipTriggerEl)
    });

    // Animation des stats
    const stats = document.querySelectorAll('.stat-counter');
    stats.forEach(stat => {
      stat.classList.add('animate');
    });
  }
}