/**
 * Hover Animation Component
 * @requires LottieFiles lottie-player
 * Turbo-aware Lottie animation on hover
 */

const hoverAnimation = (() => {
  const initialize = () => {
    for (const container of document.querySelectorAll(".animation-on-hover")) {
      if (container.dataset.hoverAnimationAttached === "true") continue;

      const playAll = (direction) => {
        for (const player of container.querySelectorAll("lottie-player")) {
          player.setDirection(direction);
          player.play();
        }
      };

      container.addEventListener("mouseover", () => playAll(1));
      container.addEventListener("mouseleave", () => playAll(-1));
      container.dataset.hoverAnimationAttached = "true";
    }
  };

  document.addEventListener("DOMContentLoaded", initialize);
  document.addEventListener("turbo:load", initialize);
})();

export default hoverAnimation;
