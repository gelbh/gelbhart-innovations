/**
 * Range slider
 * Turbo-aware: works with both initial page load and Turbo navigation
 * @requires https://github.com/leongersen/noUiSlider
 */

const rangeSlider = (() => {
  function initialize() {
    const rangeSliderWidgets = document.querySelectorAll(".range-slider");

    for (let i = 0; i < rangeSliderWidgets.length; i++) {
      const widget = rangeSliderWidgets[i];
      const rangeSliderEl = widget.querySelector(".range-slider-ui");

      // Skip if already initialized (noUiSlider adds noUiSlider property)
      if (rangeSliderEl && rangeSliderEl.noUiSlider) continue;

      const valueMinInput = widget.querySelector(".range-slider-value-min");
      const valueMaxInput = widget.querySelector(".range-slider-value-max");

      const options = {
        dataStartMin: parseInt(widget.dataset.startMin, 10),
        dataStartMax: parseInt(widget.dataset.startMax, 10),
        dataMin: parseInt(widget.dataset.min, 10),
        dataMax: parseInt(widget.dataset.max, 10),
        dataStep: parseInt(widget.dataset.step, 10),
        dataPips: widget.dataset.pips,
        dataTooltips: widget.dataset.tooltips
          ? widget.dataset.tooltips === "true"
          : true,
        dataTooltipPrefix: widget.dataset.tooltipPrefix || "",
        dataTooltipSuffix: widget.dataset.tooltipSuffix || "",
      };

      const start = options.dataStartMax
        ? [options.dataStartMin, options.dataStartMax]
        : [options.dataStartMin];
      const connect = options.dataStartMax ? true : "lower";

      /* eslint-disable no-undef */
      noUiSlider.create(rangeSliderEl, {
        start: start,
        connect: connect,
        step: options.dataStep,
        pips: options.dataPips ? { mode: "count", values: 5 } : false,
        tooltips: options.dataTooltips,
        range: {
          min: options.dataMin,
          max: options.dataMax,
        },
        format: {
          to: function (value) {
            return (
              options.dataTooltipPrefix +
              parseInt(value, 10) +
              options.dataTooltipSuffix
            );
          },
          from: function (value) {
            return Number(value);
          },
        },
      });
      /* eslint-enable no-undef */

      rangeSliderEl.noUiSlider.on("update", (values, handle) => {
        let value = values[handle];
        value = value.replace(/\D/g, "");
        if (handle) {
          if (valueMaxInput) {
            valueMaxInput.value = Math.round(value);
          }
        } else {
          if (valueMinInput) {
            valueMinInput.value = Math.round(value);
          }
        }
      });

      if (valueMinInput) {
        valueMinInput.addEventListener("change", function () {
          rangeSliderEl.noUiSlider.set([this.value, null]);
        });
      }

      if (valueMaxInput) {
        valueMaxInput.addEventListener("change", function () {
          rangeSliderEl.noUiSlider.set([null, this.value]);
        });
      }
    }
  }

  // Initialize on DOMContentLoaded (initial page load)
  document.addEventListener("DOMContentLoaded", initialize);

  // Initialize on Turbo load (Turbo navigation)
  document.addEventListener("turbo:load", initialize);
})();

export default rangeSlider;
