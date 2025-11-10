/**
 * Theme Mode Switch
 * Switch betwen light/dark mode. The chosen mode is saved to browser's local storage
*/

const themeModeSwitch = (() => {

  let modeSwitch = document.querySelector('[data-bs-toggle="mode"]');
  
  if(modeSwitch === null) return;

  let checkbox = modeSwitch.querySelector('.form-check-input');

  // Use global mode and root variables (set by inline script in layout)
  // Fallback to window if globals aren't available
  const currentMode = (typeof mode !== 'undefined' ? mode : window.localStorage.getItem('mode'));
  const htmlRoot = (typeof root !== 'undefined' ? root : document.getElementsByTagName('html')[0]);

  if (currentMode === 'dark') {
    htmlRoot.classList.add('dark-mode');
    checkbox.checked = true;
  } else {
    htmlRoot.classList.remove('dark-mode');
    checkbox.checked = false;
  }

  modeSwitch.addEventListener('click', (e) => {
    if (checkbox.checked) {
      htmlRoot.classList.add('dark-mode');
      window.localStorage.setItem('mode', 'dark');
      if (typeof mode !== 'undefined') mode = 'dark';
    } else {
      htmlRoot.classList.remove('dark-mode');
      window.localStorage.setItem('mode', 'light');
      if (typeof mode !== 'undefined') mode = 'light';
    }
  });

})();

export default themeModeSwitch;
