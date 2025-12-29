// Always apply dark mode - no toggle functionality
const DARK_CLASS = 'dark';

function applyDarkMode() {
    var body = document.querySelector("body");
    if (!body.classList.contains(DARK_CLASS)) {
        body.classList.add(DARK_CLASS);
    }
}

// Apply dark mode immediately and on DOM ready
applyDarkMode();
if (window.requestAnimationFrame) {
    window.requestAnimationFrame(applyDarkMode);
}
window.addEventListener('DOMContentLoaded', applyDarkMode);
