// theme.jsx — FlatNest design tokens
// Single source of truth for colors / type / spacing / radius / shadow.

const FN_LIGHT = {
  primary: '#1A6B72',
  primarySoft: '#E6F0F1',
  primaryInk: '#0E484D',
  secondary: '#FF6B6B',
  secondarySoft: '#FFE9E9',
  bg: '#F7F8FA',
  bgAlt: '#EEF0F4',
  surface: '#FFFFFF',
  border: '#E5E7EB',
  borderSoft: '#EFF1F4',
  ink: '#1C1C1E',
  inkMid: '#5B5B62',
  inkSoft: '#8A8A8E',
  inkFaint: '#C7C7CC',
  success: '#34C759',
  warning: '#FF9500',
  error: '#FF3B30',
  successSoft: '#E6F8EC',
  warningSoft: '#FFF1DD',
  errorSoft: '#FFE5E3',
  shadow: '0 4px 16px rgba(15, 20, 30, 0.06)',
  shadowLg: '0 12px 32px rgba(15, 20, 30, 0.10)',
};

const FN_DARK = {
  primary: '#46A7AE',
  primarySoft: '#0F2C2E',
  primaryInk: '#A7DDE1',
  secondary: '#FF8585',
  secondarySoft: '#3A1F1F',
  bg: '#0E1113',
  bgAlt: '#16191C',
  surface: '#1B1F22',
  border: '#2A2F33',
  borderSoft: '#23262A',
  ink: '#F4F5F7',
  inkMid: '#B6BABE',
  inkSoft: '#8A8E92',
  inkFaint: '#4C5054',
  success: '#34C759',
  warning: '#FF9F0F',
  error: '#FF453A',
  successSoft: '#0F2A18',
  warningSoft: '#2D1F08',
  errorSoft: '#2A0F0D',
  shadow: '0 4px 16px rgba(0, 0, 0, 0.4)',
  shadowLg: '0 12px 32px rgba(0, 0, 0, 0.55)',
};

// Accent overrides — primary palette only; secondary/coral stays put.
// Keyed by hex so the value round-trips through Tweaks <TweakColor>.
const FN_ACCENTS = {
  '#1A6B72': { name: 'teal',   primarySoft: '#E6F0F1', primaryInk: '#0E484D' },
  '#4F46E5': { name: 'indigo', primarySoft: '#EAE9FB', primaryInk: '#2D2879' },
  '#1F7A4E': { name: 'forest', primarySoft: '#E4F2EB', primaryInk: '#0F4F2F' },
  '#6A2B7A': { name: 'plum',   primarySoft: '#F0E6F3', primaryInk: '#41174D' },
  '#1C1C1E': { name: 'ink',    primarySoft: '#EEEEF0', primaryInk: '#000000' },
};

function fnTheme({ dark = false, accent = '#1A6B72' } = {}) {
  const base = dark ? FN_DARK : FN_LIGHT;
  const key = (accent || '#1A6B72').toUpperCase();
  const a = FN_ACCENTS[key] || FN_ACCENTS['#1A6B72'];
  const baseHex = key;
  const primary = dark ? lighten(baseHex, 0.18) : baseHex;
  const primarySoft = dark ? darken(baseHex, 0.55) : a.primarySoft;
  const primaryInk = dark ? lighten(baseHex, 0.42) : a.primaryInk;
  return { ...base, primary, primarySoft, primaryInk, dark, accent: key };
}

function hexToRgb(hex) {
  const h = hex.replace('#', '');
  return [parseInt(h.slice(0, 2), 16), parseInt(h.slice(2, 4), 16), parseInt(h.slice(4, 6), 16)];
}
function rgbToHex([r, g, b]) {
  return '#' + [r, g, b].map((v) => Math.round(Math.max(0, Math.min(255, v))).toString(16).padStart(2, '0')).join('');
}
function lighten(hex, amt) {
  const [r, g, b] = hexToRgb(hex);
  return rgbToHex([r + (255 - r) * amt, g + (255 - g) * amt, b + (255 - b) * amt]);
}
function darken(hex, amt) {
  const [r, g, b] = hexToRgb(hex);
  return rgbToHex([r * (1 - amt), g * (1 - amt), b * (1 - amt)]);
}
function withAlpha(hex, a) {
  const [r, g, b] = hexToRgb(hex);
  return `rgba(${r}, ${g}, ${b}, ${a})`;
}

const FN_RADIUS = { card: 16, button: 12, input: 10, chip: 20, pill: 999, sheet: 24 };
const FN_SPACE  = { 1: 4, 2: 8, 3: 12, 4: 16, 5: 20, 6: 24, 7: 32, 8: 40 };

// Font family chain — we load Inter from Google Fonts in index.html; system
// fallback covers offline use and looks fine.
const FN_FONT = "'Inter', 'Poppins', -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif";

Object.assign(window, {
  fnTheme, withAlpha, lighten, darken,
  FN_RADIUS, FN_SPACE, FN_FONT, FN_LIGHT, FN_DARK,
});
