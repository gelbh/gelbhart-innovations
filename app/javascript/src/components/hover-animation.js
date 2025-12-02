/**
 * Play Lottie animations on hover
 * Turbo-aware: works with both initial page load and Turbo navigation
 * @requires https://github.com/LottieFiles/lottie-player
 */

const hoverAnimation = (() => {
  function initialize() {
    const playerContainers = document.querySelectorAll(".animation-on-hover");

    playerContainers.forEach((container) => {
      // Skip if already has listeners attached
      if (container.dataset.hoverAnimationAttached === "true") return;

      container.addEventListener("mouseover", () => {
        const players = container.querySelectorAll("lottie-player");
        players.forEach((player) => {
          player.setDirection(1);
          player.play();
        });
      });

      container.addEventListener("mouseleave", () => {
        const players = container.querySelectorAll("lottie-player");
        players.forEach((player) => {
          player.setDirection(-1);
          player.play();
        });
      });

      container.dataset.hoverAnimationAttached = "true";
    });
  }

  // Initialize on DOMContentLoaded (initial page load)
  document.addEventListener("DOMContentLoaded", initialize);

  // Initialize on Turbo load (Turbo navigation)
  document.addEventListener("turbo:load", initialize);
})();

export default hoverAnimation;
