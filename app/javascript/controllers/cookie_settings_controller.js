import { Controller } from "@hotwired/stimulus";

// Opens Klaro CMP; avoids inline onclick (blocked by CSP script-src for event handlers).
export default class extends Controller {
  open(event) {
    event.preventDefault();
    if (typeof window.klaro !== "undefined") {
      window.klaro.show(undefined, true);
    }
  }
}
