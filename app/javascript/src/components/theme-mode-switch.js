/**
 * Theme Mode Switch Component
 * Turbo-aware light/dark mode toggle with Bootstrap 5.3 support
 */

import { setTheme, getTheme, THEME_DARK } from "../theme-mode"

const themeModeSwitch = (() => {
  const initialize = () => {
    const modeSwitch = document.querySelector('[data-bs-toggle="mode"]')
    if (!modeSwitch) return

    const checkbox = modeSwitch.querySelector(".form-check-input")
    if (!checkbox) return

    const html = document.documentElement
    const currentTheme = getTheme()

    // Set initial checkbox state
    checkbox.checked = currentTheme === THEME_DARK

    // Ensure theme is applied
    html.setAttribute("data-bs-theme", currentTheme)
    html.classList.toggle("dark-mode", currentTheme === THEME_DARK)

    // Handle toggle click
    modeSwitch.addEventListener("click", () => {
      const newTheme = checkbox.checked ? THEME_DARK : "light"
      setTheme(newTheme)

      html.setAttribute("data-bs-theme", newTheme)
      html.classList.toggle("dark-mode", newTheme === THEME_DARK)
    })
  }

  document.addEventListener("DOMContentLoaded", initialize)
  document.addEventListener("turbo:load", initialize)
})()

export default themeModeSwitch
