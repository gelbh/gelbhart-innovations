/**
 * Manage focus styles for team cards with modal triggers.
 * Ensures pointer interactions don't leave cards in the hovered state when modals close.
 * Preserves keyboard focus indicators for accessibility.
 */

const teamCardFocus = (() => {
  const triggerSelector = '.team-card [data-bs-toggle="modal"]';
  let lastInteraction = 'pointer';
  let globalListenersBound = false;

  const isPointerEvent = (event) => {
    if (!event) return false;
    if (event.pointerType) {
      return ['mouse', 'touch', 'pen'].includes(event.pointerType);
    }
    return true;
  };

  const defocusElement = (element) => {
    if (!element || typeof element.blur !== 'function') return;
    requestAnimationFrame(() => {
      element.blur();
    });
  };

  const handlePointerInteraction = (event) => {
    if (!isPointerEvent(event)) return;
    lastInteraction = 'pointer';
    defocusElement(event.currentTarget);
  };

  const monitorKeyboardInteraction = (event) => {
    const keyboardFocusKeys = ['Tab', 'Enter', 'Escape', ' '];
    if (keyboardFocusKeys.includes(event.key)) {
      lastInteraction = 'keyboard';
    }
  };

  const monitorPointerDown = (event) => {
    if (isPointerEvent(event)) {
      lastInteraction = 'pointer';
    }
  };

  const handleModalHidden = () => {
    if (lastInteraction !== 'pointer') return;

    const activeElement = document.activeElement;
    if (!activeElement) return;
    if (!activeElement.matches(triggerSelector)) return;
    if (!activeElement.closest('.team-card')) return;

    defocusElement(activeElement);
  };

  const initialize = () => {
    const triggers = document.querySelectorAll(triggerSelector);

    triggers.forEach((trigger) => {
      if (trigger.dataset.teamCardFocusAttached === 'true') return;

      trigger.addEventListener('pointerup', handlePointerInteraction);
      trigger.addEventListener('pointercancel', handlePointerInteraction);
      trigger.dataset.teamCardFocusAttached = 'true';
    });

    if (!globalListenersBound) {
      document.addEventListener('keydown', monitorKeyboardInteraction, true);
      document.addEventListener('pointerdown', monitorPointerDown, true);
      document.addEventListener('hidden.bs.modal', handleModalHidden);
      globalListenersBound = true;
    }
  };

  const cleanup = () => {
    const triggers = document.querySelectorAll(triggerSelector);

    triggers.forEach((trigger) => {
      if (trigger.dataset.teamCardFocusAttached === 'true') {
        trigger.removeEventListener('pointerup', handlePointerInteraction);
        trigger.removeEventListener('pointercancel', handlePointerInteraction);
        delete trigger.dataset.teamCardFocusAttached;
      }
    });
  };

  document.addEventListener('DOMContentLoaded', initialize);
  document.addEventListener('turbo:load', initialize);
  document.addEventListener('turbo:before-cache', cleanup);
})();

export default teamCardFocus;

