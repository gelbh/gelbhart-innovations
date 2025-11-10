// Theme mode initialization
// Turbo-aware: works with both initial page load and Turbo navigation
// Note: Global mode and root variables are set in the layout before theme.min.js loads
// This file handles updates after page load and Turbo navigation

function initializeThemeMode() {
  // Update global variables (set by inline script in layout)
  if (typeof mode !== 'undefined') {
    mode = window.localStorage.getItem('mode');
  }
  if (typeof root !== 'undefined') {
    root = document.getElementsByTagName('html')[0];
  }
  
  const currentMode = window.localStorage.getItem('mode');
  const htmlRoot = document.getElementsByTagName('html')[0];
  
  if (currentMode !== null && currentMode === 'dark') {
    htmlRoot.classList.add('dark-mode');
  } else {
    htmlRoot.classList.remove('dark-mode');
  }
  
  // Update global variables if they exist
  if (typeof mode !== 'undefined') {
    mode = currentMode;
  }
  if (typeof root !== 'undefined') {
    root = htmlRoot;
  }
}

// Initialize on DOMContentLoaded (initial page load)
document.addEventListener('DOMContentLoaded', initializeThemeMode);

// Initialize on Turbo load (Turbo navigation)
document.addEventListener('turbo:load', initializeThemeMode);

