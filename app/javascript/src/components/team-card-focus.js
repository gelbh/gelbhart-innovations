/**
 * Team Card Focus Component
 * Manages focus styles for team cards with modal triggers
 * Preserves keyboard focus indicators for accessibility
 */

const teamCardFocus = (() => {
  const TRIGGER_SELECTOR = '.team-card [data-bs-toggle="modal"]';
  let lastInteraction = "pointer";
  let globalListenersBound = false;

  const isPointerEvent = (e) => {
    if (!e) return false;
    return e.pointerType
      ? ["mouse", "touch", "pen"].includes(e.pointerType)
      : true;
  };

  const defocus = (el) => {
    if (el?.blur) requestAnimationFrame(() => el.blur());
  };

  const handlePointerInteraction = (e) => {
    if (!isPointerEvent(e)) return;
    lastInteraction = "pointer";
    defocus(e.currentTarget);
  };

  const handleModalHidden = () => {
    if (lastInteraction !== "pointer") return;
    const el = document.activeElement;
    if (el?.matches(TRIGGER_SELECTOR) && el.closest(".team-card")) {
      defocus(el);
    }
  };

  const initialize = () => {
    for (const trigger of document.querySelectorAll(TRIGGER_SELECTOR)) {
      if (trigger.dataset.teamCardFocusAttached === "true") continue;

      trigger.addEventListener("pointerup", handlePointerInteraction);
      trigger.addEventListener("pointercancel", handlePointerInteraction);
      trigger.dataset.teamCardFocusAttached = "true";
    }

    if (!globalListenersBound) {
      document.addEventListener(
        "keydown",
        (e) => {
          if (["Tab", "Enter", "Escape", " "].includes(e.key))
            lastInteraction = "keyboard";
        },
        true
      );
      document.addEventListener(
        "pointerdown",
        (e) => {
          if (isPointerEvent(e)) lastInteraction = "pointer";
        },
        true
      );
      document.addEventListener("hidden.bs.modal", handleModalHidden);
      globalListenersBound = true;
    }
  };

  const cleanup = () => {
    for (const trigger of document.querySelectorAll(TRIGGER_SELECTOR)) {
      if (trigger.dataset.teamCardFocusAttached === "true") {
        trigger.removeEventListener("pointerup", handlePointerInteraction);
        trigger.removeEventListener("pointercancel", handlePointerInteraction);
        delete trigger.dataset.teamCardFocusAttached;
      }
    }
  };

  document.addEventListener("DOMContentLoaded", initialize);
  document.addEventListener("turbo:load", initialize);
  document.addEventListener("turbo:before-cache", cleanup);
})();

export default teamCardFocus;
