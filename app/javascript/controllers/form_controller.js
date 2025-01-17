import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  submit() {
    if (this.isFileAttached()) {
      Turbo.navigator.submitForm(this.element);
      return;
    }

    alert("Please select a file before submitting.");
  }

  isFileAttached() {
    return this.element.users_csv && this.element.users_csv.files.length !== 0;
  }
}
