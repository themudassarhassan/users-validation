import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  submit() {
    if (this.element.users_csv.files.length === 0) { return }

    Turbo.navigator.submitForm(this.element)
  }
}
