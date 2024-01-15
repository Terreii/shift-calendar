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
    }
  }

  breakpointValueChanged() {
    this.resized()
  }

  shouldSetValueChanged() {
    for (const link of this.linkTargets) {
      if (!link.href) continue
      this.setLinkParam(link)
    }
  }

  linkTargetConnected(element) {
    if (element.href) {
      this.setLinkParam(element)
    }
  }

  setLinkParam(link) {
    const url = new URL(link.href)
    if (this.shouldSetValue && !url.searchParams.has(this.nameValue)) {
      url.searchParams.set(this.nameValue, true)
    } else if(!this.shouldSetValue && url.searchParams.has(this.nameValue)) {
      url.searchParams.delete(this.nameValue)
    }

    link.href = url.toString()
  }
}
