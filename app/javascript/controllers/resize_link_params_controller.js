import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="resize-link-params"
export default class extends Controller {
  static targets = [ 'link' ]
  static values = {
    name: String,
    breakpoint: {
      type: Number,
      default: 768 // Bootstrap medium breakpoint  https://getbootstrap.com/docs/5.3/layout/breakpoints/
    },
    shouldSet: Boolean,
  }

  connect() {
    this.resized()
  }

  resized() {
    const shouldSet = window.innerWidth >= this.breakpointValue

    if (shouldSet !== this.shouldSetValue) {
      this.shouldSetValue = shouldSet

      for (const link of this.linkTargets) {
        if (!link.href) continue

        const url = new URL(link.href)
        if (shouldSet && !url.searchParams.has(this.nameValue)) {
          url.searchParams.set(this.nameValue, true)
        } else if(!shouldSet && url.searchParams.has(this.nameValue)) {
          url.searchParams.delete(this.nameValue)
        }

        link.href = url.toString()
      }
    }
  }
}
