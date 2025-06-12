import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "list"]

  connect() {
    this.hideList()
    document.addEventListener("click", this.outsideClick)
  }

  disconnect() {
    document.removeEventListener("click", this.outsideClick)
  }

  search() {
    this.performSearch()
  }

  performSearch() {
    const query = this.inputTarget.value.trim()
    if (query.length < 1) {
      this.hideList()
      return
    }

    fetch(`/books?query=${encodeURIComponent(query)}`, {
      headers: { 'Accept': 'text/html' }
    })
      .then(response => response.text())
      .then(html => {
        const parser = new DOMParser()
        const doc = parser.parseFromString(html, 'text/html')
        const bookNodes = doc.querySelectorAll('.search-suggestion')

        if (bookNodes.length > 0) {
          this.listTarget.innerHTML = ''
          bookNodes.forEach(node => {
            const title = node.dataset.title
            const author = node.dataset.author
            const cover = node.dataset.cover
            const link = node.closest('a')?.href

            const li = document.createElement('li')
            li.className = 'list-group-item d-flex align-items-center suggestion-item bg-white'
            li.style.cursor = 'pointer'
            li.innerHTML = `
              <img src="${cover}" alt="" style="width: 40px; height: 60px; object-fit: cover; margin-right: 10px; border-radius: 4px;">
              <div>
                <div style="font-weight: 500; color: #751F1F;">${title}</div>
                <div style="font-size: 13px; color: #000;">${author}</div>
              </div>
            `
            li.addEventListener('click', () => {
              window.location.href = link
            })

            this.listTarget.appendChild(li)
          })
          this.showList()
        } else {
          this.hideList()
        }
      })
      .catch(error => {
        console.error("Erreur :", error)
        this.hideList()
      })
  }

  hideList() {
    this.listTarget.style.display = 'none'
    this.listTarget.innerHTML = ''
  }

  showList() {
    this.listTarget.style.display = 'block'
  }

  outsideClick = (e) => {
    if (!this.element.contains(e.target)) {
      this.hideList()
    }
  }
}