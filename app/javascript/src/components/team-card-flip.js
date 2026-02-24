/**
 * Team Card Flip Component
 * Clicking a team card front flips it to show the full bio on the back.
 * Tooltip "Click to view full profile" is shown only until the user flips any card once;
 * then it is disabled permanently (localStorage).
 */

const TRIGGER_SELECTOR = ".team-page .team-card-flip-trigger";
const FLIP_CONTAINER_SELECTOR = ".team-card-flip";
const BACK_BTN_SELECTOR = ".team-card-back-btn";
const FLIPPED_CLASS = "flipped";
const STORAGE_KEY = "teamCardFlippedOnce";

const teamCardFlip = (() => {
  const disableFlipTooltips = () => {
    document.querySelectorAll(TRIGGER_SELECTOR).forEach((el) => {
      try {
        if (typeof bootstrap !== "undefined") {
          const tip = bootstrap.Tooltip.getInstance(el);
          if (tip) tip.dispose();
        }
      } catch (_) {
        // dispose can throw if element is detached
      }
      el.removeAttribute("data-bs-toggle");
      el.removeAttribute("data-bs-placement");
      el.removeAttribute("title");
    });
  };

  const handleTriggerClick = (e) => {
    if (e.target.closest("a") || e.target.closest("button")) return;

    const trigger = e.currentTarget;
    const flipContainer = trigger.closest(FLIP_CONTAINER_SELECTOR);
    if (!flipContainer) return;

    const isFlipped = flipContainer.classList.toggle(FLIPPED_CLASS);

    if (isFlipped) {
      try {
        if (!localStorage.getItem(STORAGE_KEY)) {
          localStorage.setItem(STORAGE_KEY, "1");
          disableFlipTooltips();
        }
      } catch (_) {}
      trigger.setAttribute("aria-expanded", "true");
      const backBtn = flipContainer.querySelector(BACK_BTN_SELECTOR);
      if (backBtn) {
        requestAnimationFrame(() => backBtn.focus());
      }
    } else {
      trigger.setAttribute("aria-expanded", "false");
      trigger.focus();
    }
  };

  const handleBackClick = (e) => {
    e.stopPropagation();
    const btn = e.currentTarget;
    const flipContainer = btn.closest(FLIP_CONTAINER_SELECTOR);
    if (!flipContainer) return;

    flipContainer.classList.remove(FLIPPED_CLASS);

    const trigger = flipContainer.querySelector(TRIGGER_SELECTOR);
    if (trigger) {
      trigger.setAttribute("aria-expanded", "false");
      trigger.focus();
    }
  };

  const bindListeners = () => {
    document.querySelectorAll(TRIGGER_SELECTOR).forEach((trigger) => {
      if (trigger.dataset.teamCardFlipAttached === "true") return;
      trigger.addEventListener("click", handleTriggerClick);
      trigger.dataset.teamCardFlipAttached = "true";
    });

    document.querySelectorAll(BACK_BTN_SELECTOR).forEach((btn) => {
      if (btn.dataset.teamCardFlipBackAttached === "true") return;
      btn.addEventListener("click", handleBackClick);
      btn.dataset.teamCardFlipBackAttached = "true";
    });
  };

  const unbindListeners = () => {
    document.querySelectorAll(TRIGGER_SELECTOR).forEach((trigger) => {
      if (trigger.dataset.teamCardFlipAttached !== "true") return;
      trigger.removeEventListener("click", handleTriggerClick);
      delete trigger.dataset.teamCardFlipAttached;
    });

    document.querySelectorAll(BACK_BTN_SELECTOR).forEach((btn) => {
      if (btn.dataset.teamCardFlipBackAttached !== "true") return;
      btn.removeEventListener("click", handleBackClick);
      delete btn.dataset.teamCardFlipBackAttached;
    });
  };

  const initialize = () => {
    if (!document.querySelector(".team-page")) return;
    try {
      if (localStorage.getItem(STORAGE_KEY)) {
        disableFlipTooltips();
      }
    } catch (_) {}
    bindListeners();
  };

  document.addEventListener("DOMContentLoaded", initialize);
  document.addEventListener("turbo:load", initialize);
  document.addEventListener("turbo:before-cache", unbindListeners);
})();

export default teamCardFlip;
