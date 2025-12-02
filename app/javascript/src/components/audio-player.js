/**
 * Audio player
 * Turbo-aware: works with both initial page load and Turbo navigation
 */

const audioPlayer = (() => {
  function initialize() {
    const players = document.querySelectorAll(".audio-player");

    if (players.length === 0) return;

    for (let i = 0; i < players.length; i++) {
      const playerContainer = players[i];

      // Skip if already initialized
      if (playerContainer.dataset.audioPlayerAttached === "true") continue;

      const audio = playerContainer.querySelector("audio");
      const playButton = playerContainer.querySelector(".ap-play-button");
      const seekSlider = playerContainer.querySelector(".ap-seek-slider");
      const volumeSlider = playerContainer.querySelector(".ap-volume-slider");
      const durationTimeLabel = playerContainer.querySelector(".ap-duration");
      const currentTimeLabel =
        playerContainer.querySelector(".ap-current-time");

      if (!audio || !playButton || !seekSlider || !volumeSlider) continue;

      let playState = "play";
      let raf = null;

      // Start / stop audio
      playButton.addEventListener("click", (e) => {
        if (playState === "play") {
          e.currentTarget.classList.add("ap-pause");
          audio.play();
          requestAnimationFrame(whilePlaying);
          playState = "pause";
        } else {
          e.currentTarget.classList.remove("ap-pause");
          audio.pause();
          cancelAnimationFrame(raf);
          playState = "play";
        }
      });

      // Instantiate sliders: Seek slider + Volume slider
      const showRangeProgress = (rangeInput) => {
        if (rangeInput === seekSlider)
          playerContainer.style.setProperty(
            "--seek-before-width",
            (rangeInput.value / rangeInput.max) * 100 + "%"
          );
        else
          playerContainer.style.setProperty(
            "--volume-before-width",
            (rangeInput.value / rangeInput.max) * 100 + "%"
          );
      };

      seekSlider.addEventListener("input", (e) => {
        showRangeProgress(e.target);
      });
      volumeSlider.addEventListener("input", (e) => {
        showRangeProgress(e.target);
      });

      const calculateTime = (secs) => {
        const minutes = Math.floor(secs / 60);
        const seconds = Math.floor(secs % 60);
        const returnedSeconds = seconds < 10 ? `0${seconds}` : `${seconds}`;
        return `${minutes}:${returnedSeconds}`;
      };

      const displayDuration = () => {
        if (durationTimeLabel) {
          durationTimeLabel.textContent = calculateTime(audio.duration);
        }
      };

      const setSliderMax = () => {
        seekSlider.max = Math.floor(audio.duration);
      };

      const displayBufferedAmount = () => {
        if (audio.buffered.length > 0) {
          const bufferedAmount = Math.floor(
            audio.buffered.end(audio.buffered.length - 1)
          );
          playerContainer.style.setProperty(
            "--buffered-width",
            `${(bufferedAmount / seekSlider.max) * 100}%`
          );
        }
      };

      const whilePlaying = () => {
        seekSlider.value = Math.floor(audio.currentTime);
        if (currentTimeLabel) {
          currentTimeLabel.textContent = calculateTime(seekSlider.value);
        }
        playerContainer.style.setProperty(
          "--seek-before-width",
          `${(seekSlider.value / seekSlider.max) * 100}%`
        );
        raf = requestAnimationFrame(whilePlaying);
      };

      if (audio.readyState > 0) {
        displayDuration();
        setSliderMax();
        displayBufferedAmount();
      } else {
        audio.addEventListener("loadedmetadata", () => {
          displayDuration();
          setSliderMax();
          displayBufferedAmount();
        });
      }

      audio.addEventListener("progress", displayBufferedAmount);

      seekSlider.addEventListener("input", () => {
        if (currentTimeLabel) {
          currentTimeLabel.textContent = calculateTime(seekSlider.value);
        }
        if (!audio.paused) {
          cancelAnimationFrame(raf);
        }
      });

      seekSlider.addEventListener("change", () => {
        audio.currentTime = seekSlider.value;
        if (!audio.paused) {
          requestAnimationFrame(whilePlaying);
        }
      });

      volumeSlider.addEventListener("input", (e) => {
        const value = e.target.value;
        audio.volume = value / 100;
      });

      playerContainer.dataset.audioPlayerAttached = "true";
    }
  }

  // Initialize on DOMContentLoaded (initial page load)
  document.addEventListener("DOMContentLoaded", initialize);

  // Initialize on Turbo load (Turbo navigation)
  document.addEventListener("turbo:load", initialize);
})();

export default audioPlayer;
