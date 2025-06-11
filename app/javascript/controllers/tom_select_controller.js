import { Controller } from "@hotwired/stimulus";
import TomSelect from "tom-select"

export default class extends Controller {
  connect() {
    new TomSelect(this.element, {
      maxItems: 4,
      plugins: ['remove_button']
      // plugins: {
      //   remove_button:{
      //     title:'Remove this item',
      //   }
      // }
      })
  };
}