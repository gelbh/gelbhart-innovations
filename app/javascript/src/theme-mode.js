/**
 * Theme Mode Manager
 * Modern dark mode implementation using Bootstrap 5.3 native color modes
 * Features:
 * - Bootstrap 5.3 standard: data-bs-theme attribute
 * - Backward compatibility: .dark-mode class
 * - System preference detection
 * - Turbo-aware initialization
 * - Module-scoped state (no globals)
 */

// Module-scoped constants
const STORAGE_KEY = "theme";
const THEME_DARK = "dark";
const THEME_LIGHT = "light";

/**
 * Get system color scheme preference
 * @returns {string} 'dark' or 'light'
 */
const getSystemPreference = () => {
  if (typeof window === "undefined" || !window.matchMedia) {
    return THEME_LIGHT; // Default to light if not available
  }

  return window.matchMedia("(prefers-color-scheme: dark)").matches
    ? THEME_DARK
    : THEME_LIGHT;
};

/**
 * Get current theme from localStorage or system preference
 * Supports backward compatibility with old 'mode' key
 * @returns {string} 'dark' or 'light'
 */
const getTheme = () => {
  // Check new storage key first
  let saved = localStorage.getItem(STORAGE_KEY);

  // Backward compatibility: check old 'mode' key
  if (!saved) {
    const oldMode = localStorage.getItem("mode");
    if (oldMode) {
      // Migrate old key to new key
      localStorage.setItem(STORAGE_KEY, oldMode);
      localStorage.removeItem("mode");
      saved = oldMode;
    }
  }

  return saved || getSystemPreference();
};

/**
 * Apply theme to document
 * Sets both data-bs-theme attribute (Bootstrap 5.3) and .dark-mode class (backward compatibility)
 * @param {string} theme - 'dark' or 'light'
 */
const applyTheme = (theme) => {
  const html = document.documentElement;

  // Set Bootstrap 5.3 attribute (primary)
  html.setAttribute("data-bs-theme", theme);

  // Set custom class for backward compatibility with custom CSS
  if (theme === THEME_DARK) {
    html.classList.add("dark-mode");
  } else {
    html.classList.remove("dark-mode");
  }
};

/**
 * Initialize theme on page load
 * Turbo-aware: works with both initial page load and Turbo navigation
 */
function initializeThemeMode() {
  const theme = getTheme();
  applyTheme(theme);
}

/**
 * Set theme and save user preference
 * Used when user manually toggles theme
 * @param {string} theme - 'dark' or 'light'
 */
const setTheme = (theme) => {
  applyTheme(theme);
  localStorage.setItem(STORAGE_KEY, theme);
};

/**
 * Listen for system preference changes
 * Only applies if user hasn't set a manual preference
 */
const setupSystemPreferenceListener = () => {
  if (typeof window === "undefined" || !window.matchMedia) {
    return;
  }

  const mediaQuery = window.matchMedia("(prefers-color-scheme: dark)");

  // Modern browsers support addEventListener on MediaQueryList
  if (mediaQuery.addEventListener) {
    mediaQuery.addEventListener("change", (e) => {
      // Only apply system preference if user hasn't manually set a preference
      // Check both new and old storage keys for backward compatibility
      if (!localStorage.getItem(STORAGE_KEY) && !localStorage.getItem("mode")) {
        applyTheme(e.matches ? THEME_DARK : THEME_LIGHT);
      }
    });
  } else {
    // Fallback for older browsers
    mediaQuery.addListener((e) => {
      // Check both new and old storage keys for backward compatibility
      if (!localStorage.getItem(STORAGE_KEY) && !localStorage.getItem("mode")) {
        applyTheme(e.matches ? THEME_DARK : THEME_LIGHT);
      }
    });
  }
};

// Initialize on DOMContentLoaded (initial page load)
if (typeof document !== "undefined") {
  // Apply theme immediately if DOM is already loaded
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", () => {
      initializeThemeMode();
      setupSystemPreferenceListener();
    });
  } else {
    // DOM already loaded
    initializeThemeMode();
    setupSystemPreferenceListener();
  }

  // Initialize on Turbo load (Turbo navigation)
  document.addEventListener("turbo:load", initializeThemeMode);
}

// Export API for theme-mode-switch component
export { setTheme, getTheme, THEME_DARK, THEME_LIGHT };
