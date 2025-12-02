/**
 * Silicon | Multipurpose Bootstrap Template & UI Kit
 * Copyright 2023 Createx Studio
 * Theme core scripts
 *
 * @author Createx Studio
 * @version 1.6.0
 */

// Note: Bootstrap and smooth-scroll are loaded via vendor assets in the layout,
// not via importmap. This is intentional for Rails compatibility.

// Custom Rails/Turbo-aware theme mode implementation
import themeModeSwitch from "src/components/theme-mode-switch";

// Silicon theme components (all Turbo-aware)
import stickyNavbar from "src/components/sticky-navbar";
import smoothScroll from "src/components/smooth-scroll";
import scrollTopButton from "src/components/scroll-top-button";
import passwordVisibilityToggle from "src/components/password-visibility-toggle";
import elementParallax from "src/components/element-parallax";
import parallax from "src/components/parallax";
import carousel from "src/components/carousel";
import gallery from "src/components/gallery";
import rangeSlider from "src/components/range-slider";
import formValidation from "src/components/form-validation";
import inputFormatter from "src/components/input-formatter";
import tooltip from "src/components/tooltip";
import popover from "src/components/popover";
import toast from "src/components/toast";
import videoButton from "src/components/video-button";
import priceSwitch from "src/components/price-switch";
import masonryGrid from "src/components/masonry-grid";
import subscriptionForm from "src/components/subscription-form";
import hoverAnimation from "src/components/hover-animation";
import audioPlayer from "src/components/audio-player";

// Custom Rails-specific components
import teamCardFocus from "src/components/team-card-focus";
import pageLoader from "src/components/page-loader";
import navigation from "src/navigation";
