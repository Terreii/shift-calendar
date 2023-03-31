import { Controller } from "@hotwired/stimulus"
import { Tooltip } from "bootstrap"

// Connects to data-controller="tooltip"
export default class extends Controller {
  static targets = [ "tooltip" ]
  #targets = new WeakMap()

  tooltipTargetConnected(element) {
    const tooltip = new Tooltip(element)
    #targets.set(element, tooltip)
  }

  tooltipTargetDisconnected(element) {
    const tooltip = #targets.get(element)
    tooltip?.dispose()
  }
}
