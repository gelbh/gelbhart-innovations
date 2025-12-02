/**
 * Theme Mode Switch Component
 * Toggle switch for light/dark mode
 * Uses modern theme-mode API with Bootstrap 5.3 native color modes
 * Turbo-aware: works with both initial page load and Turbo navigation
 */

import { setTheme, getTheme, THEME_DARK } from "../theme-mode";

const themeModeSwitch = (() => {
  /**
   * Initialize the theme mode switch component
   */
  function initialize() {
    const modeSwitch = document.querySelector('[data-bs-toggle="mode"]');

    if (modeSwitch === null) return;

    const checkbox = modeSwitch.querySelector(".form-check-input");
    if (!checkbox) return;

    const html = document.documentElement;
    const currentTheme = getTheme();

    // Set initial checkbox state based on current theme
    checkbox.checked = currentTheme === THEME_DARK;

    // Ensure theme is applied (in case it wasn't set yet)
    if (currentTheme === THEME_DARK) {
      html.setAttribute("data-bs-theme", THEME_DARK);
      html.classList.add("dark-mode");
    } else {
      html.setAttribute("data-bs-theme", "light");
      html.classList.remove("dark-mode");
    }

    // Handle toggle click
    // Note: Both our handler and theme.min.js may attach to this element
    // Our handler ensures both data-bs-theme attribute and .dark-mode class are set
    modeSwitch.addEventListener("click", (e) => {
      // Toggle state is already updated by browser before this handler runs
      const newTheme = checkbox.checked ? THEME_DARK : "light";

      // Use our modern theme API (sets both attribute and class, saves to localStorage)
      // This ensures Bootstrap 5.3 compatibility and backward compatibility
      setTheme(newTheme);

      // Explicitly ensure DOM is updated immediately for visual feedback
      // This ensures our implementation takes precedence over theme.min.js if it runs
      if (newTheme === THEME_DARK) {
        html.setAttribute("data-bs-theme", THEME_DARK);
        html.classList.add("dark-mode");
      } else {
        html.setAttribute("data-bs-theme", "light");
        html.classList.remove("dark-mode");
      }
    });
  }

  // Initialize on DOMContentLoaded (initial page load)
  document.addEventListener("DOMContentLoaded", initialize);

  // Initialize on Turbo load (Turbo navigation)
  document.addEventListener("turbo:load", initialize);
})();

export default themeModeSwitch;
