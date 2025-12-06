/**
 * Mobile Menu Component
 * Handles mobile menu modal navigation and link clicks
 * Ensures modal closes and navigation proceeds correctly
 */

const mobileMenu = (() => {
  let abortController = new AbortController();
  let pendingNavigation = null;

  const getBootstrap = () => {
    // Bootstrap is loaded globally via script tag
    return window.bootstrap || window.Bootstrap;
  };

  const handleLinkClick = (e) => {
    // Find the closest link element
    const link = e.target.closest("a.mobile-nav-sublink, a.mobile-nav-link");
    if (!link) return;

    // Skip toggle buttons (collapse toggles) - they have data-bs-toggle="collapse"
    if (link.hasAttribute("data-bs-toggle") && link.getAttribute("data-bs-toggle") === "collapse") {
      return;
    }

    const href = link.getAttribute("href");
    // Only handle actual navigation links (not # or empty)
    if (!href || href === "#" || href.startsWith("#")) return;

    // Get the target URL
    const targetUrl = link.href || href;
    const currentUrl = window.location.href;

    // Only proceed if it's a different URL
    if (targetUrl === currentUrl) return;

    // Close modal first
    const modal = document.getElementById("mobileMenu");
    if (modal) {
      const bootstrap = getBootstrap();
      if (bootstrap) {
        const modalInstance = bootstrap.Modal.getInstance(modal);
        if (modalInstance) {
          modalInstance.hide();
        }
      }
    }

    // Store pending navigation to trigger after modal closes
    pendingNavigation = targetUrl;

    // Prevent default to handle navigation ourselves after modal closes
    e.preventDefault();
    e.stopPropagation();
  };

  const handleModalHidden = () => {
    // When modal is fully hidden, trigger navigation if we have a pending one
    if (pendingNavigation) {
      const url = pendingNavigation;
      pendingNavigation = null;

      // Small delay to ensure modal is fully closed
      requestAnimationFrame(() => {
        setTimeout(() => {
          if (window.Turbo?.visit) {
            window.Turbo.visit(url);
          } else {
            window.location.href = url;
          }
        }, 50);
      });
    }
  };

  const initialize = () => {
    const modal = document.getElementById("mobileMenu");
    if (!modal) return;

    // Abort previous listeners
    abortController.abort();
    abortController = new AbortController();
    const signal = abortController.signal;

    // Clear any pending navigation
    pendingNavigation = null;

    // Handle link clicks - store navigation target
    modal.addEventListener("click", handleLinkClick, {
      signal,
      capture: false,
    });

    // Listen for when modal is fully hidden to trigger navigation
    modal.addEventListener("hidden.bs.modal", handleModalHidden, {
      signal,
    });
  };

  const cleanup = () => {
    abortController.abort();
    abortController = new AbortController();
    pendingNavigation = null;
  };

  document.addEventListener("DOMContentLoaded", initialize);
  document.addEventListener("turbo:load", initialize);
  document.addEventListener("turbo:before-cache", cleanup);
})();

export default mobileMenu;
