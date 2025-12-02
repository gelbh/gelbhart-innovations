/**
 * Range Slider Component
 * @requires noUiSlider
 * Turbo-aware range slider with optional pips
 */

const rangeSlider = (() => {
  const initialize = () => {
    for (const widget of document.querySelectorAll(".range-slider")) {
      const sliderEl = widget.querySelector(".range-slider-ui");
      if (!sliderEl || sliderEl.noUiSlider) continue;

      const minInput = widget.querySelector(".range-slider-value-min");
      const maxInput = widget.querySelector(".range-slider-value-max");

      const options = {
        startMin: parseInt(widget.dataset.startMin, 10),
        startMax: parseInt(widget.dataset.startMax, 10),
        min: parseInt(widget.dataset.min, 10),
        max: parseInt(widget.dataset.max, 10),
        step: parseInt(widget.dataset.step, 10),
        pips: widget.dataset.pips,
        tooltips: widget.dataset.tooltips !== "false",
        prefix: widget.dataset.tooltipPrefix ?? "",
        suffix: widget.dataset.tooltipSuffix ?? "",
      };

      const start = options.startMax
        ? [options.startMin, options.startMax]
        : [options.startMin];
      const connect = options.startMax ? true : "lower";

      noUiSlider.create(sliderEl, {
        start,
        connect,
        step: options.step,
        pips: options.pips ? { mode: "count", values: 5 } : false,
        tooltips: options.tooltips,
        range: { min: options.min, max: options.max },
        format: {
          to: (value) =>
            `${options.prefix}${parseInt(value, 10)}${options.suffix}`,
          from: Number,
        },
      });

      sliderEl.noUiSlider.on("update", (values, handle) => {
        const value = Math.round(values[handle].replace(/\D/g, ""));
        const input = handle ? maxInput : minInput;
        if (input) input.value = value;
      });

      minInput?.addEventListener("change", function () {
        sliderEl.noUiSlider.set([this.value, null]);
      });

      maxInput?.addEventListener("change", function () {
        sliderEl.noUiSlider.set([null, this.value]);
      });
    }
  };

  document.addEventListener("DOMContentLoaded", initialize);
  document.addEventListener("turbo:load", initialize);
})();

export default rangeSlider;
