// app/javascript/controllers/time_selector_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dateInput", "timeInput", "hiddenInput"];

  connect() {
    this.updateDateTime();
  }

  updateDateTime() {
    const dateValue = this.dateInputTarget.value;
    const timeValue = this.timeInputTarget.value;
    if (dateValue && timeValue) {
      this.hiddenInputTarget.value = `${dateValue}T${timeValue}`;
    }
  }
}
