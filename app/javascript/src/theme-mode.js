/**
 * Theme Mode Manager
 * Modern dark mode using Bootstrap 5.3 native color modes
 * Features: data-bs-theme attribute, .dark-mode class fallback,
 * system preference detection, Turbo-aware initialization
 */

const STORAGE_KEY = "theme";
const THEME_DARK = "dark";
const THEME_LIGHT = "light";

/**
 * Get system color scheme preference
 */
const getSystemPreference = () => {
  return window.matchMedia?.("(prefers-color-scheme: dark)").matches
    ? THEME_DARK
    : THEME_LIGHT;
};

/**
 * Get current theme from localStorage or system preference
 */
const getTheme = () => {
  const saved = localStorage.getItem(STORAGE_KEY);
  return saved ?? getSystemPreference();
};

/**
 * Apply theme to document
 * Sets both data-bs-theme attribute and .dark-mode class for compatibility
 */
const applyTheme = (theme) => {
  const { documentElement: html } = document;

  html.setAttribute("data-bs-theme", theme);
  html.classList.toggle("dark-mode", theme === THEME_DARK);
};

/**
 * Initialize theme on page load
 */
const initializeThemeMode = () => applyTheme(getTheme());

/**
 * Set theme and save user preference
 */
const setTheme = (theme) => {
  applyTheme(theme);
  localStorage.setItem(STORAGE_KEY, theme);
};

/**
 * Listen for system preference changes when no manual preference is set
 */
const setupSystemPreferenceListener = () => {
  const mediaQuery = window.matchMedia?.("(prefers-color-scheme: dark)");
  if (!mediaQuery) return;

  const handler = (e) => {
    // Only apply if user hasn't set a manual preference
    if (!localStorage.getItem(STORAGE_KEY)) {
      applyTheme(e.matches ? THEME_DARK : THEME_LIGHT);
    }
  };

  mediaQuery.addEventListener?.("change", handler) ??
    mediaQuery.addListener?.(handler);
};

// Initialize theme
if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", () => {
    initializeThemeMode();
    setupSystemPreferenceListener();
  });
} else {
  initializeThemeMode();
  setupSystemPreferenceListener();
}

// Reinitialize on Turbo navigation
document.addEventListener("turbo:load", initializeThemeMode);

export { setTheme, getTheme, THEME_DARK, THEME_LIGHT };
