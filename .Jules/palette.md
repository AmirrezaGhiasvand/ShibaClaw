## 2024-07-03 - Missing ARIA labels on Icon-only Modals
**Learning:** Icon-only buttons using `btn-icon` classes for modal close actions and UI toggles (like password visibility) lacked `aria-label` and `title` attributes. This prevented screen readers from explaining the action to users and omitted tooltips for mouse users.
**Action:** Always add `aria-label` and `title` attributes with descriptive text to any button that relies solely on an icon to communicate its function (e.g. `title="Close"` `aria-label="Close"`).
