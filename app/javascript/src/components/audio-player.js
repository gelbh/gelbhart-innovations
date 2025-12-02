/**
 * Audio Player Component
 * Turbo-aware audio player with seek and volume controls
 */

const audioPlayer = (() => {
  const initialize = () => {
    for (const container of document.querySelectorAll(".audio-player")) {
      if (container.dataset.audioPlayerAttached === "true") continue;

      const audio = container.querySelector("audio");
      const playButton = container.querySelector(".ap-play-button");
      const seekSlider = container.querySelector(".ap-seek-slider");
      const volumeSlider = container.querySelector(".ap-volume-slider");
      const durationLabel = container.querySelector(".ap-duration");
      const currentTimeLabel = container.querySelector(".ap-current-time");

      if (!audio || !playButton || !seekSlider || !volumeSlider) continue;

      let playState = "play";
      let raf = null;

      const formatTime = (secs) => {
        const minutes = Math.floor(secs / 60);
        const seconds = Math.floor(secs % 60);
        return `${minutes}:${seconds.toString().padStart(2, "0")}`;
      };

      const updateSliderProgress = (slider) => {
        const property =
          slider === seekSlider
            ? "--seek-before-width"
            : "--volume-before-width";
        container.style.setProperty(
          property,
          `${(slider.value / slider.max) * 100}%`
        );
      };

      const updatePlayback = () => {
        seekSlider.value = Math.floor(audio.currentTime);
        currentTimeLabel &&
          (currentTimeLabel.textContent = formatTime(seekSlider.value));
        container.style.setProperty(
          "--seek-before-width",
          `${(seekSlider.value / seekSlider.max) * 100}%`
        );
        raf = requestAnimationFrame(updatePlayback);
      };

      const displayBuffered = () => {
        if (audio.buffered.length > 0) {
          const buffered = Math.floor(
            audio.buffered.end(audio.buffered.length - 1)
          );
          container.style.setProperty(
            "--buffered-width",
            `${(buffered / seekSlider.max) * 100}%`
          );
        }
      };

      const initializeAudio = () => {
        durationLabel &&
          (durationLabel.textContent = formatTime(audio.duration));
        seekSlider.max = Math.floor(audio.duration);
        displayBuffered();
      };

      // Event listeners
      playButton.addEventListener("click", (e) => {
        if (playState === "play") {
          e.currentTarget.classList.add("ap-pause");
          audio.play();
          requestAnimationFrame(updatePlayback);
          playState = "pause";
        } else {
          e.currentTarget.classList.remove("ap-pause");
          audio.pause();
          cancelAnimationFrame(raf);
          playState = "play";
        }
      });

      seekSlider.addEventListener("input", (e) => {
        updateSliderProgress(e.target);
        currentTimeLabel &&
          (currentTimeLabel.textContent = formatTime(seekSlider.value));
        if (!audio.paused) cancelAnimationFrame(raf);
      });

      seekSlider.addEventListener("change", () => {
        audio.currentTime = seekSlider.value;
        if (!audio.paused) requestAnimationFrame(updatePlayback);
      });

      volumeSlider.addEventListener("input", (e) => {
        updateSliderProgress(e.target);
        audio.volume = e.target.value / 100;
      });

      audio.readyState > 0
        ? initializeAudio()
        : audio.addEventListener("loadedmetadata", initializeAudio);
      audio.addEventListener("progress", displayBuffered);

      container.dataset.audioPlayerAttached = "true";
    }
  };

  document.addEventListener("DOMContentLoaded", initialize);
  document.addEventListener("turbo:load", initialize);
})();

export default audioPlayer;
