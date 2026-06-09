/* @ds-bundle: {"format":3,"namespace":"NestStayFlatNest_6f9d77","components":[],"sourceHashes":{"splash.jsx":"3fbbb8051bbd","splash/ios-frame.jsx":"be3343be4b51","splash/splash.jsx":"d89fdbb9895b","splash/tweaks-panel.jsx":"6591467622ed","src/app.jsx":"7ce455ca3eb7","src/data.jsx":"b5aac8442ce0","src/detail-page.jsx":"8ab19edb942c","src/icons.jsx":"226bad7be8c6","src/navbar.jsx":"95d4f862881e","src/post-page.jsx":"8d535407649e","src/search-page.jsx":"fab7387710af","src/ui.jsx":"cc89b7fb01dd"},"inlinedExternals":[],"unexposedExports":[]} */

(() => {

const __ds_ns = (window.NestStayFlatNest_6f9d77 = window.NestStayFlatNest_6f9d77 || {});

const __ds_scope = {};

(__ds_ns.__errors = __ds_ns.__errors || []);

// splash.jsx
try { (() => {
// FlatNest animated splash — "drop a pin" concept.
// Globals: React, IOSDevice, useTweaks, TweaksPanel, Tweak* controls.
const {
  useState
} = React;
const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "pin": "#EE6A63",
  "bg": ["#DEEAE7", "#CEDFE1"],
  "tagline": "Your spot, marked",
  "speed": "normal",
  "clouds": true,
  "loader": false
} /*EDITMODE-END*/;
const SPEED_MAP = {
  relaxed: 1.35,
  normal: 1,
  snappy: 0.7
};

// ── A soft two-puff cloud ──────────────────────────────────
function Cloud({
  w = 150
}) {
  const h = w * 0.46;
  return /*#__PURE__*/React.createElement("svg", {
    width: w,
    height: h,
    viewBox: "0 0 150 70",
    fill: "none"
  }, /*#__PURE__*/React.createElement("ellipse", {
    cx: "58",
    cy: "42",
    rx: "56",
    ry: "26",
    fill: "#E7EFEE",
    stroke: "rgba(150,172,172,0.32)",
    strokeWidth: "1.3"
  }), /*#__PURE__*/React.createElement("ellipse", {
    cx: "104",
    cy: "40",
    rx: "40",
    ry: "22",
    fill: "#E7EFEE",
    stroke: "rgba(150,172,172,0.32)",
    strokeWidth: "1.3"
  }), /*#__PURE__*/React.createElement("ellipse", {
    cx: "58",
    cy: "40",
    rx: "53",
    ry: "23",
    fill: "#EEF4F3"
  }), /*#__PURE__*/React.createElement("ellipse", {
    cx: "104",
    cy: "38",
    rx: "37",
    ry: "19",
    fill: "#EEF4F3"
  }));
}

// ── The keyhole / drop-pin mark ────────────────────────────
function PinMark() {
  return /*#__PURE__*/React.createElement("div", {
    className: "fn-pin"
  }, /*#__PURE__*/React.createElement("svg", {
    width: "106",
    height: "132",
    viewBox: "0 0 120 150",
    fill: "var(--fn-pin)"
  }, /*#__PURE__*/React.createElement("circle", {
    cx: "60",
    cy: "50",
    r: "46"
  }), /*#__PURE__*/React.createElement("rect", {
    x: "30",
    y: "48",
    width: "60",
    height: "86",
    rx: "28"
  })));
}
function Stage({
  runId,
  t
}) {
  const spd = SPEED_MAP[t.speed] || 1;
  const dots = Array.from({
    length: 13
  });
  return /*#__PURE__*/React.createElement("div", {
    className: "fn-screen",
    key: runId,
    style: {
      "--fn-pin": t.pin,
      "--fn-bg-top": t.bg[0],
      "--fn-bg-bot": t.bg[1],
      "--spd": spd
    }
  }, t.clouds && /*#__PURE__*/React.createElement("div", {
    className: "fn-sky"
  }, /*#__PURE__*/React.createElement("div", {
    className: "fn-cloud fn-cloud-1"
  }, /*#__PURE__*/React.createElement(Cloud, {
    w: 150
  })), /*#__PURE__*/React.createElement("div", {
    className: "fn-cloud fn-cloud-2"
  }, /*#__PURE__*/React.createElement(Cloud, {
    w: 168
  })), /*#__PURE__*/React.createElement("div", {
    className: "fn-cloud fn-cloud-3"
  }, /*#__PURE__*/React.createElement(Cloud, {
    w: 120
  }))), /*#__PURE__*/React.createElement("div", {
    className: "fn-trail"
  }, dots.map((_, i) => /*#__PURE__*/React.createElement("span", {
    key: i,
    className: "fn-dot-trail",
    style: {
      animationDelay: `calc(${150 + i * 55}ms * var(--spd))`
    }
  }))), /*#__PURE__*/React.createElement("div", {
    className: "fn-pinstage"
  }, /*#__PURE__*/React.createElement("div", {
    className: "fn-ripple",
    "data-comment-anchor": "9064ab52ca-div-74-9"
  }), /*#__PURE__*/React.createElement(PinMark, null)), /*#__PURE__*/React.createElement("div", {
    className: "fn-shadow"
  }), /*#__PURE__*/React.createElement("div", {
    className: "fn-text"
  }, /*#__PURE__*/React.createElement("h1", {
    className: "fn-word"
  }, /*#__PURE__*/React.createElement("span", {
    className: "b"
  }, "flat"), /*#__PURE__*/React.createElement("span", {
    className: "r"
  }, "nest")), /*#__PURE__*/React.createElement("p", {
    className: "fn-tag"
  }, t.tagline)), t.loader && /*#__PURE__*/React.createElement("div", {
    className: "fn-loader"
  }, /*#__PURE__*/React.createElement("span", null), /*#__PURE__*/React.createElement("span", null), /*#__PURE__*/React.createElement("span", null)));
}
function Splash() {
  const [t, setTweak] = useTweaks(TWEAK_DEFAULTS);
  // Bumping the key remounts the animated stack so it replays from frame 0.
  const [runId, setRunId] = useState(0);
  return /*#__PURE__*/React.createElement("div", {
    className: "fn-stage"
  }, /*#__PURE__*/React.createElement(IOSDevice, null, /*#__PURE__*/React.createElement(Stage, {
    runId: runId,
    t: t
  })), /*#__PURE__*/React.createElement("button", {
    className: "fn-replay",
    onClick: () => setRunId(n => n + 1)
  }, "\u21BB Replay animation"), /*#__PURE__*/React.createElement(TweaksPanel, null, /*#__PURE__*/React.createElement(TweakSection, {
    label: "Brand"
  }), /*#__PURE__*/React.createElement(TweakColor, {
    label: "Pin color",
    value: t.pin,
    options: ["#EE6A63", "#1A6B72", "#5B8DEF", "#E8A33D", "#7A5AE0"],
    onChange: v => setTweak("pin", v)
  }), /*#__PURE__*/React.createElement(TweakColor, {
    label: "Background",
    value: t.bg,
    options: [["#DEEAE7", "#CEDFE1"], ["#EDE6E1", "#E2D6CE"], ["#E7E9F0", "#D6DAE6"], ["#1A2A2E", "#0E1B1E"]],
    onChange: v => setTweak("bg", v)
  }), /*#__PURE__*/React.createElement(TweakText, {
    label: "Tagline",
    value: t.tagline,
    onChange: v => setTweak("tagline", v)
  }), /*#__PURE__*/React.createElement(TweakSection, {
    label: "Motion"
  }), /*#__PURE__*/React.createElement(TweakRadio, {
    label: "Pace",
    value: t.speed,
    options: ["relaxed", "normal", "snappy"],
    onChange: v => {
      setTweak("speed", v);
      setRunId(n => n + 1);
    }
  }), /*#__PURE__*/React.createElement(TweakToggle, {
    label: "Clouds",
    value: t.clouds,
    onChange: v => setTweak("clouds", v)
  }), /*#__PURE__*/React.createElement(TweakToggle, {
    label: "Loading dots",
    value: t.loader,
    onChange: v => setTweak("loader", v)
  })));
}
ReactDOM.createRoot(document.getElementById('root')).render(/*#__PURE__*/React.createElement(Splash, null));
})(); } catch (e) { __ds_ns.__errors.push({ path: "splash.jsx", error: String((e && e.message) || e) }); }

// splash/ios-frame.jsx
try { (() => {
// @ds-adherence-ignore -- omelette starter scaffold (raw elements/hex/px by design)

/* BEGIN USAGE */
// iOS.jsx — Simplified iOS 26 (Liquid Glass) device frame
// Based on the iOS 26 UI Kit + Figma status bar spec. No assets, no deps.
// Exports (to window): IOSDevice, IOSStatusBar, IOSNavBar, IOSGlassPill, IOSList, IOSListRow, IOSKeyboard
//
// Usage — wrap your screen content in <IOSDevice> to get the bezel, status bar
// and home indicator (props: title, dark, keyboard):
//
//   <IOSDevice title="Settings">
//     ...your screen content...
//   </IOSDevice>
//   <IOSDevice dark title="Search" keyboard>…</IOSDevice>
/* END USAGE */

// ─────────────────────────────────────────────────────────────
// Status bar
// ─────────────────────────────────────────────────────────────
function IOSStatusBar({
  dark = false,
  time = '9:41'
}) {
  const c = dark ? '#fff' : '#000';
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 154,
      alignItems: 'center',
      justifyContent: 'center',
      padding: '21px 24px 19px',
      boxSizing: 'border-box',
      position: 'relative',
      zIndex: 20,
      width: '100%'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      height: 22,
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      paddingTop: 1.5
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontFamily: '-apple-system, "SF Pro", system-ui',
      fontWeight: 590,
      fontSize: 17,
      lineHeight: '22px',
      color: c
    }
  }, time)), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      height: 22,
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      gap: 7,
      paddingTop: 1,
      paddingRight: 1
    }
  }, /*#__PURE__*/React.createElement("svg", {
    width: "19",
    height: "12",
    viewBox: "0 0 19 12"
  }, /*#__PURE__*/React.createElement("rect", {
    x: "0",
    y: "7.5",
    width: "3.2",
    height: "4.5",
    rx: "0.7",
    fill: c
  }), /*#__PURE__*/React.createElement("rect", {
    x: "4.8",
    y: "5",
    width: "3.2",
    height: "7",
    rx: "0.7",
    fill: c
  }), /*#__PURE__*/React.createElement("rect", {
    x: "9.6",
    y: "2.5",
    width: "3.2",
    height: "9.5",
    rx: "0.7",
    fill: c
  }), /*#__PURE__*/React.createElement("rect", {
    x: "14.4",
    y: "0",
    width: "3.2",
    height: "12",
    rx: "0.7",
    fill: c
  })), /*#__PURE__*/React.createElement("svg", {
    width: "17",
    height: "12",
    viewBox: "0 0 17 12"
  }, /*#__PURE__*/React.createElement("path", {
    d: "M8.5 3.2C10.8 3.2 12.9 4.1 14.4 5.6L15.5 4.5C13.7 2.7 11.2 1.5 8.5 1.5C5.8 1.5 3.3 2.7 1.5 4.5L2.6 5.6C4.1 4.1 6.2 3.2 8.5 3.2Z",
    fill: c
  }), /*#__PURE__*/React.createElement("path", {
    d: "M8.5 6.8C9.9 6.8 11.1 7.3 12 8.2L13.1 7.1C11.8 5.9 10.2 5.1 8.5 5.1C6.8 5.1 5.2 5.9 3.9 7.1L5 8.2C5.9 7.3 7.1 6.8 8.5 6.8Z",
    fill: c
  }), /*#__PURE__*/React.createElement("circle", {
    cx: "8.5",
    cy: "10.5",
    r: "1.5",
    fill: c
  })), /*#__PURE__*/React.createElement("svg", {
    width: "27",
    height: "13",
    viewBox: "0 0 27 13"
  }, /*#__PURE__*/React.createElement("rect", {
    x: "0.5",
    y: "0.5",
    width: "23",
    height: "12",
    rx: "3.5",
    stroke: c,
    strokeOpacity: "0.35",
    fill: "none"
  }), /*#__PURE__*/React.createElement("rect", {
    x: "2",
    y: "2",
    width: "20",
    height: "9",
    rx: "2",
    fill: c
  }), /*#__PURE__*/React.createElement("path", {
    d: "M25 4.5V8.5C25.8 8.2 26.5 7.2 26.5 6.5C26.5 5.8 25.8 4.8 25 4.5Z",
    fill: c,
    fillOpacity: "0.4"
  }))));
}

// ─────────────────────────────────────────────────────────────
// Liquid glass pill — blur + tint + shine
// ─────────────────────────────────────────────────────────────
function IOSGlassPill({
  children,
  dark = false,
  style = {}
}) {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      height: 44,
      minWidth: 44,
      borderRadius: 9999,
      position: 'relative',
      overflow: 'hidden',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      boxShadow: dark ? '0 2px 6px rgba(0,0,0,0.35), 0 6px 16px rgba(0,0,0,0.2)' : '0 1px 3px rgba(0,0,0,0.07), 0 3px 10px rgba(0,0,0,0.06)',
      ...style
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      borderRadius: 9999,
      backdropFilter: 'blur(12px) saturate(180%)',
      WebkitBackdropFilter: 'blur(12px) saturate(180%)',
      background: dark ? 'rgba(120,120,128,0.28)' : 'rgba(255,255,255,0.5)'
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      borderRadius: 9999,
      boxShadow: dark ? 'inset 1.5px 1.5px 1px rgba(255,255,255,0.15), inset -1px -1px 1px rgba(255,255,255,0.08)' : 'inset 1.5px 1.5px 1px rgba(255,255,255,0.7), inset -1px -1px 1px rgba(255,255,255,0.4)',
      border: dark ? '0.5px solid rgba(255,255,255,0.15)' : '0.5px solid rgba(0,0,0,0.06)'
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'relative',
      zIndex: 1,
      display: 'flex',
      alignItems: 'center',
      padding: '0 4px'
    }
  }, children));
}

// ─────────────────────────────────────────────────────────────
// Navigation bar — glass pills + large title
// ─────────────────────────────────────────────────────────────
function IOSNavBar({
  title = 'Title',
  dark = false,
  trailingIcon = true
}) {
  const muted = dark ? 'rgba(255,255,255,0.6)' : '#404040';
  const text = dark ? '#fff' : '#000';
  const pillIcon = content => /*#__PURE__*/React.createElement(IOSGlassPill, {
    dark: dark
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width: 36,
      height: 36,
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center'
    }
  }, content));
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      flexDirection: 'column',
      gap: 10,
      paddingTop: 62,
      paddingBottom: 10,
      position: 'relative',
      zIndex: 5
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      padding: '0 16px'
    }
  }, pillIcon(/*#__PURE__*/React.createElement("svg", {
    width: "12",
    height: "20",
    viewBox: "0 0 12 20",
    fill: "none",
    style: {
      marginLeft: -1
    }
  }, /*#__PURE__*/React.createElement("path", {
    d: "M10 2L2 10l8 8",
    stroke: muted,
    strokeWidth: "2.5",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  }))), trailingIcon && pillIcon(/*#__PURE__*/React.createElement("svg", {
    width: "22",
    height: "6",
    viewBox: "0 0 22 6"
  }, /*#__PURE__*/React.createElement("circle", {
    cx: "3",
    cy: "3",
    r: "2.5",
    fill: muted
  }), /*#__PURE__*/React.createElement("circle", {
    cx: "11",
    cy: "3",
    r: "2.5",
    fill: muted
  }), /*#__PURE__*/React.createElement("circle", {
    cx: "19",
    cy: "3",
    r: "2.5",
    fill: muted
  })))), /*#__PURE__*/React.createElement("div", {
    style: {
      padding: '0 16px',
      fontFamily: '-apple-system, system-ui',
      fontSize: 34,
      fontWeight: 700,
      lineHeight: '41px',
      color: text,
      letterSpacing: 0.4
    }
  }, title));
}

// ─────────────────────────────────────────────────────────────
// Grouped list (inset card, r:26) + row (52px)
// ─────────────────────────────────────────────────────────────
function IOSListRow({
  title,
  detail,
  icon,
  chevron = true,
  isLast = false,
  dark = false
}) {
  const text = dark ? '#fff' : '#000';
  const sec = dark ? 'rgba(235,235,245,0.6)' : 'rgba(60,60,67,0.6)';
  const ter = dark ? 'rgba(235,235,245,0.3)' : 'rgba(60,60,67,0.3)';
  const sep = dark ? 'rgba(84,84,88,0.65)' : 'rgba(60,60,67,0.12)';
  return /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      alignItems: 'center',
      minHeight: 52,
      padding: '0 16px',
      position: 'relative',
      fontFamily: '-apple-system, system-ui',
      fontSize: 17,
      letterSpacing: -0.43
    }
  }, icon && /*#__PURE__*/React.createElement("div", {
    style: {
      width: 30,
      height: 30,
      borderRadius: 7,
      background: icon,
      marginRight: 12,
      flexShrink: 0
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      color: text
    }
  }, title), detail && /*#__PURE__*/React.createElement("span", {
    style: {
      color: sec,
      marginRight: 6
    }
  }, detail), chevron && /*#__PURE__*/React.createElement("svg", {
    width: "8",
    height: "14",
    viewBox: "0 0 8 14",
    style: {
      flexShrink: 0
    }
  }, /*#__PURE__*/React.createElement("path", {
    d: "M1 1l6 6-6 6",
    stroke: ter,
    strokeWidth: "2",
    fill: "none",
    strokeLinecap: "round",
    strokeLinejoin: "round"
  })), !isLast && /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      bottom: 0,
      right: 0,
      left: icon ? 58 : 16,
      height: 0.5,
      background: sep
    }
  }));
}
function IOSList({
  header,
  children,
  dark = false
}) {
  const hc = dark ? 'rgba(235,235,245,0.6)' : 'rgba(60,60,67,0.6)';
  const bg = dark ? '#1C1C1E' : '#fff';
  return /*#__PURE__*/React.createElement("div", null, header && /*#__PURE__*/React.createElement("div", {
    style: {
      fontFamily: '-apple-system, system-ui',
      fontSize: 13,
      color: hc,
      textTransform: 'uppercase',
      padding: '8px 36px 6px',
      letterSpacing: -0.08
    }
  }, header), /*#__PURE__*/React.createElement("div", {
    style: {
      background: bg,
      borderRadius: 26,
      margin: '0 16px',
      overflow: 'hidden'
    }
  }, children));
}

// ─────────────────────────────────────────────────────────────
// Device frame
// ─────────────────────────────────────────────────────────────
function IOSDevice({
  children,
  width = 402,
  height = 874,
  dark = false,
  title,
  keyboard = false
}) {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      width,
      height,
      borderRadius: 48,
      overflow: 'hidden',
      position: 'relative',
      background: dark ? '#000' : '#F2F2F7',
      boxShadow: '0 40px 80px rgba(0,0,0,0.18), 0 0 0 1px rgba(0,0,0,0.12)',
      fontFamily: '-apple-system, system-ui, sans-serif',
      WebkitFontSmoothing: 'antialiased'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      top: 11,
      left: '50%',
      transform: 'translateX(-50%)',
      width: 126,
      height: 37,
      borderRadius: 24,
      background: '#000',
      zIndex: 50
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      top: 0,
      left: 0,
      right: 0,
      zIndex: 10
    }
  }, /*#__PURE__*/React.createElement(IOSStatusBar, {
    dark: dark
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      height: '100%',
      display: 'flex',
      flexDirection: 'column'
    }
  }, title !== undefined && /*#__PURE__*/React.createElement(IOSNavBar, {
    title: title,
    dark: dark
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      overflow: 'auto'
    }
  }, children), keyboard && /*#__PURE__*/React.createElement(IOSKeyboard, {
    dark: dark
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      bottom: 0,
      left: 0,
      right: 0,
      zIndex: 60,
      height: 34,
      display: 'flex',
      justifyContent: 'center',
      alignItems: 'flex-end',
      paddingBottom: 8,
      pointerEvents: 'none'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width: 139,
      height: 5,
      borderRadius: 100,
      background: dark ? 'rgba(255,255,255,0.7)' : 'rgba(0,0,0,0.25)'
    }
  })));
}

// ─────────────────────────────────────────────────────────────
// Keyboard — iOS 26 liquid glass
// ─────────────────────────────────────────────────────────────
function IOSKeyboard({
  dark = false
}) {
  const glyph = dark ? 'rgba(255,255,255,0.7)' : '#595959';
  const sugg = dark ? 'rgba(255,255,255,0.6)' : '#333';
  const keyBg = dark ? 'rgba(255,255,255,0.22)' : 'rgba(255,255,255,0.85)';

  // special-key icons
  const icons = {
    shift: /*#__PURE__*/React.createElement("svg", {
      width: "19",
      height: "17",
      viewBox: "0 0 19 17"
    }, /*#__PURE__*/React.createElement("path", {
      d: "M9.5 1L1 9.5h4.5V16h8V9.5H18L9.5 1z",
      fill: glyph
    })),
    del: /*#__PURE__*/React.createElement("svg", {
      width: "23",
      height: "17",
      viewBox: "0 0 23 17"
    }, /*#__PURE__*/React.createElement("path", {
      d: "M7 1h13a2 2 0 012 2v11a2 2 0 01-2 2H7l-6-7.5L7 1z",
      fill: "none",
      stroke: glyph,
      strokeWidth: "1.6",
      strokeLinejoin: "round"
    }), /*#__PURE__*/React.createElement("path", {
      d: "M10 5l7 7M17 5l-7 7",
      stroke: glyph,
      strokeWidth: "1.6",
      strokeLinecap: "round"
    })),
    ret: /*#__PURE__*/React.createElement("svg", {
      width: "20",
      height: "14",
      viewBox: "0 0 20 14"
    }, /*#__PURE__*/React.createElement("path", {
      d: "M18 1v6H4m0 0l4-4M4 7l4 4",
      fill: "none",
      stroke: "#fff",
      strokeWidth: "1.8",
      strokeLinecap: "round",
      strokeLinejoin: "round"
    }))
  };
  const key = (content, {
    w,
    flex,
    ret,
    fs = 25,
    k
  } = {}) => /*#__PURE__*/React.createElement("div", {
    key: k,
    style: {
      height: 42,
      borderRadius: 8.5,
      flex: flex ? 1 : undefined,
      width: w,
      minWidth: 0,
      background: ret ? '#08f' : keyBg,
      boxShadow: '0 1px 0 rgba(0,0,0,0.075)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      fontFamily: '-apple-system, "SF Compact", system-ui',
      fontSize: fs,
      fontWeight: 458,
      color: ret ? '#fff' : glyph
    }
  }, content);
  const row = (keys, pad = 0) => /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 6.5,
      justifyContent: 'center',
      padding: `0 ${pad}px`
    }
  }, keys.map(l => key(l, {
    flex: true,
    k: l
  })));
  return /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'relative',
      zIndex: 15,
      borderRadius: 27,
      overflow: 'hidden',
      padding: '11px 0 2px',
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      boxShadow: dark ? '0 -2px 20px rgba(0,0,0,0.09)' : '0 -1px 6px rgba(0,0,0,0.018), 0 -3px 20px rgba(0,0,0,0.012)'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      borderRadius: 27,
      backdropFilter: 'blur(12px) saturate(180%)',
      WebkitBackdropFilter: 'blur(12px) saturate(180%)',
      background: dark ? 'rgba(120,120,128,0.14)' : 'rgba(255,255,255,0.25)'
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      borderRadius: 27,
      boxShadow: dark ? 'inset 1.5px 1.5px 1px rgba(255,255,255,0.15)' : 'inset 1.5px 1.5px 1px rgba(255,255,255,0.7), inset -1px -1px 1px rgba(255,255,255,0.4)',
      border: dark ? '0.5px solid rgba(255,255,255,0.15)' : '0.5px solid rgba(0,0,0,0.06)',
      pointerEvents: 'none'
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 20,
      alignItems: 'center',
      padding: '8px 22px 13px',
      width: '100%',
      boxSizing: 'border-box',
      position: 'relative'
    }
  }, ['"The"', 'the', 'to'].map((w, i) => /*#__PURE__*/React.createElement(React.Fragment, {
    key: i
  }, i > 0 && /*#__PURE__*/React.createElement("div", {
    style: {
      width: 1,
      height: 25,
      background: '#ccc',
      opacity: 0.3
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      flex: 1,
      textAlign: 'center',
      fontFamily: '-apple-system, system-ui',
      fontSize: 17,
      color: sugg,
      letterSpacing: -0.43,
      lineHeight: '22px'
    }
  }, w)))), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      flexDirection: 'column',
      gap: 13,
      padding: '0 6.5px',
      width: '100%',
      boxSizing: 'border-box',
      position: 'relative'
    }
  }, row(['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p']), row(['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'], 20), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 14.25,
      alignItems: 'center'
    }
  }, key(icons.shift, {
    w: 45,
    k: 'shift'
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 6.5,
      flex: 1
    }
  }, ['z', 'x', 'c', 'v', 'b', 'n', 'm'].map(l => key(l, {
    flex: true,
    k: l
  }))), key(icons.del, {
    w: 45,
    k: 'del'
  })), /*#__PURE__*/React.createElement("div", {
    style: {
      display: 'flex',
      gap: 6,
      alignItems: 'center'
    }
  }, key('ABC', {
    w: 92.25,
    fs: 18,
    k: 'abc'
  }), key('', {
    flex: true,
    k: 'space'
  }), key(icons.ret, {
    w: 92.25,
    ret: true,
    k: 'ret'
  }))), /*#__PURE__*/React.createElement("div", {
    style: {
      height: 56,
      width: '100%',
      position: 'relative'
    }
  }));
}
Object.assign(window, {
  IOSDevice,
  IOSStatusBar,
  IOSNavBar,
  IOSGlassPill,
  IOSList,
  IOSListRow,
  IOSKeyboard
});
})(); } catch (e) { __ds_ns.__errors.push({ path: "splash/ios-frame.jsx", error: String((e && e.message) || e) }); }

// splash/splash.jsx
try { (() => {
// FlatNest animated splash — "drop a pin" concept.
// Globals: React, IOSDevice, useTweaks, TweaksPanel, Tweak* controls.
const {
  useState,
  useEffect,
  useRef
} = React;
const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "pin": "#EE6A63",
  "bg": ["#DEEAE7", "#CEDFE1"],
  "tagline": "Your spot, marked",
  "speed": "normal",
  "clouds": true,
  "loader": false
} /*EDITMODE-END*/;
const SPEED_MAP = {
  relaxed: 1.35,
  normal: 1,
  snappy: 0.7
};

// ── A soft two-puff cloud ──────────────────────────────────
function Cloud({
  w = 150
}) {
  const h = w * 0.46;
  return /*#__PURE__*/React.createElement("svg", {
    width: w,
    height: h,
    viewBox: "0 0 150 70",
    fill: "none"
  }, /*#__PURE__*/React.createElement("ellipse", {
    cx: "58",
    cy: "42",
    rx: "56",
    ry: "26",
    fill: "#E7EFEE",
    stroke: "rgba(150,172,172,0.32)",
    strokeWidth: "1.3"
  }), /*#__PURE__*/React.createElement("ellipse", {
    cx: "104",
    cy: "40",
    rx: "40",
    ry: "22",
    fill: "#E7EFEE",
    stroke: "rgba(150,172,172,0.32)",
    strokeWidth: "1.3"
  }), /*#__PURE__*/React.createElement("ellipse", {
    cx: "58",
    cy: "40",
    rx: "53",
    ry: "23",
    fill: "#EEF4F3"
  }), /*#__PURE__*/React.createElement("ellipse", {
    cx: "104",
    cy: "38",
    rx: "37",
    ry: "19",
    fill: "#EEF4F3"
  }));
}

// ── The keyhole / drop-pin mark ────────────────────────────
function PinMark() {
  return /*#__PURE__*/React.createElement("div", {
    className: "fn-pin"
  }, /*#__PURE__*/React.createElement("svg", {
    width: "106",
    height: "132",
    viewBox: "0 0 120 150",
    fill: "none"
  }, /*#__PURE__*/React.createElement("path", {
    d: "M60 4 C34 4 14 24 14 50 C14 80 44 112 56 140 C58 144 62 144 64 140 C76 112 106 80 106 50 C106 24 86 4 60 4 Z",
    fill: "var(--fn-pin)"
  }), /*#__PURE__*/React.createElement("circle", {
    cx: "60",
    cy: "50",
    r: "17",
    fill: "#fff"
  })));
}
function Stage({
  runId,
  t
}) {
  const spd = SPEED_MAP[t.speed] || 1;
  const dots = Array.from({
    length: 13
  });
  const screenRef = useRef(null);

  // Engage the entrance animations only on a live, visible tab. The base
  // styles are already the fully-visible end-state, so if this never fires
  // (reduced-motion, backgrounded/throttled tab, no JS) the pin and wordmark
  // simply stay on screen instead of vanishing.
  useEffect(() => {
    const el = screenRef.current;
    if (!el) return;
    el.classList.remove("fn-play");
    const reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    if (reduce) return;
    // rAF is paused in hidden tabs, so the visible base shows there instead.
    const id = requestAnimationFrame(() => requestAnimationFrame(() => el.classList.add("fn-play")));
    return () => cancelAnimationFrame(id);
  }, [runId, t.speed, t.clouds, t.loader]);
  return /*#__PURE__*/React.createElement("div", {
    ref: screenRef,
    className: "fn-screen",
    key: runId,
    style: {
      "--fn-pin": t.pin,
      "--fn-bg-top": t.bg[0],
      "--fn-bg-bot": t.bg[1],
      "--spd": spd
    }
  }, t.clouds && /*#__PURE__*/React.createElement("div", {
    className: "fn-sky"
  }, /*#__PURE__*/React.createElement("div", {
    className: "fn-cloud fn-cloud-1"
  }, /*#__PURE__*/React.createElement(Cloud, {
    w: 150
  })), /*#__PURE__*/React.createElement("div", {
    className: "fn-cloud fn-cloud-2"
  }, /*#__PURE__*/React.createElement(Cloud, {
    w: 168
  })), /*#__PURE__*/React.createElement("div", {
    className: "fn-cloud fn-cloud-3"
  }, /*#__PURE__*/React.createElement(Cloud, {
    w: 120
  }))), /*#__PURE__*/React.createElement("div", {
    className: "fn-trail"
  }, dots.map((_, i) => /*#__PURE__*/React.createElement("span", {
    key: i,
    className: "fn-dot-trail",
    style: {
      animationDelay: `calc(${150 + i * 55}ms * var(--spd))`
    }
  }))), /*#__PURE__*/React.createElement("div", {
    className: "fn-pinstage"
  }, /*#__PURE__*/React.createElement("div", {
    className: "fn-ripple"
  }), /*#__PURE__*/React.createElement(PinMark, null)), /*#__PURE__*/React.createElement("div", {
    className: "fn-shadow"
  }), /*#__PURE__*/React.createElement("div", {
    className: "fn-text"
  }, /*#__PURE__*/React.createElement("h1", {
    className: "fn-word"
  }, /*#__PURE__*/React.createElement("span", {
    className: "b"
  }, "flat"), /*#__PURE__*/React.createElement("span", {
    className: "r"
  }, "nest")), /*#__PURE__*/React.createElement("p", {
    className: "fn-tag"
  }, t.tagline)), t.loader && /*#__PURE__*/React.createElement("div", {
    className: "fn-loader"
  }, /*#__PURE__*/React.createElement("span", null), /*#__PURE__*/React.createElement("span", null), /*#__PURE__*/React.createElement("span", null)));
}
function Splash() {
  const [t, setTweak] = useTweaks(TWEAK_DEFAULTS);
  // Bumping the key remounts the animated stack so it replays from frame 0.
  const [runId, setRunId] = useState(0);
  return /*#__PURE__*/React.createElement("div", {
    className: "fn-stage"
  }, /*#__PURE__*/React.createElement(IOSDevice, null, /*#__PURE__*/React.createElement(Stage, {
    runId: runId,
    t: t
  })), /*#__PURE__*/React.createElement("button", {
    className: "fn-replay",
    onClick: () => setRunId(n => n + 1)
  }, "\u21BB Replay animation"), /*#__PURE__*/React.createElement(TweaksPanel, null, /*#__PURE__*/React.createElement(TweakSection, {
    label: "Brand"
  }), /*#__PURE__*/React.createElement(TweakColor, {
    label: "Pin color",
    value: t.pin,
    options: ["#EE6A63", "#1A6B72", "#5B8DEF", "#E8A33D", "#7A5AE0"],
    onChange: v => setTweak("pin", v)
  }), /*#__PURE__*/React.createElement(TweakColor, {
    label: "Background",
    value: t.bg,
    options: [["#DEEAE7", "#CEDFE1"], ["#EDE6E1", "#E2D6CE"], ["#E7E9F0", "#D6DAE6"], ["#1A2A2E", "#0E1B1E"]],
    onChange: v => setTweak("bg", v)
  }), /*#__PURE__*/React.createElement(TweakText, {
    label: "Tagline",
    value: t.tagline,
    onChange: v => setTweak("tagline", v)
  }), /*#__PURE__*/React.createElement(TweakSection, {
    label: "Motion"
  }), /*#__PURE__*/React.createElement(TweakRadio, {
    label: "Pace",
    value: t.speed,
    options: ["relaxed", "normal", "snappy"],
    onChange: v => {
      setTweak("speed", v);
      setRunId(n => n + 1);
    }
  }), /*#__PURE__*/React.createElement(TweakToggle, {
    label: "Clouds",
    value: t.clouds,
    onChange: v => setTweak("clouds", v)
  }), /*#__PURE__*/React.createElement(TweakToggle, {
    label: "Loading dots",
    value: t.loader,
    onChange: v => setTweak("loader", v)
  })));
}
ReactDOM.createRoot(document.getElementById('root')).render(/*#__PURE__*/React.createElement(Splash, null));
})(); } catch (e) { __ds_ns.__errors.push({ path: "splash/splash.jsx", error: String((e && e.message) || e) }); }

// splash/tweaks-panel.jsx
try { (() => {
// @ds-adherence-ignore -- omelette starter scaffold (raw elements/hex/px by design)

/* BEGIN USAGE */
// tweaks-panel.jsx
// Reusable Tweaks shell + form-control helpers.
// Exports (to window): useTweaks, TweaksPanel, TweakSection, TweakRow, TweakSlider,
//   TweakToggle, TweakRadio, TweakSelect, TweakText, TweakNumber, TweakColor, TweakButton.
//
// Owns the host protocol (listens for __activate_edit_mode / __deactivate_edit_mode,
// posts __edit_mode_available / __edit_mode_set_keys / __edit_mode_dismissed) so
// individual prototypes don't re-roll it. Ships a consistent set of controls so you
// don't hand-draw <input type="range">, segmented radios, steppers, etc.
//
// Usage (in an HTML file that loads React + Babel):
//
//   const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
//     "primaryColor": "#D97757",
//     "palette": ["#D97757", "#29261b", "#f6f4ef"],
//     "fontSize": 16,
//     "density": "regular",
//     "dark": false
//   }/*EDITMODE-END*/;
//
//   function App() {
//     const [t, setTweak] = useTweaks(TWEAK_DEFAULTS);
//     return (
//       <div style={{ fontSize: t.fontSize, color: t.primaryColor }}>
//         Hello
//         <TweaksPanel>
//           <TweakSection label="Typography" />
//           <TweakSlider label="Font size" value={t.fontSize} min={10} max={32} unit="px"
//                        onChange={(v) => setTweak('fontSize', v)} />
//           <TweakRadio  label="Density" value={t.density}
//                        options={['compact', 'regular', 'comfy']}
//                        onChange={(v) => setTweak('density', v)} />
//           <TweakSection label="Theme" />
//           <TweakColor  label="Primary" value={t.primaryColor}
//                        options={['#D97757', '#2A6FDB', '#1F8A5B', '#7A5AE0']}
//                        onChange={(v) => setTweak('primaryColor', v)} />
//           <TweakColor  label="Palette" value={t.palette}
//                        options={[['#D97757', '#29261b', '#f6f4ef'],
//                                  ['#475569', '#0f172a', '#f1f5f9']]}
//                        onChange={(v) => setTweak('palette', v)} />
//           <TweakToggle label="Dark mode" value={t.dark}
//                        onChange={(v) => setTweak('dark', v)} />
//         </TweaksPanel>
//       </div>
//     );
//   }
//
// TweakRadio is the segmented control for 2–3 short options (auto-falls-back to
// TweakSelect past ~16/~10 chars per label); reach for TweakSelect directly when
// options are many or long. For color tweaks always curate 3-4 options rather than
// a free picker; an option can also be a whole 2–5 color palette (the stored value
// is the array). The Tweak* controls are a floor, not a ceiling — build custom
// controls inside the panel if a tweak calls for UI they don't cover.
/* END USAGE */
// ─────────────────────────────────────────────────────────────────────────────

const __TWEAKS_STYLE = `
  .twk-panel{position:fixed;right:16px;bottom:16px;z-index:2147483646;width:280px;
    max-height:calc(100vh - 32px);display:flex;flex-direction:column;
    transform:scale(var(--dc-inv-zoom,1));transform-origin:bottom right;
    background:rgba(250,249,247,.78);color:#29261b;
    -webkit-backdrop-filter:blur(24px) saturate(160%);backdrop-filter:blur(24px) saturate(160%);
    border:.5px solid rgba(255,255,255,.6);border-radius:14px;
    box-shadow:0 1px 0 rgba(255,255,255,.5) inset,0 12px 40px rgba(0,0,0,.18);
    font:11.5px/1.4 ui-sans-serif,system-ui,-apple-system,sans-serif;overflow:hidden}
  .twk-hd{display:flex;align-items:center;justify-content:space-between;
    padding:10px 8px 10px 14px;cursor:move;user-select:none}
  .twk-hd b{font-size:12px;font-weight:600;letter-spacing:.01em}
  .twk-x{appearance:none;border:0;background:transparent;color:rgba(41,38,27,.55);
    width:22px;height:22px;border-radius:6px;cursor:default;font-size:13px;line-height:1}
  .twk-x:hover{background:rgba(0,0,0,.06);color:#29261b}
  .twk-body{padding:2px 14px 14px;display:flex;flex-direction:column;gap:10px;
    overflow-y:auto;overflow-x:hidden;min-height:0;
    scrollbar-width:thin;scrollbar-color:rgba(0,0,0,.15) transparent}
  .twk-body::-webkit-scrollbar{width:8px}
  .twk-body::-webkit-scrollbar-track{background:transparent;margin:2px}
  .twk-body::-webkit-scrollbar-thumb{background:rgba(0,0,0,.15);border-radius:4px;
    border:2px solid transparent;background-clip:content-box}
  .twk-body::-webkit-scrollbar-thumb:hover{background:rgba(0,0,0,.25);
    border:2px solid transparent;background-clip:content-box}
  .twk-row{display:flex;flex-direction:column;gap:5px}
  .twk-row-h{flex-direction:row;align-items:center;justify-content:space-between;gap:10px}
  .twk-lbl{display:flex;justify-content:space-between;align-items:baseline;
    color:rgba(41,38,27,.72)}
  .twk-lbl>span:first-child{font-weight:500}
  .twk-val{color:rgba(41,38,27,.5);font-variant-numeric:tabular-nums}

  .twk-sect{font-size:10px;font-weight:600;letter-spacing:.06em;text-transform:uppercase;
    color:rgba(41,38,27,.45);padding:10px 0 0}
  .twk-sect:first-child{padding-top:0}

  .twk-field{appearance:none;box-sizing:border-box;width:100%;min-width:0;height:26px;padding:0 8px;
    border:.5px solid rgba(0,0,0,.1);border-radius:7px;
    background:rgba(255,255,255,.6);color:inherit;font:inherit;outline:none}
  .twk-field:focus{border-color:rgba(0,0,0,.25);background:rgba(255,255,255,.85)}
  select.twk-field{padding-right:22px;
    background-image:url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='10' height='6' viewBox='0 0 10 6'><path fill='rgba(0,0,0,.5)' d='M0 0h10L5 6z'/></svg>");
    background-repeat:no-repeat;background-position:right 8px center}

  .twk-slider{appearance:none;-webkit-appearance:none;width:100%;height:4px;margin:6px 0;
    border-radius:999px;background:rgba(0,0,0,.12);outline:none}
  .twk-slider::-webkit-slider-thumb{-webkit-appearance:none;appearance:none;
    width:14px;height:14px;border-radius:50%;background:#fff;
    border:.5px solid rgba(0,0,0,.12);box-shadow:0 1px 3px rgba(0,0,0,.2);cursor:default}
  .twk-slider::-moz-range-thumb{width:14px;height:14px;border-radius:50%;
    background:#fff;border:.5px solid rgba(0,0,0,.12);box-shadow:0 1px 3px rgba(0,0,0,.2);cursor:default}

  .twk-seg{position:relative;display:flex;padding:2px;border-radius:8px;
    background:rgba(0,0,0,.06);user-select:none}
  .twk-seg-thumb{position:absolute;top:2px;bottom:2px;border-radius:6px;
    background:rgba(255,255,255,.9);box-shadow:0 1px 2px rgba(0,0,0,.12);
    transition:left .15s cubic-bezier(.3,.7,.4,1),width .15s}
  .twk-seg.dragging .twk-seg-thumb{transition:none}
  .twk-seg button{appearance:none;position:relative;z-index:1;flex:1;border:0;
    background:transparent;color:inherit;font:inherit;font-weight:500;min-height:22px;
    border-radius:6px;cursor:default;padding:4px 6px;line-height:1.2;
    overflow-wrap:anywhere}

  .twk-toggle{position:relative;width:32px;height:18px;border:0;border-radius:999px;
    background:rgba(0,0,0,.15);transition:background .15s;cursor:default;padding:0}
  .twk-toggle[data-on="1"]{background:#34c759}
  .twk-toggle i{position:absolute;top:2px;left:2px;width:14px;height:14px;border-radius:50%;
    background:#fff;box-shadow:0 1px 2px rgba(0,0,0,.25);transition:transform .15s}
  .twk-toggle[data-on="1"] i{transform:translateX(14px)}

  .twk-num{display:flex;align-items:center;box-sizing:border-box;min-width:0;height:26px;padding:0 0 0 8px;
    border:.5px solid rgba(0,0,0,.1);border-radius:7px;background:rgba(255,255,255,.6)}
  .twk-num-lbl{font-weight:500;color:rgba(41,38,27,.6);cursor:ew-resize;
    user-select:none;padding-right:8px}
  .twk-num input{flex:1;min-width:0;height:100%;border:0;background:transparent;
    font:inherit;font-variant-numeric:tabular-nums;text-align:right;padding:0 8px 0 0;
    outline:none;color:inherit;-moz-appearance:textfield}
  .twk-num input::-webkit-inner-spin-button,.twk-num input::-webkit-outer-spin-button{
    -webkit-appearance:none;margin:0}
  .twk-num-unit{padding-right:8px;color:rgba(41,38,27,.45)}

  .twk-btn{appearance:none;height:26px;padding:0 12px;border:0;border-radius:7px;
    background:rgba(0,0,0,.78);color:#fff;font:inherit;font-weight:500;cursor:default}
  .twk-btn:hover{background:rgba(0,0,0,.88)}
  .twk-btn.secondary{background:rgba(0,0,0,.06);color:inherit}
  .twk-btn.secondary:hover{background:rgba(0,0,0,.1)}

  .twk-swatch{appearance:none;-webkit-appearance:none;width:56px;height:22px;
    border:.5px solid rgba(0,0,0,.1);border-radius:6px;padding:0;cursor:default;
    background:transparent;flex-shrink:0}
  .twk-swatch::-webkit-color-swatch-wrapper{padding:0}
  .twk-swatch::-webkit-color-swatch{border:0;border-radius:5.5px}
  .twk-swatch::-moz-color-swatch{border:0;border-radius:5.5px}

  .twk-chips{display:flex;gap:6px}
  .twk-chip{position:relative;appearance:none;flex:1;min-width:0;height:46px;
    padding:0;border:0;border-radius:6px;overflow:hidden;cursor:default;
    box-shadow:0 0 0 .5px rgba(0,0,0,.12),0 1px 2px rgba(0,0,0,.06);
    transition:transform .12s cubic-bezier(.3,.7,.4,1),box-shadow .12s}
  .twk-chip:hover{transform:translateY(-1px);
    box-shadow:0 0 0 .5px rgba(0,0,0,.18),0 4px 10px rgba(0,0,0,.12)}
  .twk-chip[data-on="1"]{box-shadow:0 0 0 1.5px rgba(0,0,0,.85),
    0 2px 6px rgba(0,0,0,.15)}
  .twk-chip>span{position:absolute;top:0;bottom:0;right:0;width:34%;
    display:flex;flex-direction:column;box-shadow:-1px 0 0 rgba(0,0,0,.1)}
  .twk-chip>span>i{flex:1;box-shadow:0 -1px 0 rgba(0,0,0,.1)}
  .twk-chip>span>i:first-child{box-shadow:none}
  .twk-chip svg{position:absolute;top:6px;left:6px;width:13px;height:13px;
    filter:drop-shadow(0 1px 1px rgba(0,0,0,.3))}
`;

// ── useTweaks ───────────────────────────────────────────────────────────────
// Single source of truth for tweak values. setTweak persists via the host
// (__edit_mode_set_keys → host rewrites the EDITMODE block on disk).
function useTweaks(defaults) {
  const [values, setValues] = React.useState(defaults);
  // Accepts either setTweak('key', value) or setTweak({ key: value, ... }) so a
  // useState-style call doesn't write a "[object Object]" key into the persisted
  // JSON block.
  const setTweak = React.useCallback((keyOrEdits, val) => {
    const edits = typeof keyOrEdits === 'object' && keyOrEdits !== null ? keyOrEdits : {
      [keyOrEdits]: val
    };
    setValues(prev => ({
      ...prev,
      ...edits
    }));
    window.parent.postMessage({
      type: '__edit_mode_set_keys',
      edits
    }, '*');
    // Same-window signal so in-page listeners (deck-stage rail thumbnails)
    // can react — the parent message only reaches the host, not peers.
    window.dispatchEvent(new CustomEvent('tweakchange', {
      detail: edits
    }));
  }, []);
  return [values, setTweak];
}

// ── TweaksPanel ─────────────────────────────────────────────────────────────
// Floating shell. Registers the protocol listener BEFORE announcing
// availability — if the announce ran first, the host's activate could land
// before our handler exists and the toolbar toggle would silently no-op.
// The close button posts __edit_mode_dismissed so the host's toolbar toggle
// flips off in lockstep; the host echoes __deactivate_edit_mode back which
// is what actually hides the panel.
function TweaksPanel({
  title = 'Tweaks',
  children
}) {
  const [open, setOpen] = React.useState(false);
  const dragRef = React.useRef(null);
  const offsetRef = React.useRef({
    x: 16,
    y: 16
  });
  const PAD = 16;
  const clampToViewport = React.useCallback(() => {
    const panel = dragRef.current;
    if (!panel) return;
    const w = panel.offsetWidth,
      h = panel.offsetHeight;
    const maxRight = Math.max(PAD, window.innerWidth - w - PAD);
    const maxBottom = Math.max(PAD, window.innerHeight - h - PAD);
    offsetRef.current = {
      x: Math.min(maxRight, Math.max(PAD, offsetRef.current.x)),
      y: Math.min(maxBottom, Math.max(PAD, offsetRef.current.y))
    };
    panel.style.right = offsetRef.current.x + 'px';
    panel.style.bottom = offsetRef.current.y + 'px';
  }, []);
  React.useEffect(() => {
    if (!open) return;
    clampToViewport();
    if (typeof ResizeObserver === 'undefined') {
      window.addEventListener('resize', clampToViewport);
      return () => window.removeEventListener('resize', clampToViewport);
    }
    const ro = new ResizeObserver(clampToViewport);
    ro.observe(document.documentElement);
    return () => ro.disconnect();
  }, [open, clampToViewport]);
  React.useEffect(() => {
    const onMsg = e => {
      const t = e?.data?.type;
      if (t === '__activate_edit_mode') setOpen(true);else if (t === '__deactivate_edit_mode') setOpen(false);
    };
    window.addEventListener('message', onMsg);
    window.parent.postMessage({
      type: '__edit_mode_available'
    }, '*');
    return () => window.removeEventListener('message', onMsg);
  }, []);
  const dismiss = () => {
    setOpen(false);
    window.parent.postMessage({
      type: '__edit_mode_dismissed'
    }, '*');
  };
  const onDragStart = e => {
    const panel = dragRef.current;
    if (!panel) return;
    const r = panel.getBoundingClientRect();
    const sx = e.clientX,
      sy = e.clientY;
    const startRight = window.innerWidth - r.right;
    const startBottom = window.innerHeight - r.bottom;
    const move = ev => {
      offsetRef.current = {
        x: startRight - (ev.clientX - sx),
        y: startBottom - (ev.clientY - sy)
      };
      clampToViewport();
    };
    const up = () => {
      window.removeEventListener('mousemove', move);
      window.removeEventListener('mouseup', up);
    };
    window.addEventListener('mousemove', move);
    window.addEventListener('mouseup', up);
  };
  if (!open) return null;
  return /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement("style", null, __TWEAKS_STYLE), /*#__PURE__*/React.createElement("div", {
    ref: dragRef,
    className: "twk-panel",
    "data-omelette-chrome": "",
    style: {
      right: offsetRef.current.x,
      bottom: offsetRef.current.y
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "twk-hd",
    onMouseDown: onDragStart
  }, /*#__PURE__*/React.createElement("b", null, title), /*#__PURE__*/React.createElement("button", {
    className: "twk-x",
    "aria-label": "Close tweaks",
    onMouseDown: e => e.stopPropagation(),
    onClick: dismiss
  }, "\u2715")), /*#__PURE__*/React.createElement("div", {
    className: "twk-body"
  }, children)));
}

// ── Layout helpers ──────────────────────────────────────────────────────────

function TweakSection({
  label,
  children
}) {
  return /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement("div", {
    className: "twk-sect"
  }, label), children);
}
function TweakRow({
  label,
  value,
  children,
  inline = false
}) {
  return /*#__PURE__*/React.createElement("div", {
    className: inline ? 'twk-row twk-row-h' : 'twk-row'
  }, /*#__PURE__*/React.createElement("div", {
    className: "twk-lbl"
  }, /*#__PURE__*/React.createElement("span", null, label), value != null && /*#__PURE__*/React.createElement("span", {
    className: "twk-val"
  }, value)), children);
}

// ── Controls ────────────────────────────────────────────────────────────────

function TweakSlider({
  label,
  value,
  min = 0,
  max = 100,
  step = 1,
  unit = '',
  onChange
}) {
  return /*#__PURE__*/React.createElement(TweakRow, {
    label: label,
    value: `${value}${unit}`
  }, /*#__PURE__*/React.createElement("input", {
    type: "range",
    className: "twk-slider",
    min: min,
    max: max,
    step: step,
    value: value,
    onChange: e => onChange(Number(e.target.value))
  }));
}
function TweakToggle({
  label,
  value,
  onChange
}) {
  return /*#__PURE__*/React.createElement("div", {
    className: "twk-row twk-row-h"
  }, /*#__PURE__*/React.createElement("div", {
    className: "twk-lbl"
  }, /*#__PURE__*/React.createElement("span", null, label)), /*#__PURE__*/React.createElement("button", {
    type: "button",
    className: "twk-toggle",
    "data-on": value ? '1' : '0',
    role: "switch",
    "aria-checked": !!value,
    onClick: () => onChange(!value)
  }, /*#__PURE__*/React.createElement("i", null)));
}
function TweakRadio({
  label,
  value,
  options,
  onChange
}) {
  const trackRef = React.useRef(null);
  const [dragging, setDragging] = React.useState(false);
  // The active value is read by pointer-move handlers attached for the lifetime
  // of a drag — ref it so a stale closure doesn't fire onChange for every move.
  const valueRef = React.useRef(value);
  valueRef.current = value;

  // Segments wrap mid-word once per-segment width runs out. The track is
  // ~248px (280 panel − 28 body pad − 4 seg pad), each button loses 12px
  // to its own padding, and 11.5px system-ui averages ~6.3px/char — so 2
  // options fit ~16 chars each, 3 fit ~10. Past that (or >3 options), fall
  // back to a dropdown rather than wrap.
  const labelLen = o => String(typeof o === 'object' ? o.label : o).length;
  const maxLen = options.reduce((m, o) => Math.max(m, labelLen(o)), 0);
  const fitsAsSegments = maxLen <= ({
    2: 16,
    3: 10
  }[options.length] ?? 0);
  if (!fitsAsSegments) {
    // <select> emits strings — map back to the original option value so the
    // fallback stays type-preserving (numbers, booleans) like the segment path.
    const resolve = s => {
      const m = options.find(o => String(typeof o === 'object' ? o.value : o) === s);
      return m === undefined ? s : typeof m === 'object' ? m.value : m;
    };
    return /*#__PURE__*/React.createElement(TweakSelect, {
      label: label,
      value: value,
      options: options,
      onChange: s => onChange(resolve(s))
    });
  }
  const opts = options.map(o => typeof o === 'object' ? o : {
    value: o,
    label: o
  });
  const idx = Math.max(0, opts.findIndex(o => o.value === value));
  const n = opts.length;
  const segAt = clientX => {
    const r = trackRef.current.getBoundingClientRect();
    const inner = r.width - 4;
    const i = Math.floor((clientX - r.left - 2) / inner * n);
    return opts[Math.max(0, Math.min(n - 1, i))].value;
  };
  const onPointerDown = e => {
    setDragging(true);
    const v0 = segAt(e.clientX);
    if (v0 !== valueRef.current) onChange(v0);
    const move = ev => {
      if (!trackRef.current) return;
      const v = segAt(ev.clientX);
      if (v !== valueRef.current) onChange(v);
    };
    const up = () => {
      setDragging(false);
      window.removeEventListener('pointermove', move);
      window.removeEventListener('pointerup', up);
    };
    window.addEventListener('pointermove', move);
    window.addEventListener('pointerup', up);
  };
  return /*#__PURE__*/React.createElement(TweakRow, {
    label: label
  }, /*#__PURE__*/React.createElement("div", {
    ref: trackRef,
    role: "radiogroup",
    onPointerDown: onPointerDown,
    className: dragging ? 'twk-seg dragging' : 'twk-seg'
  }, /*#__PURE__*/React.createElement("div", {
    className: "twk-seg-thumb",
    style: {
      left: `calc(2px + ${idx} * (100% - 4px) / ${n})`,
      width: `calc((100% - 4px) / ${n})`
    }
  }), opts.map(o => /*#__PURE__*/React.createElement("button", {
    key: o.value,
    type: "button",
    role: "radio",
    "aria-checked": o.value === value
  }, o.label))));
}
function TweakSelect({
  label,
  value,
  options,
  onChange
}) {
  return /*#__PURE__*/React.createElement(TweakRow, {
    label: label
  }, /*#__PURE__*/React.createElement("select", {
    className: "twk-field",
    value: value,
    onChange: e => onChange(e.target.value)
  }, options.map(o => {
    const v = typeof o === 'object' ? o.value : o;
    const l = typeof o === 'object' ? o.label : o;
    return /*#__PURE__*/React.createElement("option", {
      key: v,
      value: v
    }, l);
  })));
}
function TweakText({
  label,
  value,
  placeholder,
  onChange
}) {
  return /*#__PURE__*/React.createElement(TweakRow, {
    label: label
  }, /*#__PURE__*/React.createElement("input", {
    className: "twk-field",
    type: "text",
    value: value,
    placeholder: placeholder,
    onChange: e => onChange(e.target.value)
  }));
}
function TweakNumber({
  label,
  value,
  min,
  max,
  step = 1,
  unit = '',
  onChange
}) {
  const clamp = n => {
    if (min != null && n < min) return min;
    if (max != null && n > max) return max;
    return n;
  };
  const startRef = React.useRef({
    x: 0,
    val: 0
  });
  const onScrubStart = e => {
    e.preventDefault();
    startRef.current = {
      x: e.clientX,
      val: value
    };
    const decimals = (String(step).split('.')[1] || '').length;
    const move = ev => {
      const dx = ev.clientX - startRef.current.x;
      const raw = startRef.current.val + dx * step;
      const snapped = Math.round(raw / step) * step;
      onChange(clamp(Number(snapped.toFixed(decimals))));
    };
    const up = () => {
      window.removeEventListener('pointermove', move);
      window.removeEventListener('pointerup', up);
    };
    window.addEventListener('pointermove', move);
    window.addEventListener('pointerup', up);
  };
  return /*#__PURE__*/React.createElement("div", {
    className: "twk-num"
  }, /*#__PURE__*/React.createElement("span", {
    className: "twk-num-lbl",
    onPointerDown: onScrubStart
  }, label), /*#__PURE__*/React.createElement("input", {
    type: "number",
    value: value,
    min: min,
    max: max,
    step: step,
    onChange: e => onChange(clamp(Number(e.target.value)))
  }), unit && /*#__PURE__*/React.createElement("span", {
    className: "twk-num-unit"
  }, unit));
}

// Relative-luminance contrast pick — checkmarks drawn over a swatch need to
// read on both #111 and #fafafa without per-option configuration. Hex input
// only (#rgb / #rrggbb); named or rgb()/hsl() colors fall through to "light".
function __twkIsLight(hex) {
  const h = String(hex).replace('#', '');
  const x = h.length === 3 ? h.replace(/./g, c => c + c) : h.padEnd(6, '0');
  const n = parseInt(x.slice(0, 6), 16);
  if (Number.isNaN(n)) return true;
  const r = n >> 16 & 255,
    g = n >> 8 & 255,
    b = n & 255;
  return r * 299 + g * 587 + b * 114 > 148000;
}
const __TwkCheck = ({
  light
}) => /*#__PURE__*/React.createElement("svg", {
  viewBox: "0 0 14 14",
  "aria-hidden": "true"
}, /*#__PURE__*/React.createElement("path", {
  d: "M3 7.2 5.8 10 11 4.2",
  fill: "none",
  strokeWidth: "2.2",
  strokeLinecap: "round",
  strokeLinejoin: "round",
  stroke: light ? 'rgba(0,0,0,.78)' : '#fff'
}));

// TweakColor — curated color/palette picker. Each option is either a single
// hex string or an array of 1-5 hex strings; the card adapts — a lone color
// renders solid, a palette renders colors[0] as the hero (left ~2/3) with the
// rest stacked in a sharp column on the right. onChange emits the
// option in the shape it was passed (string stays string, array stays array).
// Without options it falls back to the native color input for back-compat.
function TweakColor({
  label,
  value,
  options,
  onChange
}) {
  if (!options || !options.length) {
    return /*#__PURE__*/React.createElement("div", {
      className: "twk-row twk-row-h"
    }, /*#__PURE__*/React.createElement("div", {
      className: "twk-lbl"
    }, /*#__PURE__*/React.createElement("span", null, label)), /*#__PURE__*/React.createElement("input", {
      type: "color",
      className: "twk-swatch",
      value: value,
      onChange: e => onChange(e.target.value)
    }));
  }
  // Native <input type=color> emits lowercase hex per the HTML spec, so
  // compare case-insensitively. String() guards JSON.stringify(undefined),
  // which returns the primitive undefined (no .toLowerCase).
  const key = o => String(JSON.stringify(o)).toLowerCase();
  const cur = key(value);
  return /*#__PURE__*/React.createElement(TweakRow, {
    label: label
  }, /*#__PURE__*/React.createElement("div", {
    className: "twk-chips",
    role: "radiogroup"
  }, options.map((o, i) => {
    const colors = Array.isArray(o) ? o : [o];
    const [hero, ...rest] = colors;
    const sup = rest.slice(0, 4);
    const on = key(o) === cur;
    return /*#__PURE__*/React.createElement("button", {
      key: i,
      type: "button",
      className: "twk-chip",
      role: "radio",
      "aria-checked": on,
      "data-on": on ? '1' : '0',
      "aria-label": colors.join(', '),
      title: colors.join(' · '),
      style: {
        background: hero
      },
      onClick: () => onChange(o)
    }, sup.length > 0 && /*#__PURE__*/React.createElement("span", null, sup.map((c, j) => /*#__PURE__*/React.createElement("i", {
      key: j,
      style: {
        background: c
      }
    }))), on && /*#__PURE__*/React.createElement(__TwkCheck, {
      light: __twkIsLight(hero)
    }));
  })));
}
function TweakButton({
  label,
  onClick,
  secondary = false
}) {
  return /*#__PURE__*/React.createElement("button", {
    type: "button",
    className: secondary ? 'twk-btn secondary' : 'twk-btn',
    onClick: onClick
  }, label);
}
Object.assign(window, {
  useTweaks,
  TweaksPanel,
  TweakSection,
  TweakRow,
  TweakSlider,
  TweakToggle,
  TweakRadio,
  TweakSelect,
  TweakText,
  TweakNumber,
  TweakColor,
  TweakButton
});
})(); } catch (e) { __ds_ns.__errors.push({ path: "splash/tweaks-panel.jsx", error: String((e && e.message) || e) }); }

// src/app.jsx
try { (() => {
// Root App — page routing and shared state
function App() {
  const [page, setPage] = useState('search'); // 'search' | 'detail' | 'post' | 'bookings'
  const [hostelId, setHostelId] = useState(null);
  const [saved, setSaved] = useState({
    asha: true
  });
  const [search, setSearch] = useState('');
  const [division, setDivision] = useState('Dhaka');
  const toggleSave = id => setSaved(s => ({
    ...s,
    [id]: !s[id]
  }));
  const open = id => {
    setHostelId(id);
    setPage('detail');
    window.scrollTo(0, 0);
  };
  return /*#__PURE__*/React.createElement("div", {
    className: "app"
  }, /*#__PURE__*/React.createElement(Navbar, {
    page: page,
    setPage: p => {
      setPage(p);
      window.scrollTo(0, 0);
    },
    search: search,
    setSearch: setSearch,
    division: division,
    setDivision: setDivision
  }), page === 'search' && /*#__PURE__*/React.createElement(SearchPage, {
    onOpen: open,
    saved: saved,
    toggleSave: toggleSave
  }), page === 'detail' && /*#__PURE__*/React.createElement(DetailPage, {
    hostelId: hostelId,
    onBack: () => {
      setPage('search');
      window.scrollTo(0, 0);
    }
  }), page === 'post' && /*#__PURE__*/React.createElement(PostPage, {
    onDone: () => {
      setPage('search');
      window.scrollTo(0, 0);
    }
  }), page === 'bookings' && /*#__PURE__*/React.createElement(BookingsPage, null));
}
function BookingsPage() {
  return /*#__PURE__*/React.createElement("div", {
    className: "page"
  }, /*#__PURE__*/React.createElement("div", {
    className: "card",
    style: {
      padding: 40,
      textAlign: 'center',
      maxWidth: 560,
      margin: '40px auto'
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width: 60,
      height: 60,
      borderRadius: 99,
      margin: '0 auto 14px',
      background: 'var(--primary-soft)',
      color: 'var(--primary-dark)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center'
    }
  }, /*#__PURE__*/React.createElement(Icons.Calendar, {
    size: 28
  })), /*#__PURE__*/React.createElement("h2", {
    style: {
      margin: '0 0 6px'
    }
  }, "No bookings yet"), /*#__PURE__*/React.createElement("p", {
    className: "muted",
    style: {
      margin: '0 0 18px'
    }
  }, "When you book a seat, it'll show up here. Browse hostels to get started.")));
}
ReactDOM.createRoot(document.getElementById('root')).render(/*#__PURE__*/React.createElement(App, null));
})(); } catch (e) { __ds_ns.__errors.push({ path: "src/app.jsx", error: String((e && e.message) || e) }); }

// src/data.jsx
try { (() => {
// Sample hostel data + constants for NestStay
const HOSTEL_TYPES = [{
  id: 'all',
  label: 'All'
}, {
  id: 'student',
  label: 'Student'
}, {
  id: 'women',
  label: "Women's"
}, {
  id: 'mess',
  label: 'Bachelor Mess'
}, {
  id: 'corporate',
  label: 'Corporate'
}, {
  id: 'worker',
  label: "Worker's"
}, {
  id: 'medical',
  label: 'Medical'
}];
const TYPE_PILL_COLOR = {
  student: 'pill-purple',
  women: 'pill-pink',
  mess: 'pill-blue',
  corporate: 'pill-teal',
  worker: 'pill-amber',
  medical: 'pill-coral'
};
const AMENITIES = [{
  id: 'wifi',
  label: 'WiFi',
  icon: 'Wifi'
}, {
  id: 'meal',
  label: 'Meal included',
  icon: 'Utensils'
}, {
  id: 'ac',
  label: 'AC',
  icon: 'Snowflake'
}, {
  id: 'gen',
  label: 'Generator',
  icon: 'Zap'
}, {
  id: 'cctv',
  label: 'CCTV',
  icon: 'Camera'
}, {
  id: 'study',
  label: 'Study room',
  icon: 'Book'
}, {
  id: 'laundry',
  label: 'Laundry',
  icon: 'Shirt'
}, {
  id: 'bath',
  label: 'Attached bath',
  icon: 'Droplet'
}, {
  id: 'hot',
  label: 'Hot water',
  icon: 'Droplet'
}, {
  id: 'guard',
  label: '24h guard',
  icon: 'Shield'
}, {
  id: 'prayer',
  label: 'Prayer room',
  icon: 'Home'
}, {
  id: 'locker',
  label: 'Locker',
  icon: 'Lock'
}, {
  id: 'bike',
  label: 'Bike parking',
  icon: 'Bike'
}, {
  id: 'rooftop',
  label: 'Rooftop',
  icon: 'Mountain'
}, {
  id: 'canteen',
  label: 'Canteen',
  icon: 'Coffee'
}];

// 6 gradient palettes used for placeholder photos
const PHOTO_GRADS = ['linear-gradient(135deg, #1A6B72 0%, #34A6A6 100%)', 'linear-gradient(135deg, #FF8E8E 0%, #FF6B6B 60%, #C94F65 100%)', 'linear-gradient(135deg, #6B47C0 0%, #9377DC 100%)', 'linear-gradient(135deg, #1D6FD1 0%, #5BA0E8 100%)', 'linear-gradient(135deg, #A65800 0%, #FF9500 100%)', 'linear-gradient(135deg, #1E8C3F 0%, #34C759 100%)', 'linear-gradient(135deg, #0E484D 0%, #1A6B72 50%, #FF6B6B 130%)', 'linear-gradient(135deg, #B53D7C 0%, #FF8E8E 100%)'];
const HOSTELS = [{
  id: 'asha',
  name: "Asha Women's Hostel",
  type: 'women',
  typeLabel: "Women's",
  gender: 'female',
  location: 'Mirpur 1, Dhaka',
  landmark: 'near BUET',
  landmarkDist: '0.8km from BUET',
  rating: 4.8,
  reviews: 124,
  seats: {
    total: 20,
    vacant: 5
  },
  price: 4500,
  priceUnit: 'seat/month',
  advance: 2000,
  meal: {
    included: true,
    price: 1500
  },
  curfew: '10:00 PM',
  verified: true,
  grad: PHOTO_GRADS[1],
  owner: {
    name: 'Asha Begum',
    phone: '01XXXXXXXXX'
  },
  description: "A safe, well-managed women's hostel located in the heart of Mirpur 1. Just a short walk to BUET, with 24-hour security, attached bath in every room, and home-cooked meals served three times a day. Curfew enforced at 10 PM.",
  amenities: ['wifi', 'meal', 'cctv', 'study', 'laundry', 'bath', 'hot', 'guard', 'prayer', 'locker'],
  rules: ['Curfew: 10:00 PM every night', 'No male visitors above floor 1', 'No cooking in rooms', 'Noise curfew after 11 PM', 'Advance: 1 month seat rent', 'Notice period: 15 days before vacating'],
  floor: '3rd floor',
  building: 'Apartment',
  rooms: [{
    name: 'Room 1',
    seats: [{
      id: 'R1-A',
      status: 'taken'
    }, {
      id: 'R1-B',
      status: 'taken'
    }, {
      id: 'R1-C',
      status: 'vacant'
    }, {
      id: 'R1-D',
      status: 'reserved'
    }, {
      id: 'R1-E',
      status: 'vacant'
    }, {
      id: 'R1-F',
      status: 'taken'
    }]
  }, {
    name: 'Room 2',
    seats: [{
      id: 'R2-A',
      status: 'taken'
    }, {
      id: 'R2-B',
      status: 'vacant'
    }, {
      id: 'R2-C',
      status: 'taken'
    }, {
      id: 'R2-D',
      status: 'taken'
    }, {
      id: 'R2-E',
      status: 'vacant'
    }, {
      id: 'R2-F',
      status: 'taken'
    }]
  }, {
    name: 'Room 3',
    seats: [{
      id: 'R3-A',
      status: 'taken'
    }, {
      id: 'R3-B',
      status: 'taken'
    }, {
      id: 'R3-C',
      status: 'vacant'
    }, {
      id: 'R3-D',
      status: 'taken'
    }, {
      id: 'R3-E',
      status: 'taken'
    }, {
      id: 'R3-F',
      status: 'reserved'
    }]
  }],
  reviewsList: [{
    name: 'Tahmina Akter',
    date: 'Apr 2026',
    rating: 5,
    body: 'Very clean and the meals are home-style. Security is strict which I appreciate. Stayed for 8 months and felt safe.'
  }, {
    name: 'Nusrat J.',
    date: 'Mar 2026',
    rating: 5,
    body: 'Great location, walk to BUET in 10 minutes. Asha apa is very caring. Wifi could be faster though.'
  }, {
    name: 'Sumaiya R.',
    date: 'Feb 2026',
    rating: 4,
    body: 'Good value for the price. Curfew is a bit early but understandable for safety.'
  }]
}, {
  id: 'green',
  name: 'Green Valley Mess',
  type: 'mess',
  typeLabel: 'Bachelor Mess',
  gender: 'male',
  location: 'Dhanmondi 15',
  landmark: 'Dhaka',
  landmarkDist: '1.5km from Dhanmondi Lake',
  rating: 4.5,
  reviews: 86,
  seats: {
    total: 12,
    vacant: 2
  },
  price: 3800,
  priceUnit: 'seat/month',
  advance: 3800,
  meal: {
    included: false,
    price: 0
  },
  curfew: null,
  verified: false,
  grad: PHOTO_GRADS[0],
  owner: {
    name: 'Rafiq Hossain',
    phone: '01XXXXXXXXX'
  },
  description: 'Bachelor mess in central Dhanmondi. Spacious rooms, no meal service (kitchen access provided), great location for working professionals.',
  amenities: ['wifi', 'cctv', 'laundry', 'bath', 'hot', 'guard'],
  rules: ['No female visitors', 'No smoking indoors', 'Quiet hours after 11 PM', 'Advance: 1 month rent', 'Notice period: 30 days'],
  floor: '2nd floor',
  building: 'Apartment',
  rooms: [{
    name: 'Room 1',
    seats: [{
      id: 'R1-A',
      status: 'taken'
    }, {
      id: 'R1-B',
      status: 'taken'
    }, {
      id: 'R1-C',
      status: 'taken'
    }, {
      id: 'R1-D',
      status: 'vacant'
    }]
  }, {
    name: 'Room 2',
    seats: [{
      id: 'R2-A',
      status: 'taken'
    }, {
      id: 'R2-B',
      status: 'taken'
    }, {
      id: 'R2-C',
      status: 'taken'
    }, {
      id: 'R2-D',
      status: 'vacant'
    }]
  }, {
    name: 'Room 3',
    seats: [{
      id: 'R3-A',
      status: 'taken'
    }, {
      id: 'R3-B',
      status: 'taken'
    }, {
      id: 'R3-C',
      status: 'taken'
    }, {
      id: 'R3-D',
      status: 'taken'
    }]
  }],
  reviewsList: [{
    name: 'Imran Hossain',
    date: 'Apr 2026',
    rating: 4,
    body: 'Decent place for working bachelors. Kitchen is shared but clean.'
  }, {
    name: 'Saiful K.',
    date: 'Mar 2026',
    rating: 5,
    body: 'Owner is responsive. Wifi is solid. No meal service so flexibility is nice.'
  }, {
    name: 'Mahbub A.',
    date: 'Jan 2026',
    rating: 4,
    body: 'Central location, easy commute. Could use better laundry.'
  }]
}, {
  id: 'meghna',
  name: 'Meghna Student Home',
  type: 'student',
  typeLabel: 'Student',
  gender: 'mixed',
  location: 'Rajshahi',
  landmark: 'near Rajshahi University',
  landmarkDist: '600m from RU campus',
  rating: 4.7,
  reviews: 92,
  seats: {
    total: 30,
    vacant: 8
  },
  price: 2800,
  priceUnit: 'seat/month',
  advance: 2800,
  meal: {
    included: true,
    price: 1200
  },
  curfew: '11:00 PM',
  verified: true,
  grad: PHOTO_GRADS[2],
  owner: {
    name: 'Dr. Karim Uddin',
    phone: '01XXXXXXXXX'
  },
  description: 'Student-friendly hostel close to Rajshahi University campus. Mixed gender (separate floors). Quiet study environment, dedicated study room, three meals per day included for ৳1,200/month.',
  amenities: ['wifi', 'meal', 'study', 'cctv', 'laundry', 'guard', 'prayer', 'canteen'],
  rules: ['Floors are gender-separated', 'Curfew 11 PM', 'Visitors only in common area', 'Advance: 1 month rent', 'Notice: 15 days'],
  floor: 'Full building',
  building: 'Independent building',
  rooms: [{
    name: 'Room 1',
    seats: [{
      id: 'R1-A',
      status: 'taken'
    }, {
      id: 'R1-B',
      status: 'vacant'
    }, {
      id: 'R1-C',
      status: 'taken'
    }, {
      id: 'R1-D',
      status: 'taken'
    }, {
      id: 'R1-E',
      status: 'vacant'
    }, {
      id: 'R1-F',
      status: 'taken'
    }]
  }, {
    name: 'Room 2',
    seats: [{
      id: 'R2-A',
      status: 'vacant'
    }, {
      id: 'R2-B',
      status: 'taken'
    }, {
      id: 'R2-C',
      status: 'vacant'
    }, {
      id: 'R2-D',
      status: 'taken'
    }, {
      id: 'R2-E',
      status: 'taken'
    }, {
      id: 'R2-F',
      status: 'reserved'
    }]
  }, {
    name: 'Room 3',
    seats: [{
      id: 'R3-A',
      status: 'taken'
    }, {
      id: 'R3-B',
      status: 'taken'
    }, {
      id: 'R3-C',
      status: 'vacant'
    }, {
      id: 'R3-D',
      status: 'vacant'
    }, {
      id: 'R3-E',
      status: 'taken'
    }, {
      id: 'R3-F',
      status: 'taken'
    }]
  }],
  reviewsList: [{
    name: 'Rifat H.',
    date: 'Apr 2026',
    rating: 5,
    body: 'Best part is the study room — open 24/7. Great for finals.'
  }, {
    name: 'Anika S.',
    date: 'Mar 2026',
    rating: 5,
    body: 'Food is good, hostel is clean. Walking distance to campus.'
  }, {
    name: 'Sajid M.',
    date: 'Feb 2026',
    rating: 4,
    body: 'Affordable and well-maintained. Wifi drops occasionally.'
  }]
}, {
  id: 'capital',
  name: 'Capital Guesthouse',
  type: 'corporate',
  typeLabel: 'Corporate',
  gender: 'mixed',
  location: 'Motijheel',
  landmark: 'Dhaka CBD',
  landmarkDist: '5min walk to Motijheel station',
  rating: 4.3,
  reviews: 41,
  seats: {
    total: 10,
    vacant: 3
  },
  price: 1200,
  priceUnit: 'day',
  advance: 1200,
  meal: {
    included: false,
    price: 0
  },
  curfew: null,
  verified: false,
  grad: PHOTO_GRADS[3],
  owner: {
    name: 'Capital Hospitality Ltd.',
    phone: '01XXXXXXXXX'
  },
  description: 'Corporate guesthouse in Motijheel for short-stay business travelers. Per-day pricing, daily housekeeping, breakfast available.',
  amenities: ['wifi', 'ac', 'cctv', 'laundry', 'bath', 'hot', 'guard'],
  rules: ['ID required at check-in', 'No outside visitors after 9 PM', 'Per-day billing', 'Check-out by 12 PM'],
  floor: '4th & 5th floor',
  building: 'Commercial tower',
  rooms: [{
    name: 'Room 1',
    seats: [{
      id: 'R1-A',
      status: 'taken'
    }, {
      id: 'R1-B',
      status: 'taken'
    }, {
      id: 'R1-C',
      status: 'vacant'
    }, {
      id: 'R1-D',
      status: 'taken'
    }]
  }, {
    name: 'Room 2',
    seats: [{
      id: 'R2-A',
      status: 'vacant'
    }, {
      id: 'R2-B',
      status: 'taken'
    }, {
      id: 'R2-C',
      status: 'vacant'
    }, {
      id: 'R2-D',
      status: 'taken'
    }]
  }],
  reviewsList: [{
    name: 'Tareq A.',
    date: 'Apr 2026',
    rating: 4,
    body: 'Convenient for short business trips. Clean rooms.'
  }, {
    name: 'Ms. Farzana',
    date: 'Mar 2026',
    rating: 4,
    body: 'AC works well, staff is professional.'
  }, {
    name: 'Habib R.',
    date: 'Feb 2026',
    rating: 5,
    body: 'Best location in Motijheel. Slightly pricey per night but worth it.'
  }]
}, {
  id: 'padma',
  name: "Padma Worker's Dorm",
  type: 'worker',
  typeLabel: "Worker's",
  gender: 'male',
  location: 'Ashulia EPZ',
  landmark: 'Savar',
  landmarkDist: '300m from EPZ Gate 2',
  rating: 4.4,
  reviews: 168,
  seats: {
    total: 50,
    vacant: 14
  },
  price: 2500,
  priceUnit: 'seat/month',
  advance: 2500,
  meal: {
    included: true,
    price: 1000
  },
  curfew: '10:30 PM',
  verified: false,
  grad: PHOTO_GRADS[4],
  owner: {
    name: 'Padma Dormitory Co.',
    phone: '01XXXXXXXXX'
  },
  description: 'Large dormitory for EPZ workers. Bunk beds, three shifts, meal canteen on-site, prayer room, lockers for each worker.',
  amenities: ['meal', 'cctv', 'guard', 'prayer', 'locker', 'canteen', 'laundry'],
  rules: ['ID badge required', 'Curfew 10:30 PM', 'Quiet hours during shift sleep', 'Advance: 1 month rent', 'Notice: 7 days'],
  floor: 'Ground + 2 floors',
  building: 'Purpose-built dorm',
  rooms: [{
    name: 'Bay A',
    seats: [{
      id: 'A-1',
      status: 'taken'
    }, {
      id: 'A-2',
      status: 'taken'
    }, {
      id: 'A-3',
      status: 'vacant'
    }, {
      id: 'A-4',
      status: 'taken'
    }, {
      id: 'A-5',
      status: 'vacant'
    }, {
      id: 'A-6',
      status: 'taken'
    }]
  }, {
    name: 'Bay B',
    seats: [{
      id: 'B-1',
      status: 'vacant'
    }, {
      id: 'B-2',
      status: 'taken'
    }, {
      id: 'B-3',
      status: 'vacant'
    }, {
      id: 'B-4',
      status: 'vacant'
    }, {
      id: 'B-5',
      status: 'taken'
    }, {
      id: 'B-6',
      status: 'vacant'
    }]
  }, {
    name: 'Bay C',
    seats: [{
      id: 'C-1',
      status: 'taken'
    }, {
      id: 'C-2',
      status: 'taken'
    }, {
      id: 'C-3',
      status: 'vacant'
    }, {
      id: 'C-4',
      status: 'taken'
    }, {
      id: 'C-5',
      status: 'taken'
    }, {
      id: 'C-6',
      status: 'reserved'
    }]
  }],
  reviewsList: [{
    name: 'Jamal M.',
    date: 'Apr 2026',
    rating: 4,
    body: "Affordable and right next to EPZ. Canteen food is okay."
  }, {
    name: 'Rakib H.',
    date: 'Mar 2026',
    rating: 5,
    body: 'Great for night shift workers. Lockers are useful.'
  }, {
    name: 'Sumon A.',
    date: 'Feb 2026',
    rating: 4,
    body: 'Crowded but clean. Owner is reachable.'
  }]
}, {
  id: 'comfort',
  name: 'Comfort Care Hostel',
  type: 'medical',
  typeLabel: 'Medical',
  gender: 'mixed',
  location: 'Shahbag',
  landmark: 'near DMCH',
  landmarkDist: '200m from DMCH main gate',
  rating: 4.6,
  reviews: 67,
  seats: {
    total: 8,
    vacant: 2
  },
  price: 900,
  priceUnit: 'day',
  advance: 900,
  meal: {
    included: true,
    price: 800
  },
  curfew: null,
  verified: true,
  grad: PHOTO_GRADS[5],
  owner: {
    name: 'Comfort Care Ltd.',
    phone: '01XXXXXXXXX'
  },
  description: 'Hostel for patient attendants near Dhaka Medical College Hospital. Per-day stays, light meals available, 24/7 access, attached bath.',
  amenities: ['wifi', 'meal', 'ac', 'cctv', 'bath', 'hot', 'guard'],
  rules: ['Patient attendant ID encouraged', 'No curfew', 'Quiet hours after 10 PM', 'Per-day billing', 'Advance: 1 day rent'],
  floor: '2nd floor',
  building: 'Apartment',
  rooms: [{
    name: 'Room 1',
    seats: [{
      id: 'R1-A',
      status: 'taken'
    }, {
      id: 'R1-B',
      status: 'vacant'
    }, {
      id: 'R1-C',
      status: 'taken'
    }, {
      id: 'R1-D',
      status: 'taken'
    }]
  }, {
    name: 'Room 2',
    seats: [{
      id: 'R2-A',
      status: 'taken'
    }, {
      id: 'R2-B',
      status: 'taken'
    }, {
      id: 'R2-C',
      status: 'vacant'
    }, {
      id: 'R2-D',
      status: 'taken'
    }]
  }],
  reviewsList: [{
    name: 'Mr. Anwar',
    date: 'Apr 2026',
    rating: 5,
    body: 'A lifesaver when my mother was admitted at DMCH. Walked over in 3 minutes.'
  }, {
    name: 'Mrs. Selina',
    date: 'Mar 2026',
    rating: 4,
    body: 'Clean and very close to the hospital. AC works well.'
  }, {
    name: 'Mohid K.',
    date: 'Feb 2026',
    rating: 5,
    body: 'Staff understood our situation, very accommodating.'
  }]
}];
const DIVISIONS = ['Dhaka', 'Chittagong', 'Rajshahi', 'Khulna', 'Sylhet', 'Barishal', 'Rangpur', 'Mymensingh'];
const DISTRICTS = {
  Dhaka: ['Dhaka', 'Gazipur', 'Narayanganj', 'Tangail', 'Manikganj', 'Munshiganj'],
  Chittagong: ['Chittagong', "Cox's Bazar", 'Comilla', 'Feni', 'Noakhali'],
  Rajshahi: ['Rajshahi', 'Bogura', 'Pabna', 'Sirajganj', 'Natore'],
  Khulna: ['Khulna', 'Jessore', 'Satkhira', 'Bagerhat'],
  Sylhet: ['Sylhet', 'Sunamganj', 'Habiganj', 'Moulvibazar'],
  Barishal: ['Barishal', 'Patuakhali', 'Pirojpur'],
  Rangpur: ['Rangpur', 'Dinajpur', 'Nilphamari'],
  Mymensingh: ['Mymensingh', 'Jamalpur', 'Sherpur', 'Netrokona']
};
const UPAZILAS = {
  Dhaka: ['Mirpur', 'Dhanmondi', 'Motijheel', 'Gulshan', 'Mohammadpur', 'Uttara'],
  Rajshahi: ['Boalia', 'Motihar', 'Shah Makhdum', 'Rajpara']
};
const fmtBDT = n => '৳' + Number(n).toLocaleString('en-BD');
Object.assign(window, {
  HOSTELS,
  AMENITIES,
  HOSTEL_TYPES,
  TYPE_PILL_COLOR,
  PHOTO_GRADS,
  DIVISIONS,
  DISTRICTS,
  UPAZILAS,
  fmtBDT
});
})(); } catch (e) { __ds_ns.__errors.push({ path: "src/data.jsx", error: String((e && e.message) || e) }); }

// src/detail-page.jsx
try { (() => {
// Page 2 — Hostel Detail
// Globals: Icons, HOSTELS, AMENITIES, TYPE_PILL_COLOR, fmtBDT, Button, Toggle, StarRow, PhotoPH

function SeatGrid({
  rooms,
  selectedSeat,
  setSelectedSeat
}) {
  return /*#__PURE__*/React.createElement(React.Fragment, null, rooms.map((room, idx) => /*#__PURE__*/React.createElement("div", {
    className: "seat-section",
    key: idx
  }, /*#__PURE__*/React.createElement("h4", {
    className: "seat-room-title"
  }, /*#__PURE__*/React.createElement(Icons.Grid, {
    size: 14,
    style: {
      color: 'var(--text-2)'
    }
  }), room.name, /*#__PURE__*/React.createElement("span", {
    className: "tiny muted",
    style: {
      fontWeight: 400
    }
  }, "(", room.seats.filter(s => s.status === 'vacant').length, " vacant of ", room.seats.length, ")")), /*#__PURE__*/React.createElement("div", {
    className: "seat-grid"
  }, room.seats.map(seat => {
    const sel = selectedSeat === seat.id;
    return /*#__PURE__*/React.createElement("div", {
      key: seat.id,
      className: 'seat ' + seat.status + (sel ? ' selected' : ''),
      onClick: () => seat.status === 'vacant' ? setSelectedSeat(sel ? null : seat.id) : null,
      title: seat.id + ' · ' + seat.status
    }, seat.id);
  })))), /*#__PURE__*/React.createElement("div", {
    className: "seat-legend"
  }, /*#__PURE__*/React.createElement("span", null, /*#__PURE__*/React.createElement("span", {
    className: "dot",
    style: {
      background: 'var(--success-bg)'
    }
  }), "Vacant"), /*#__PURE__*/React.createElement("span", null, /*#__PURE__*/React.createElement("span", {
    className: "dot",
    style: {
      background: '#EDE7FD'
    }
  }), "Taken"), /*#__PURE__*/React.createElement("span", null, /*#__PURE__*/React.createElement("span", {
    className: "dot",
    style: {
      background: 'var(--warning-bg)'
    }
  }), "Reserved"), /*#__PURE__*/React.createElement("span", null, /*#__PURE__*/React.createElement("span", {
    className: "dot",
    style: {
      background: '#C8F0D2',
      border: '2px solid var(--success)',
      width: 8,
      height: 8
    }
  }), "Selected")));
}
function ReviewItem({
  r
}) {
  const initials = r.name.split(' ').map(w => w[0]).slice(0, 2).join('').toUpperCase();
  return /*#__PURE__*/React.createElement("div", {
    className: "review"
  }, /*#__PURE__*/React.createElement("div", {
    className: "av"
  }, initials), /*#__PURE__*/React.createElement("div", {
    className: "flex-1"
  }, /*#__PURE__*/React.createElement("div", {
    className: "head"
  }, /*#__PURE__*/React.createElement("span", {
    className: "name"
  }, r.name), /*#__PURE__*/React.createElement(StarRow, {
    value: r.rating,
    size: 12,
    showVal: false
  }), /*#__PURE__*/React.createElement("span", {
    className: "date"
  }, r.date)), /*#__PURE__*/React.createElement("div", {
    className: "body"
  }, r.body)));
}
function BookingCard({
  h,
  selectedSeat,
  setSelectedSeat,
  mealOn,
  setMealOn,
  moveInDate,
  setMoveInDate
}) {
  const isPerDay = h.priceUnit === 'day';
  const rent = h.price;
  const meal = mealOn && h.meal.included ? h.meal.price : 0;
  const advance = h.advance;
  const subtotal = rent + meal + advance;
  const fee = Math.round(subtotal * 0.05);
  const total = rent + meal + advance + fee;
  const vacantSeats = h.rooms.flatMap(r => r.seats.filter(s => s.status === 'vacant').map(s => s.id));
  return /*#__PURE__*/React.createElement("div", {
    className: "card book-card"
  }, /*#__PURE__*/React.createElement("div", {
    className: "big-price"
  }, fmtBDT(h.price), " ", /*#__PURE__*/React.createElement("span", {
    className: "unit"
  }, "/ ", h.priceUnit)), h.meal.included ? /*#__PURE__*/React.createElement("div", {
    className: "tiny muted",
    style: {
      marginTop: 4
    }
  }, "+ ", fmtBDT(h.meal.price), "/mo with food") : null, /*#__PURE__*/React.createElement("div", {
    className: "tiny muted"
  }, fmtBDT(h.advance), " advance to reserve"), /*#__PURE__*/React.createElement("div", {
    style: {
      marginTop: 14,
      display: 'flex',
      flexDirection: 'column',
      gap: 12
    }
  }, /*#__PURE__*/React.createElement("label", {
    className: "field"
  }, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Select seat"), /*#__PURE__*/React.createElement("select", {
    className: "select",
    value: selectedSeat || '',
    onChange: e => setSelectedSeat(e.target.value || null)
  }, /*#__PURE__*/React.createElement("option", {
    value: ""
  }, "Choose from ", vacantSeats.length, " vacant\u2026"), vacantSeats.map(s => /*#__PURE__*/React.createElement("option", {
    key: s,
    value: s
  }, s)))), /*#__PURE__*/React.createElement("label", {
    className: "field"
  }, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Move-in date"), /*#__PURE__*/React.createElement("input", {
    type: "date",
    className: "input",
    value: moveInDate,
    onChange: e => setMoveInDate(e.target.value)
  })), h.meal.included ? /*#__PURE__*/React.createElement("div", {
    className: "row",
    style: {
      justifyContent: 'space-between'
    }
  }, /*#__PURE__*/React.createElement("span", {
    style: {
      fontSize: 13
    }
  }, "Add meal plan"), /*#__PURE__*/React.createElement(Toggle, {
    checked: mealOn,
    onChange: setMealOn
  })) : null), /*#__PURE__*/React.createElement("div", {
    className: "divider-h",
    style: {
      marginTop: 14
    }
  }), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    className: "row-line"
  }, /*#__PURE__*/React.createElement("span", {
    className: "muted"
  }, "First ", isPerDay ? 'day' : 'month', " rent"), /*#__PURE__*/React.createElement("span", null, fmtBDT(rent))), h.meal.included ? /*#__PURE__*/React.createElement("div", {
    className: "row-line",
    style: {
      opacity: mealOn ? 1 : 0.45
    }
  }, /*#__PURE__*/React.createElement("span", {
    className: "muted"
  }, "Meal plan ", isPerDay ? '(1 day)' : '(1 mo)'), /*#__PURE__*/React.createElement("span", null, fmtBDT(meal))) : null, /*#__PURE__*/React.createElement("div", {
    className: "row-line"
  }, /*#__PURE__*/React.createElement("span", {
    className: "muted"
  }, "Advance"), /*#__PURE__*/React.createElement("span", null, fmtBDT(advance))), /*#__PURE__*/React.createElement("div", {
    className: "row-line"
  }, /*#__PURE__*/React.createElement("span", {
    className: "muted"
  }, "Platform fee (5%)"), /*#__PURE__*/React.createElement("span", null, fmtBDT(fee))), /*#__PURE__*/React.createElement("div", {
    className: "divider-h"
  }), /*#__PURE__*/React.createElement("div", {
    className: "row-line total"
  }, /*#__PURE__*/React.createElement("span", null, "Total due today"), /*#__PURE__*/React.createElement("span", null, fmtBDT(total)))), /*#__PURE__*/React.createElement("div", {
    style: {
      marginTop: 12,
      display: 'flex',
      flexDirection: 'column',
      gap: 8
    }
  }, /*#__PURE__*/React.createElement(Button, {
    variant: "primary",
    block: true,
    disabled: !selectedSeat
  }, "Book & Pay via bKash"), /*#__PURE__*/React.createElement(Button, {
    variant: "outline",
    block: true
  }, /*#__PURE__*/React.createElement(Icons.Phone, {
    size: 14
  }), " Contact Owner")), /*#__PURE__*/React.createElement("div", {
    className: "owner-row"
  }, /*#__PURE__*/React.createElement("div", {
    className: "av",
    style: {
      width: 38,
      height: 38,
      borderRadius: 99,
      background: 'var(--primary-soft)',
      color: 'var(--primary-dark)',
      display: 'inline-flex',
      alignItems: 'center',
      justifyContent: 'center',
      fontWeight: 600,
      flex: 'none',
      fontSize: 13
    }
  }, h.owner.name.split(' ').map(w => w[0]).slice(0, 2).join('').toUpperCase()), /*#__PURE__*/React.createElement("div", {
    className: "flex-1"
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 13,
      fontWeight: 600
    }
  }, "Managed by ", h.owner.name), /*#__PURE__*/React.createElement("div", {
    className: "tiny muted"
  }, h.owner.phone, " \xB7 WhatsApp \xB7 Phone"))));
}
function DetailPage({
  hostelId,
  onBack
}) {
  const h = HOSTELS.find(x => x.id === hostelId) || HOSTELS[0];
  const [tab, setTab] = useState('overview');
  const [tabKey, setTabKey] = useState(0);
  const [galleryIdx, setGalleryIdx] = useState(0);
  const [selectedSeat, setSelectedSeat] = useState(null);
  const [mealOn, setMealOn] = useState(h.meal.included);
  const [moveInDate, setMoveInDate] = useState('2026-06-01');
  const switchTab = t => {
    setTab(t);
    setTabKey(k => k + 1);
  };
  const galleryGrads = [h.grad, 'linear-gradient(135deg, #0E484D 0%, #34A6A6 100%)', 'linear-gradient(135deg, #FF9500 0%, #FFB74D 100%)', 'linear-gradient(135deg, #6B47C0 0%, #B189F2 100%)'];
  const TABS = [{
    id: 'overview',
    label: 'Overview'
  }, {
    id: 'seats',
    label: 'Seats'
  }, {
    id: 'amenities',
    label: 'Amenities'
  }, {
    id: 'rules',
    label: 'Rules'
  }, {
    id: 'reviews',
    label: 'Reviews'
  }];
  return /*#__PURE__*/React.createElement("div", {
    className: "page"
  }, /*#__PURE__*/React.createElement("div", {
    className: "breadcrumb"
  }, /*#__PURE__*/React.createElement(Button, {
    variant: "ghost",
    size: "sm",
    onClick: onBack
  }, /*#__PURE__*/React.createElement(Icons.ArrowLeft, {
    size: 14
  }), " Back"), /*#__PURE__*/React.createElement("span", {
    className: "dim"
  }, "/"), /*#__PURE__*/React.createElement("span", {
    className: "crumb"
  }, "Bangladesh"), /*#__PURE__*/React.createElement("span", {
    className: "dim"
  }, "/"), /*#__PURE__*/React.createElement("span", {
    className: "crumb"
  }, h.location), /*#__PURE__*/React.createElement("span", {
    className: "dim"
  }, "/"), /*#__PURE__*/React.createElement("span", {
    className: "crumb active"
  }, h.name)), /*#__PURE__*/React.createElement("div", {
    className: "detail-grid"
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    className: "gallery"
  }, /*#__PURE__*/React.createElement("div", {
    className: "gallery-main"
  }, /*#__PURE__*/React.createElement(PhotoPH, {
    grad: galleryGrads[galleryIdx],
    label: ['Main view', 'Common area', 'Room', 'Exterior'][galleryIdx],
    icon: /*#__PURE__*/React.createElement(Icons.Building2, {
      size: 68,
      strokeWidth: 1.2
    }),
    height: "100%"
  })), /*#__PURE__*/React.createElement("div", {
    className: "gallery-thumbs"
  }, galleryGrads.map((g, i) => /*#__PURE__*/React.createElement("div", {
    key: i,
    className: 'thumb ' + (galleryIdx === i ? 'active' : ''),
    onClick: () => setGalleryIdx(i),
    style: {
      background: g
    }
  })))), /*#__PURE__*/React.createElement("h1", {
    className: "h-title"
  }, h.name), /*#__PURE__*/React.createElement("div", {
    className: "h-meta"
  }, /*#__PURE__*/React.createElement("span", {
    className: "row gap-2",
    style: {
      gap: 4
    }
  }, /*#__PURE__*/React.createElement(Icons.MapPin, {
    size: 14,
    style: {
      color: 'var(--text-2)'
    }
  }), h.location, " \xB7 ", h.landmarkDist), /*#__PURE__*/React.createElement(StarRow, {
    value: h.rating,
    reviews: h.reviews
  }), h.verified ? /*#__PURE__*/React.createElement("span", {
    className: "badge"
  }, /*#__PURE__*/React.createElement(Icons.Shield, {
    size: 11
  }), " VERIFIED") : null, /*#__PURE__*/React.createElement("span", {
    className: 'pill ' + TYPE_PILL_COLOR[h.type]
  }, h.typeLabel)), /*#__PURE__*/React.createElement("div", {
    className: "tabs"
  }, TABS.map(t => /*#__PURE__*/React.createElement("button", {
    key: t.id,
    className: 'tab ' + (tab === t.id ? 'active' : ''),
    onClick: () => switchTab(t.id)
  }, t.label))), /*#__PURE__*/React.createElement("div", {
    className: "tab-body",
    key: tabKey
  }, tab === 'overview' && /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement("p", {
    style: {
      color: 'var(--text-2)',
      lineHeight: 1.6,
      margin: '0 0 12px'
    }
  }, h.description), /*#__PURE__*/React.createElement("div", {
    className: "stat-row"
  }, /*#__PURE__*/React.createElement("div", {
    className: "stat-cell"
  }, /*#__PURE__*/React.createElement("div", {
    className: "lbl"
  }, "Total seats"), /*#__PURE__*/React.createElement("div", {
    className: "val"
  }, h.seats.total)), /*#__PURE__*/React.createElement("div", {
    className: "stat-cell"
  }, /*#__PURE__*/React.createElement("div", {
    className: "lbl"
  }, "Vacant"), /*#__PURE__*/React.createElement("div", {
    className: "val",
    style: {
      color: 'var(--success)'
    }
  }, h.seats.vacant)), /*#__PURE__*/React.createElement("div", {
    className: "stat-cell"
  }, /*#__PURE__*/React.createElement("div", {
    className: "lbl"
  }, "Floor"), /*#__PURE__*/React.createElement("div", {
    className: "val",
    style: {
      fontSize: 14
    }
  }, h.floor)), /*#__PURE__*/React.createElement("div", {
    className: "stat-cell"
  }, /*#__PURE__*/React.createElement("div", {
    className: "lbl"
  }, "Building"), /*#__PURE__*/React.createElement("div", {
    className: "val",
    style: {
      fontSize: 14
    }
  }, h.building))), /*#__PURE__*/React.createElement("div", {
    className: 'policy-banner ' + h.gender
  }, h.gender === 'female' ? /*#__PURE__*/React.createElement(Icons.Users, {
    size: 16
  }) : h.gender === 'male' ? /*#__PURE__*/React.createElement(Icons.Users, {
    size: 16
  }) : /*#__PURE__*/React.createElement(Icons.Users, {
    size: 16
  }), /*#__PURE__*/React.createElement("span", null, h.gender === 'female' && 'Women only — strict gender policy enforced', h.gender === 'male' && 'Bachelor men only — no female visitors', h.gender === 'mixed' && 'Mixed gender — separate floors/rooms')), /*#__PURE__*/React.createElement("span", {
    className: "pill pill-teal",
    style: {
      marginTop: 4
    }
  }, /*#__PURE__*/React.createElement(Icons.MapPin, {
    size: 11
  }), " ", h.landmarkDist)), tab === 'seats' && /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement("div", {
    className: "row",
    style: {
      justifyContent: 'space-between',
      marginBottom: 8
    }
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    style: {
      fontWeight: 600
    }
  }, "Select a seat to book"), /*#__PURE__*/React.createElement("div", {
    className: "tiny muted"
  }, "Click a green seat to reserve it. The booking card on the right updates live."))), /*#__PURE__*/React.createElement(SeatGrid, {
    rooms: h.rooms,
    selectedSeat: selectedSeat,
    setSelectedSeat: setSelectedSeat
  }), selectedSeat ? /*#__PURE__*/React.createElement("div", {
    className: "book-btn-row"
  }, /*#__PURE__*/React.createElement(Button, {
    variant: "primary"
  }, /*#__PURE__*/React.createElement(Icons.Check, {
    size: 14
  }), " Book seat ", selectedSeat)) : null), tab === 'amenities' && /*#__PURE__*/React.createElement("div", {
    className: "am-grid"
  }, h.amenities.map(id => {
    const a = AMENITIES.find(x => x.id === id);
    if (!a) return null;
    const Ico = Icons[a.icon];
    return /*#__PURE__*/React.createElement("div", {
      key: id,
      className: "am-item"
    }, Ico ? /*#__PURE__*/React.createElement(Ico, {
      size: 16
    }) : /*#__PURE__*/React.createElement(Icons.Check, {
      size: 16
    }), /*#__PURE__*/React.createElement("span", null, a.label));
  }), AMENITIES.filter(a => !h.amenities.includes(a.id)).slice(0, 4).map(a => {
    const Ico = Icons[a.icon];
    return /*#__PURE__*/React.createElement("div", {
      key: a.id,
      className: "am-item",
      style: {
        opacity: 0.4,
        textDecoration: 'line-through'
      }
    }, Ico ? /*#__PURE__*/React.createElement(Ico, {
      size: 16
    }) : null, /*#__PURE__*/React.createElement("span", null, a.label));
  })), tab === 'rules' && /*#__PURE__*/React.createElement("ol", {
    className: "rules-list"
  }, h.rules.map((r, i) => /*#__PURE__*/React.createElement("li", {
    key: i
  }, r))), tab === 'reviews' && /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    className: "row gap-3",
    style: {
      marginBottom: 10
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 32,
      fontWeight: 700
    }
  }, h.rating.toFixed(1)), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement(StarRow, {
    value: h.rating,
    showVal: false
  }), /*#__PURE__*/React.createElement("div", {
    className: "tiny muted"
  }, h.reviews, " reviews"))), /*#__PURE__*/React.createElement("div", null, h.reviewsList.map((r, i) => /*#__PURE__*/React.createElement(ReviewItem, {
    key: i,
    r: r
  })))))), /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'sticky',
      top: 'calc(var(--nav-h) + 16px)'
    }
  }, /*#__PURE__*/React.createElement(BookingCard, {
    h: h,
    selectedSeat: selectedSeat,
    setSelectedSeat: setSelectedSeat,
    mealOn: mealOn,
    setMealOn: setMealOn,
    moveInDate: moveInDate,
    setMoveInDate: setMoveInDate
  }))));
}
window.DetailPage = DetailPage;
})(); } catch (e) { __ds_ns.__errors.push({ path: "src/detail-page.jsx", error: String((e && e.message) || e) }); }

// src/icons.jsx
try { (() => {
// Inline Lucide-style icons. 24x24, currentColor stroke.
const I = ({
  children,
  size = 18,
  strokeWidth = 2,
  style
}) => /*#__PURE__*/React.createElement("svg", {
  width: size,
  height: size,
  viewBox: "0 0 24 24",
  fill: "none",
  stroke: "currentColor",
  strokeWidth: strokeWidth,
  strokeLinecap: "round",
  strokeLinejoin: "round",
  style: style
}, children);
const Icons = {
  MapPin: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("path", {
    d: "M20 10c0 7-8 12-8 12s-8-5-8-12a8 8 0 0 1 16 0Z"
  }), /*#__PURE__*/React.createElement("circle", {
    cx: "12",
    cy: "10",
    r: "3"
  })),
  Star: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("polygon", {
    points: "12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"
  })),
  StarFill: p => /*#__PURE__*/React.createElement("svg", {
    width: p.size || 18,
    height: p.size || 18,
    viewBox: "0 0 24 24",
    fill: "currentColor",
    style: p.style
  }, /*#__PURE__*/React.createElement("polygon", {
    points: "12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"
  })),
  Search: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("circle", {
    cx: "11",
    cy: "11",
    r: "7"
  }), /*#__PURE__*/React.createElement("path", {
    d: "m21 21-4.3-4.3"
  })),
  Filter: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("polygon", {
    points: "22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"
  })),
  Heart: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("path", {
    d: "M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.29 1.51 4.04 3 5.5l7 7Z"
  })),
  HeartFill: p => /*#__PURE__*/React.createElement("svg", {
    width: p.size || 18,
    height: p.size || 18,
    viewBox: "0 0 24 24",
    fill: "currentColor",
    style: p.style
  }, /*#__PURE__*/React.createElement("path", {
    d: "M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.29 1.51 4.04 3 5.5l7 7Z"
  })),
  ChevronRight: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("polyline", {
    points: "9 18 15 12 9 6"
  })),
  ChevronLeft: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("polyline", {
    points: "15 18 9 12 15 6"
  })),
  ChevronDown: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("polyline", {
    points: "6 9 12 15 18 9"
  })),
  Check: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("polyline", {
    points: "20 6 9 17 4 12"
  })),
  X: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("line", {
    x1: "18",
    y1: "6",
    x2: "6",
    y2: "18"
  }), /*#__PURE__*/React.createElement("line", {
    x1: "6",
    y1: "6",
    x2: "18",
    y2: "18"
  })),
  Plus: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("line", {
    x1: "12",
    y1: "5",
    x2: "12",
    y2: "19"
  }), /*#__PURE__*/React.createElement("line", {
    x1: "5",
    y1: "12",
    x2: "19",
    y2: "12"
  })),
  Minus: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("line", {
    x1: "5",
    y1: "12",
    x2: "19",
    y2: "12"
  })),
  Building2: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("path", {
    d: "M6 22V4a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v18Z"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M6 12H4a2 2 0 0 0-2 2v8h4"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M18 9h2a2 2 0 0 1 2 2v11h-4"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M10 6h4"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M10 10h4"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M10 14h4"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M10 18h4"
  })),
  Users: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("path", {
    d: "M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"
  }), /*#__PURE__*/React.createElement("circle", {
    cx: "9",
    cy: "7",
    r: "4"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M22 21v-2a4 4 0 0 0-3-3.87"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M16 3.13a4 4 0 0 1 0 7.75"
  })),
  Utensils: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("path", {
    d: "M3 2v7c0 1.1.9 2 2 2h0a2 2 0 0 0 2-2V2"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M7 2v20"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M21 15V2a5 5 0 0 0-5 5v7c0 1.1.9 2 2 2h3Zm0 0v7"
  })),
  Shield: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("path", {
    d: "M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10Z"
  })),
  Clock: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("circle", {
    cx: "12",
    cy: "12",
    r: "10"
  }), /*#__PURE__*/React.createElement("polyline", {
    points: "12 6 12 12 16 14"
  })),
  Phone: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("path", {
    d: "M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92Z"
  })),
  ArrowLeft: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("line", {
    x1: "19",
    y1: "12",
    x2: "5",
    y2: "12"
  }), /*#__PURE__*/React.createElement("polyline", {
    points: "12 19 5 12 12 5"
  })),
  Upload: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("path", {
    d: "M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"
  }), /*#__PURE__*/React.createElement("polyline", {
    points: "17 8 12 3 7 8"
  }), /*#__PURE__*/React.createElement("line", {
    x1: "12",
    y1: "3",
    x2: "12",
    y2: "15"
  })),
  Grid: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("rect", {
    x: "3",
    y: "3",
    width: "7",
    height: "7"
  }), /*#__PURE__*/React.createElement("rect", {
    x: "14",
    y: "3",
    width: "7",
    height: "7"
  }), /*#__PURE__*/React.createElement("rect", {
    x: "3",
    y: "14",
    width: "7",
    height: "7"
  }), /*#__PURE__*/React.createElement("rect", {
    x: "14",
    y: "14",
    width: "7",
    height: "7"
  })),
  Wifi: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("path", {
    d: "M5 12.55a11 11 0 0 1 14.08 0"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M1.42 9a16 16 0 0 1 21.16 0"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M8.53 16.11a6 6 0 0 1 6.95 0"
  }), /*#__PURE__*/React.createElement("line", {
    x1: "12",
    y1: "20",
    x2: "12.01",
    y2: "20"
  })),
  Snowflake: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("line", {
    x1: "2",
    y1: "12",
    x2: "22",
    y2: "12"
  }), /*#__PURE__*/React.createElement("line", {
    x1: "12",
    y1: "2",
    x2: "12",
    y2: "22"
  }), /*#__PURE__*/React.createElement("path", {
    d: "m20 16-4-4 4-4"
  }), /*#__PURE__*/React.createElement("path", {
    d: "m4 8 4 4-4 4"
  }), /*#__PURE__*/React.createElement("path", {
    d: "m16 4-4 4-4-4"
  }), /*#__PURE__*/React.createElement("path", {
    d: "m8 20 4-4 4 4"
  })),
  Zap: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("polygon", {
    points: "13 2 3 14 12 14 11 22 21 10 12 10 13 2"
  })),
  Camera: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("path", {
    d: "M14.5 4h-5L7 7H4a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-3l-2.5-3Z"
  }), /*#__PURE__*/React.createElement("circle", {
    cx: "12",
    cy: "13",
    r: "3"
  })),
  Book: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("path", {
    d: "M4 19.5A2.5 2.5 0 0 1 6.5 17H20"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2Z"
  })),
  Shirt: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("path", {
    d: "M20.38 3.46 16 2a4 4 0 0 1-8 0L3.62 3.46a2 2 0 0 0-1.34 2.23l.58 3.47a1 1 0 0 0 .99.84H6v10c0 1.1.9 2 2 2h8a2 2 0 0 0 2-2V10h2.15a1 1 0 0 0 .99-.84l.58-3.47a2 2 0 0 0-1.34-2.23Z"
  })),
  Droplet: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("path", {
    d: "M12 2.69 5.64 9.05a9 9 0 1 0 12.72 0Z"
  })),
  Lock: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("rect", {
    x: "3",
    y: "11",
    width: "18",
    height: "11",
    rx: "2"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M7 11V7a5 5 0 0 1 10 0v4"
  })),
  Bike: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("circle", {
    cx: "5.5",
    cy: "17.5",
    r: "3.5"
  }), /*#__PURE__*/React.createElement("circle", {
    cx: "18.5",
    cy: "17.5",
    r: "3.5"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M15 6a1 1 0 1 0 0-2 1 1 0 0 0 0 2Zm-3 11.5V14l-3-3 4-3 2 3h2"
  })),
  Mountain: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("path", {
    d: "m8 3 4 8 5-5 5 15H2L8 3Z"
  })),
  Coffee: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("path", {
    d: "M17 8h1a4 4 0 1 1 0 8h-1"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M3 8h14v9a4 4 0 0 1-4 4H7a4 4 0 0 1-4-4V8Z"
  }), /*#__PURE__*/React.createElement("line", {
    x1: "6",
    y1: "2",
    x2: "6",
    y2: "4"
  }), /*#__PURE__*/React.createElement("line", {
    x1: "10",
    y1: "2",
    x2: "10",
    y2: "4"
  }), /*#__PURE__*/React.createElement("line", {
    x1: "14",
    y1: "2",
    x2: "14",
    y2: "4"
  })),
  Eye: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("path", {
    d: "M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"
  }), /*#__PURE__*/React.createElement("circle", {
    cx: "12",
    cy: "12",
    r: "3"
  })),
  Calendar: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("rect", {
    x: "3",
    y: "4",
    width: "18",
    height: "18",
    rx: "2",
    ry: "2"
  }), /*#__PURE__*/React.createElement("line", {
    x1: "16",
    y1: "2",
    x2: "16",
    y2: "6"
  }), /*#__PURE__*/React.createElement("line", {
    x1: "8",
    y1: "2",
    x2: "8",
    y2: "6"
  }), /*#__PURE__*/React.createElement("line", {
    x1: "3",
    y1: "10",
    x2: "21",
    y2: "10"
  })),
  Info: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("circle", {
    cx: "12",
    cy: "12",
    r: "10"
  }), /*#__PURE__*/React.createElement("line", {
    x1: "12",
    y1: "16",
    x2: "12",
    y2: "12"
  }), /*#__PURE__*/React.createElement("line", {
    x1: "12",
    y1: "8",
    x2: "12.01",
    y2: "8"
  })),
  Home: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("path", {
    d: "m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2Z"
  }), /*#__PURE__*/React.createElement("polyline", {
    points: "9 22 9 12 15 12 15 22"
  })),
  Bell: p => /*#__PURE__*/React.createElement(I, p, /*#__PURE__*/React.createElement("path", {
    d: "M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"
  }), /*#__PURE__*/React.createElement("path", {
    d: "M10.3 21a1.94 1.94 0 0 0 3.4 0"
  }))
};
window.Icons = Icons;
})(); } catch (e) { __ds_ns.__errors.push({ path: "src/icons.jsx", error: String((e && e.message) || e) }); }

// src/navbar.jsx
try { (() => {
// Top navigation bar
function Navbar({
  page,
  setPage,
  search,
  setSearch,
  division,
  setDivision
}) {
  const NAV = [{
    id: 'search',
    label: 'Search'
  }, {
    id: 'post',
    label: 'Post Hostel'
  }, {
    id: 'bookings',
    label: 'My Bookings'
  }];
  return /*#__PURE__*/React.createElement("header", {
    className: "nav"
  }, /*#__PURE__*/React.createElement("div", {
    className: "nav-inner"
  }, /*#__PURE__*/React.createElement("div", {
    className: "brand",
    onClick: () => setPage('search'),
    style: {
      cursor: 'pointer'
    }
  }, /*#__PURE__*/React.createElement("span", {
    className: "brand-mark"
  }, /*#__PURE__*/React.createElement(Icons.Home, {
    size: 16
  })), /*#__PURE__*/React.createElement("span", null, "FlatNest"), /*#__PURE__*/React.createElement("span", {
    className: "nest-badge"
  }, "NestStay")), /*#__PURE__*/React.createElement("nav", {
    className: "nav-links"
  }, NAV.map(n => /*#__PURE__*/React.createElement("button", {
    key: n.id,
    className: 'nav-link ' + (page === n.id || n.id === 'search' && page === 'detail' ? 'active' : ''),
    onClick: () => setPage(n.id)
  }, n.label))), /*#__PURE__*/React.createElement("div", {
    className: "nav-search"
  }, /*#__PURE__*/React.createElement(Icons.Search, {
    size: 15,
    style: {
      color: 'var(--text-3)'
    }
  }), /*#__PURE__*/React.createElement("input", {
    placeholder: "Search hostels, mess, location\u2026",
    value: search,
    onChange: e => setSearch(e.target.value)
  }), /*#__PURE__*/React.createElement("span", {
    className: "divider"
  }), /*#__PURE__*/React.createElement("select", {
    value: division,
    onChange: e => setDivision(e.target.value)
  }, /*#__PURE__*/React.createElement("option", {
    value: ""
  }, "All divisions"), DIVISIONS.map(d => /*#__PURE__*/React.createElement("option", {
    key: d,
    value: d
  }, d)))), /*#__PURE__*/React.createElement("div", {
    className: "nav-right"
  }, /*#__PURE__*/React.createElement(Button, {
    variant: "outline",
    size: "sm",
    onClick: () => setPage('post')
  }, /*#__PURE__*/React.createElement(Icons.Plus, {
    size: 14
  }), " Post a Hostel"), /*#__PURE__*/React.createElement("div", {
    className: "avatar",
    title: "Account"
  }, "RA"))));
}
window.Navbar = Navbar;
})(); } catch (e) { __ds_ns.__errors.push({ path: "src/navbar.jsx", error: String((e && e.message) || e) }); }

// src/post-page.jsx
try { (() => {
// Page 3 — Post a Hostel (4-step wizard)
// Globals: Icons, AMENITIES, DIVISIONS, DISTRICTS, UPAZILAS, HOSTEL_TYPES,
// Button, Checkbox, Radio, Toggle, Stepper, fmtBDT

function StepIndicator({
  step
}) {
  const STEPS = [{
    n: 1,
    label: 'Hostel info'
  }, {
    n: 2,
    label: 'Seat builder'
  }, {
    n: 3,
    label: 'Location'
  }, {
    n: 4,
    label: 'Amenities & photos'
  }];
  return /*#__PURE__*/React.createElement("div", {
    className: "step-ind"
  }, STEPS.map((s, i) => {
    const state = step === s.n ? 'active' : step > s.n ? 'done' : '';
    return /*#__PURE__*/React.createElement(React.Fragment, {
      key: s.n
    }, /*#__PURE__*/React.createElement("div", {
      className: 'step ' + state
    }, /*#__PURE__*/React.createElement("span", {
      className: "num"
    }, step > s.n ? /*#__PURE__*/React.createElement(Icons.Check, {
      size: 14,
      strokeWidth: 3
    }) : s.n), /*#__PURE__*/React.createElement("span", {
      className: "lbl"
    }, s.label)), i < STEPS.length - 1 ? /*#__PURE__*/React.createElement("span", {
      className: "line"
    }) : null);
  }));
}
function Step1({
  form,
  setForm
}) {
  const set = (k, v) => setForm({
    ...form,
    [k]: v
  });
  const TYPES = HOSTEL_TYPES.slice(1);
  return /*#__PURE__*/React.createElement("div", {
    className: "col gap-4"
  }, /*#__PURE__*/React.createElement("label", {
    className: "field"
  }, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Hostel name"), /*#__PURE__*/React.createElement("input", {
    className: "input",
    placeholder: "e.g. Asha Women's Hostel",
    value: form.name,
    onChange: e => set('name', e.target.value)
  })), /*#__PURE__*/React.createElement("label", {
    className: "field"
  }, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Hostel type"), /*#__PURE__*/React.createElement("div", {
    className: "chip-grid"
  }, TYPES.map(t => /*#__PURE__*/React.createElement("button", {
    key: t.id,
    className: 'chip ' + (form.type === t.id ? 'active' : ''),
    onClick: () => set('type', t.id)
  }, t.label)))), /*#__PURE__*/React.createElement("div", {
    className: "wiz-grid-2"
  }, /*#__PURE__*/React.createElement("label", {
    className: "field"
  }, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Total seats"), /*#__PURE__*/React.createElement("input", {
    type: "number",
    className: "input",
    placeholder: "20",
    value: form.totalSeats,
    onChange: e => set('totalSeats', e.target.value)
  })), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Gender policy"), /*#__PURE__*/React.createElement("div", {
    className: "row gap-4",
    style: {
      paddingTop: 6
    }
  }, [{
    id: 'male',
    label: 'Male'
  }, {
    id: 'female',
    label: 'Female'
  }, {
    id: 'mixed',
    label: 'Mixed'
  }].map(g => /*#__PURE__*/React.createElement(Radio, {
    key: g.id,
    name: "gp",
    label: g.label,
    checked: form.gender === g.id,
    onChange: () => set('gender', g.id)
  }))))), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Pricing unit"), /*#__PURE__*/React.createElement("div", {
    className: "segmented",
    style: {
      marginTop: 4
    }
  }, [{
    id: 'seat-month',
    label: 'Per seat / month'
  }, {
    id: 'room-month',
    label: 'Per room / month'
  }, {
    id: 'day',
    label: 'Per day'
  }].map(p => /*#__PURE__*/React.createElement("button", {
    key: p.id,
    className: form.priceUnit === p.id ? 'active' : '',
    onClick: () => set('priceUnit', p.id)
  }, p.label)))), /*#__PURE__*/React.createElement("div", {
    className: "wiz-grid-3"
  }, /*#__PURE__*/React.createElement("label", {
    className: "field"
  }, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Rent per unit (BDT)"), /*#__PURE__*/React.createElement("input", {
    type: "number",
    className: "input",
    placeholder: "4500",
    value: form.rent,
    onChange: e => set('rent', e.target.value)
  })), /*#__PURE__*/React.createElement("label", {
    className: "field"
  }, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Security deposit (BDT)"), /*#__PURE__*/React.createElement("input", {
    type: "number",
    className: "input",
    placeholder: "2000",
    value: form.deposit,
    onChange: e => set('deposit', e.target.value)
  })), /*#__PURE__*/React.createElement("label", {
    className: "field"
  }, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Advance amount (BDT)"), /*#__PURE__*/React.createElement("input", {
    type: "number",
    className: "input",
    placeholder: "2000",
    value: form.advance,
    onChange: e => set('advance', e.target.value)
  }))), /*#__PURE__*/React.createElement("div", {
    className: "row gap-4",
    style: {
      alignItems: 'flex-end'
    }
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    className: "row",
    style: {
      justifyContent: 'space-between'
    }
  }, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Meal included?")), /*#__PURE__*/React.createElement(Toggle, {
    checked: form.mealOn,
    onChange: v => set('mealOn', v),
    label: form.mealOn ? 'Yes' : 'No'
  })), form.mealOn ? /*#__PURE__*/React.createElement("label", {
    className: "field flex-1"
  }, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Meal price per month (BDT)"), /*#__PURE__*/React.createElement("input", {
    type: "number",
    className: "input",
    placeholder: "1500",
    value: form.mealPrice,
    onChange: e => set('mealPrice', e.target.value)
  })) : null, /*#__PURE__*/React.createElement("label", {
    className: "field flex-1"
  }, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Curfew time (optional)"), /*#__PURE__*/React.createElement("input", {
    type: "time",
    className: "input",
    value: form.curfew,
    onChange: e => set('curfew', e.target.value)
  }))), /*#__PURE__*/React.createElement("label", {
    className: "field"
  }, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Description"), /*#__PURE__*/React.createElement("textarea", {
    className: "textarea",
    placeholder: "Briefly describe the hostel, neighborhood, food, vibe\u2026",
    value: form.desc,
    onChange: e => set('desc', e.target.value)
  })));
}
function Step2({
  form,
  setForm
}) {
  const rooms = form.rooms;
  const totalSeats = rooms.reduce((s, r) => s + r.seats.length, 0);
  const vacant = rooms.reduce((s, r) => s + r.seats.filter(x => x.status === 'vacant').length, 0);
  const updateRoom = (idx, room) => {
    const next = rooms.slice();
    next[idx] = room;
    setForm({
      ...form,
      rooms: next
    });
  };
  const removeRoom = idx => {
    setForm({
      ...form,
      rooms: rooms.filter((_, i) => i !== idx)
    });
  };
  const addRoom = () => {
    setForm({
      ...form,
      rooms: [...rooms, {
        name: 'Room ' + (rooms.length + 1),
        seats: Array.from({
          length: 4
        }).map((_, i) => ({
          id: 'R' + (rooms.length + 1) + '-' + String.fromCharCode(65 + i),
          status: 'vacant'
        }))
      }]
    });
  };
  const setSeatCount = (rIdx, n) => {
    n = Math.max(1, Math.min(10, n));
    const room = rooms[rIdx];
    const current = room.seats;
    let next;
    if (n > current.length) {
      next = current.concat(Array.from({
        length: n - current.length
      }).map((_, i) => ({
        id: (room.name.replace(/[^A-Za-z0-9]/g, '') || 'R') + '-' + String.fromCharCode(65 + current.length + i),
        status: 'vacant'
      })));
    } else {
      next = current.slice(0, n);
    }
    updateRoom(rIdx, {
      ...room,
      seats: next
    });
  };
  return /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    className: "row",
    style: {
      justifyContent: 'space-between',
      marginBottom: 16
    }
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    style: {
      fontWeight: 600,
      fontSize: 15
    }
  }, "Build out your seat layout"), /*#__PURE__*/React.createElement("div", {
    className: "tiny muted"
  }, "Add rooms, set seat counts. Tap a seat to toggle Vacant/Taken.")), /*#__PURE__*/React.createElement(Button, {
    variant: "primary",
    size: "sm",
    onClick: addRoom
  }, /*#__PURE__*/React.createElement(Icons.Plus, {
    size: 14
  }), " Add room")), rooms.map((room, idx) => /*#__PURE__*/React.createElement("div", {
    className: "room-block",
    key: idx
  }, /*#__PURE__*/React.createElement("div", {
    className: "row gap-3",
    style: {
      alignItems: 'flex-end'
    }
  }, /*#__PURE__*/React.createElement("label", {
    className: "field flex-1"
  }, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Room name / number"), /*#__PURE__*/React.createElement("input", {
    className: "input",
    value: room.name,
    onChange: e => updateRoom(idx, {
      ...room,
      name: e.target.value
    })
  })), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Seats"), /*#__PURE__*/React.createElement(Stepper, {
    value: room.seats.length,
    onChange: n => setSeatCount(idx, n),
    min: 1,
    max: 10
  })), /*#__PURE__*/React.createElement(Button, {
    variant: "ghost",
    size: "sm",
    onClick: () => removeRoom(idx),
    "aria-label": "remove"
  }, /*#__PURE__*/React.createElement(Icons.X, {
    size: 14
  }), " Remove")), /*#__PURE__*/React.createElement("div", {
    className: "seats-mini"
  }, room.seats.map((seat, si) => /*#__PURE__*/React.createElement("div", {
    key: si,
    className: 's ' + (seat.status === 'taken' ? 'taken' : ''),
    onClick: () => {
      const next = {
        ...room,
        seats: room.seats.slice()
      };
      next.seats[si] = {
        ...seat,
        status: seat.status === 'vacant' ? 'taken' : 'vacant'
      };
      updateRoom(idx, next);
    },
    title: "Click to toggle"
  }, /*#__PURE__*/React.createElement("input", {
    style: {
      width: 42,
      border: 'none',
      background: 'transparent',
      fontSize: 11,
      fontWeight: 500,
      textAlign: 'center',
      padding: 0,
      outline: 'none'
    },
    value: seat.id,
    onChange: e => {
      const next = {
        ...room,
        seats: room.seats.slice()
      };
      next.seats[si] = {
        ...seat,
        id: e.target.value
      };
      updateRoom(idx, next);
    },
    onClick: e => e.stopPropagation()
  })))), /*#__PURE__*/React.createElement("div", {
    className: "tiny muted",
    style: {
      marginTop: 8
    }
  }, "Click a seat box to toggle Vacant \u2194 Taken"))), /*#__PURE__*/React.createElement("div", {
    className: "note",
    style: {
      marginTop: 8
    }
  }, /*#__PURE__*/React.createElement(Icons.Info, {
    size: 14
  }), "Total: ", /*#__PURE__*/React.createElement("strong", null, totalSeats, " seats"), " \xB7 ", /*#__PURE__*/React.createElement("strong", null, vacant, " vacant")));
}
function Step3({
  form,
  setForm
}) {
  const set = (k, v) => setForm({
    ...form,
    [k]: v
  });
  return /*#__PURE__*/React.createElement("div", {
    className: "col gap-4"
  }, /*#__PURE__*/React.createElement("div", {
    className: "wiz-grid-2"
  }, /*#__PURE__*/React.createElement("label", {
    className: "field"
  }, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Division"), /*#__PURE__*/React.createElement("select", {
    className: "select",
    value: form.division,
    onChange: e => {
      set('division', e.target.value);
      set('district', '');
      set('upazila', '');
    }
  }, /*#__PURE__*/React.createElement("option", {
    value: ""
  }, "Select\u2026"), DIVISIONS.map(d => /*#__PURE__*/React.createElement("option", {
    key: d,
    value: d
  }, d)))), /*#__PURE__*/React.createElement("label", {
    className: "field"
  }, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "District"), /*#__PURE__*/React.createElement("select", {
    className: "select",
    value: form.district,
    onChange: e => {
      set('district', e.target.value);
      set('upazila', '');
    },
    disabled: !form.division
  }, /*#__PURE__*/React.createElement("option", {
    value: ""
  }, "Select\u2026"), (DISTRICTS[form.division] || []).map(d => /*#__PURE__*/React.createElement("option", {
    key: d,
    value: d
  }, d)))), /*#__PURE__*/React.createElement("label", {
    className: "field"
  }, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Upazila / Thana"), /*#__PURE__*/React.createElement("select", {
    className: "select",
    value: form.upazila,
    onChange: e => set('upazila', e.target.value),
    disabled: !form.district
  }, /*#__PURE__*/React.createElement("option", {
    value: ""
  }, "Select\u2026"), (UPAZILAS[form.division] || []).map(d => /*#__PURE__*/React.createElement("option", {
    key: d,
    value: d
  }, d)))), /*#__PURE__*/React.createElement("label", {
    className: "field"
  }, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Union (optional)"), /*#__PURE__*/React.createElement("input", {
    className: "input",
    placeholder: "e.g. Ward 14",
    value: form.union,
    onChange: e => set('union', e.target.value)
  }))), /*#__PURE__*/React.createElement("div", {
    className: "wiz-grid-2"
  }, /*#__PURE__*/React.createElement("label", {
    className: "field"
  }, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Road / House name"), /*#__PURE__*/React.createElement("input", {
    className: "input",
    placeholder: "e.g. Road 7, House 12",
    value: form.road,
    onChange: e => set('road', e.target.value)
  })), /*#__PURE__*/React.createElement("label", {
    className: "field"
  }, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Block / Section"), /*#__PURE__*/React.createElement("input", {
    className: "input",
    placeholder: "e.g. Section 11, Block A",
    value: form.block,
    onChange: e => set('block', e.target.value)
  }))), /*#__PURE__*/React.createElement("label", {
    className: "field"
  }, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Nearby landmark"), /*#__PURE__*/React.createElement("input", {
    className: "input",
    placeholder: "e.g. 500m from BUET main gate",
    value: form.landmark,
    onChange: e => set('landmark', e.target.value)
  })), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Pin on map"), /*#__PURE__*/React.createElement("div", {
    style: {
      background: '#EEF1F5',
      backgroundImage: 'repeating-linear-gradient(0deg, transparent, transparent 23px, rgba(0,0,0,0.04) 24px), repeating-linear-gradient(90deg, transparent, transparent 23px, rgba(0,0,0,0.04) 24px)',
      borderRadius: 'var(--r-card)',
      height: 200,
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      flexDirection: 'column',
      gap: 6,
      color: 'var(--text-2)',
      cursor: 'pointer',
      border: '1px dashed var(--border)'
    }
  }, /*#__PURE__*/React.createElement(Icons.MapPin, {
    size: 32,
    style: {
      color: 'var(--accent)'
    }
  }), /*#__PURE__*/React.createElement("span", {
    className: "tiny"
  }, "Tap to pick on map"))));
}
function Step4({
  form,
  setForm
}) {
  const set = (k, v) => setForm({
    ...form,
    [k]: v
  });
  const toggleAm = id => {
    set('amenities', {
      ...form.amenities,
      [id]: !form.amenities[id]
    });
  };
  const updateRule = (i, v) => {
    const next = form.rules.slice();
    next[i] = v;
    set('rules', next);
  };
  const addRule = () => set('rules', [...form.rules, '']);
  const removeRule = i => set('rules', form.rules.filter((_, x) => x !== i));
  return /*#__PURE__*/React.createElement("div", {
    className: "col gap-4"
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Amenities"), /*#__PURE__*/React.createElement("div", {
    className: "chip-grid",
    style: {
      marginTop: 6
    }
  }, AMENITIES.map(a => {
    const Ico = Icons[a.icon];
    return /*#__PURE__*/React.createElement("button", {
      key: a.id,
      className: 'chip ' + (form.amenities[a.id] ? 'active' : ''),
      onClick: () => toggleAm(a.id)
    }, Ico ? /*#__PURE__*/React.createElement(Ico, {
      size: 12
    }) : null, a.label);
  }))), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    className: "row",
    style: {
      justifyContent: 'space-between',
      marginBottom: 6
    }
  }, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Hostel rules"), /*#__PURE__*/React.createElement(Button, {
    variant: "ghost",
    size: "sm",
    onClick: addRule
  }, /*#__PURE__*/React.createElement(Icons.Plus, {
    size: 12
  }), " Add rule")), /*#__PURE__*/React.createElement("div", {
    className: "col gap-2"
  }, form.rules.map((r, i) => /*#__PURE__*/React.createElement("div", {
    className: "row gap-2",
    key: i
  }, /*#__PURE__*/React.createElement("span", {
    className: "muted tiny",
    style: {
      width: 22,
      textAlign: 'right'
    }
  }, i + 1, "."), /*#__PURE__*/React.createElement("input", {
    className: "input flex-1",
    value: r,
    onChange: e => updateRule(i, e.target.value)
  }), /*#__PURE__*/React.createElement(Button, {
    variant: "ghost",
    size: "sm",
    onClick: () => removeRule(i)
  }, /*#__PURE__*/React.createElement(Icons.X, {
    size: 14
  }))))), /*#__PURE__*/React.createElement("div", {
    className: "tiny muted",
    style: {
      marginTop: 6
    }
  }, "Suggestions: curfew time, visitor policy, cooking, notice period")), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("span", {
    className: "lbl"
  }, "Photos (upload at least 3)"), /*#__PURE__*/React.createElement("div", {
    className: "wiz-grid-3",
    style: {
      marginTop: 6
    }
  }, ['Common Area', 'Room Photo', 'Exterior'].map(p => /*#__PURE__*/React.createElement("div", {
    className: "photo-zone",
    key: p
  }, /*#__PURE__*/React.createElement(Icons.Upload, {
    size: 22
  }), /*#__PURE__*/React.createElement("div", {
    className: "ph-title"
  }, p), /*#__PURE__*/React.createElement("div", {
    className: "tiny",
    style: {
      marginTop: 2
    }
  }, "PNG, JPG up to 5MB"))))), /*#__PURE__*/React.createElement("div", {
    className: "note"
  }, /*#__PURE__*/React.createElement(Icons.Info, {
    size: 14
  }), "Your listing will be reviewed within 24 hours. You'll receive a confirmation SMS when approved."));
}
function PostPage({
  onDone
}) {
  const [step, setStep] = useState(1);
  const [submitted, setSubmitted] = useState(false);
  const [form, setForm] = useState({
    name: '',
    type: 'student',
    totalSeats: '18',
    gender: 'female',
    priceUnit: 'seat-month',
    rent: '4500',
    deposit: '2000',
    advance: '2000',
    mealOn: true,
    mealPrice: '1500',
    curfew: '22:00',
    desc: '',
    rooms: [{
      name: 'Room 1',
      seats: [{
        id: 'R1-A',
        status: 'vacant'
      }, {
        id: 'R1-B',
        status: 'vacant'
      }, {
        id: 'R1-C',
        status: 'taken'
      }, {
        id: 'R1-D',
        status: 'vacant'
      }]
    }, {
      name: 'Room 2',
      seats: [{
        id: 'R2-A',
        status: 'vacant'
      }, {
        id: 'R2-B',
        status: 'taken'
      }, {
        id: 'R2-C',
        status: 'vacant'
      }, {
        id: 'R2-D',
        status: 'taken'
      }]
    }],
    division: 'Dhaka',
    district: 'Dhaka',
    upazila: 'Mirpur',
    union: '',
    road: '',
    block: '',
    landmark: '',
    amenities: {
      wifi: true,
      meal: true,
      cctv: true,
      study: true,
      bath: true,
      guard: true
    },
    rules: ['Curfew: 10:00 PM every night', 'No male visitors above floor 1', 'No cooking in rooms', 'Advance: 1 month seat rent']
  });
  if (submitted) {
    return /*#__PURE__*/React.createElement("div", {
      className: "page"
    }, /*#__PURE__*/React.createElement("div", {
      className: "card",
      style: {
        maxWidth: 540,
        margin: '60px auto',
        padding: 40,
        textAlign: 'center'
      }
    }, /*#__PURE__*/React.createElement("div", {
      style: {
        width: 72,
        height: 72,
        borderRadius: 99,
        margin: '0 auto 16px',
        background: 'var(--success-bg)',
        color: 'var(--success)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center'
      }
    }, /*#__PURE__*/React.createElement(Icons.Check, {
      size: 36,
      strokeWidth: 3
    })), /*#__PURE__*/React.createElement("h2", {
      style: {
        margin: '0 0 6px'
      }
    }, "Listing submitted!"), /*#__PURE__*/React.createElement("p", {
      className: "muted",
      style: {
        margin: '0 0 22px'
      }
    }, "We'll review ", /*#__PURE__*/React.createElement("strong", null, form.name || 'your hostel'), " within 24 hours and send you a confirmation SMS."), /*#__PURE__*/React.createElement("div", {
      className: "row gap-2",
      style: {
        justifyContent: 'center'
      }
    }, /*#__PURE__*/React.createElement(Button, {
      variant: "primary",
      onClick: onDone
    }, "Go to listings"), /*#__PURE__*/React.createElement(Button, {
      variant: "outline",
      onClick: () => {
        setSubmitted(false);
        setStep(1);
      }
    }, "Post another"))));
  }
  return /*#__PURE__*/React.createElement("div", {
    className: "page"
  }, /*#__PURE__*/React.createElement("div", {
    className: "wizard"
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      marginBottom: 18
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 22,
      fontWeight: 700
    }
  }, "Post a hostel"), /*#__PURE__*/React.createElement("div", {
    className: "muted tiny"
  }, "Reach thousands of renters across Bangladesh. Free to list.")), /*#__PURE__*/React.createElement(StepIndicator, {
    step: step
  }), /*#__PURE__*/React.createElement("div", {
    className: "card wiz-card"
  }, step === 1 && /*#__PURE__*/React.createElement(Step1, {
    form: form,
    setForm: setForm
  }), step === 2 && /*#__PURE__*/React.createElement(Step2, {
    form: form,
    setForm: setForm
  }), step === 3 && /*#__PURE__*/React.createElement(Step3, {
    form: form,
    setForm: setForm
  }), step === 4 && /*#__PURE__*/React.createElement(Step4, {
    form: form,
    setForm: setForm
  }), /*#__PURE__*/React.createElement("div", {
    className: "wiz-actions"
  }, /*#__PURE__*/React.createElement(Button, {
    variant: "ghost",
    onClick: () => setStep(Math.max(1, step - 1)),
    disabled: step === 1
  }, /*#__PURE__*/React.createElement(Icons.ChevronLeft, {
    size: 14
  }), " Back"), step < 4 ? /*#__PURE__*/React.createElement(Button, {
    variant: "primary",
    onClick: () => setStep(step + 1)
  }, "Next ", /*#__PURE__*/React.createElement(Icons.ChevronRight, {
    size: 14
  })) : /*#__PURE__*/React.createElement(Button, {
    variant: "primary",
    onClick: () => setSubmitted(true)
  }, "Submit for Review ", /*#__PURE__*/React.createElement(Icons.Check, {
    size: 14
  }))))));
}
window.PostPage = PostPage;
})(); } catch (e) { __ds_ns.__errors.push({ path: "src/post-page.jsx", error: String((e && e.message) || e) }); }

// src/search-page.jsx
try { (() => {
// Page 1 — Hostel Search & Listing
// Globals: Icons, HOSTELS, HOSTEL_TYPES, TYPE_PILL_COLOR, AMENITIES, DIVISIONS,
// DISTRICTS, UPAZILAS, fmtBDT, Button, Checkbox, Radio, Toggle, Stepper, RangeSlider, StarRow

function HostelCard({
  h,
  onOpen,
  saved,
  onToggleSave
}) {
  const vacPct = h.seats.vacant / h.seats.total * 100;
  return /*#__PURE__*/React.createElement("article", {
    className: "hostel-card"
  }, /*#__PURE__*/React.createElement("div", {
    className: "hostel-photo",
    style: {
      background: h.grad
    }
  }, /*#__PURE__*/React.createElement("div", {
    className: "ph-overlay"
  }, h.verified ? /*#__PURE__*/React.createElement("span", {
    className: "badge badge-verified"
  }, /*#__PURE__*/React.createElement(Icons.Shield, {
    size: 11
  }), " VERIFIED") : /*#__PURE__*/React.createElement("span", null), /*#__PURE__*/React.createElement("span", {
    className: 'pill ' + TYPE_PILL_COLOR[h.type]
  }, h.typeLabel)), /*#__PURE__*/React.createElement("div", {
    className: "ph-icon"
  }, /*#__PURE__*/React.createElement(Icons.Building2, {
    size: 48,
    strokeWidth: 1.4
  }))), /*#__PURE__*/React.createElement("div", {
    className: "hostel-body"
  }, /*#__PURE__*/React.createElement("h3", {
    className: "hostel-title"
  }, h.name), /*#__PURE__*/React.createElement("div", {
    className: "hostel-loc"
  }, /*#__PURE__*/React.createElement(Icons.MapPin, {
    size: 12
  }), /*#__PURE__*/React.createElement("span", null, h.location, h.landmark ? ' · ' + h.landmark : '')), /*#__PURE__*/React.createElement("div", {
    className: "row gap-3",
    style: {
      alignItems: 'center'
    }
  }, /*#__PURE__*/React.createElement(StarRow, {
    value: h.rating,
    reviews: h.reviews
  })), /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    className: "row",
    style: {
      justifyContent: 'space-between',
      fontSize: 12,
      color: 'var(--text-2)',
      marginBottom: 4
    }
  }, /*#__PURE__*/React.createElement("span", null, h.seats.vacant, " / ", h.seats.total, " seats vacant"), /*#__PURE__*/React.createElement("span", null, Math.round(vacPct), "%")), /*#__PURE__*/React.createElement("div", {
    className: "vac-bar"
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      width: vacPct + '%'
    }
  }))), /*#__PURE__*/React.createElement("div", {
    className: "tags-row"
  }, /*#__PURE__*/React.createElement("span", {
    className: 'pill ' + (h.gender === 'female' ? 'pill-pink' : h.gender === 'male' ? 'pill-blue' : 'pill-teal')
  }, h.gender === 'female' ? '♀ Female only' : h.gender === 'male' ? '♂ Male only' : '⚥ Mixed'), h.meal.included ? /*#__PURE__*/React.createElement("span", {
    className: "pill pill-green"
  }, /*#__PURE__*/React.createElement(Icons.Utensils, {
    size: 11
  }), " Meal: ", fmtBDT(h.meal.price), "/mo") : /*#__PURE__*/React.createElement("span", {
    className: "pill"
  }, "No meal"), h.curfew ? /*#__PURE__*/React.createElement("span", {
    className: "pill pill-amber"
  }, /*#__PURE__*/React.createElement(Icons.Clock, {
    size: 11
  }), " Curfew ", h.curfew) : null), /*#__PURE__*/React.createElement("div", {
    className: "price-row"
  }, /*#__PURE__*/React.createElement("span", {
    className: "price"
  }, fmtBDT(h.price)), /*#__PURE__*/React.createElement("span", {
    className: "unit"
  }, "/ ", h.priceUnit)), /*#__PURE__*/React.createElement("div", {
    className: "tiny dim"
  }, "Advance: ", fmtBDT(h.advance))), /*#__PURE__*/React.createElement("div", {
    className: "hostel-footer"
  }, /*#__PURE__*/React.createElement(Button, {
    variant: "outline",
    className: saved ? 'heart-active' : '',
    onClick: onToggleSave
  }, saved ? /*#__PURE__*/React.createElement(Icons.HeartFill, {
    size: 14
  }) : /*#__PURE__*/React.createElement(Icons.Heart, {
    size: 14
  }), saved ? 'Saved' : 'Save'), /*#__PURE__*/React.createElement(Button, {
    variant: "primary",
    onClick: onOpen
  }, "View Details ", /*#__PURE__*/React.createElement(Icons.ChevronRight, {
    size: 14
  }))));
}
function SearchPage({
  onOpen,
  saved,
  toggleSave
}) {
  const [quickType, setQuickType] = useState('all');
  const [priceRange, setPriceRange] = useState([3000, 8000]);
  const [typesChecked, setTypesChecked] = useState({});
  const [gender, setGender] = useState('any');
  const [division, setDivision] = useState('Dhaka');
  const [district, setDistrict] = useState('');
  const [upazila, setUpazila] = useState('');
  const [amen, setAmen] = useState({
    wifi: true
  });
  const [minVac, setMinVac] = useState(1);
  const [verifiedOnly, setVerifiedOnly] = useState(false);
  const [sidebarOpen, setSidebarOpen] = useState(true);
  const [heroLocation, setHeroLocation] = useState('Dhaka');
  const [heroType, setHeroType] = useState('all');
  const filtered = useMemo(() => {
    return HOSTELS.filter(h => {
      if (quickType !== 'all' && h.type !== quickType) return false;
      if (verifiedOnly && !h.verified) return false;
      if (gender !== 'any' && h.gender !== gender && h.gender !== 'mixed') return false;
      const tChecked = Object.keys(typesChecked).filter(k => typesChecked[k]);
      if (tChecked.length && !tChecked.includes(h.type)) return false;
      if (h.seats.vacant < minVac) return false;
      // price filter only applies to per-month entries
      if (h.priceUnit.includes('month')) {
        if (h.price < priceRange[0] || h.price > priceRange[1]) return false;
      }
      return true;
    });
  }, [quickType, typesChecked, gender, verifiedOnly, priceRange, minVac]);
  const resetFilters = () => {
    setPriceRange([3000, 8000]);
    setTypesChecked({});
    setGender('any');
    setDistrict('');
    setUpazila('');
    setAmen({});
    setMinVac(1);
    setVerifiedOnly(false);
    setQuickType('all');
  };
  return /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement("section", {
    className: "hero"
  }, /*#__PURE__*/React.createElement("div", {
    className: "hero-inner"
  }, /*#__PURE__*/React.createElement("h1", null, "Find your perfect stay in Bangladesh"), /*#__PURE__*/React.createElement("p", null, "Hostels, messes & shared rooms \u2014 verified & affordable"), /*#__PURE__*/React.createElement("div", {
    className: "hero-search"
  }, /*#__PURE__*/React.createElement("div", {
    className: "field-cell"
  }, /*#__PURE__*/React.createElement("label", null, "Location"), /*#__PURE__*/React.createElement("select", {
    value: heroLocation,
    onChange: e => setHeroLocation(e.target.value)
  }, DIVISIONS.map(d => /*#__PURE__*/React.createElement("option", {
    key: d,
    value: d
  }, d)))), /*#__PURE__*/React.createElement("div", {
    className: "field-cell"
  }, /*#__PURE__*/React.createElement("label", null, "Hostel type"), /*#__PURE__*/React.createElement("select", {
    value: heroType,
    onChange: e => {
      setHeroType(e.target.value);
      setQuickType(e.target.value);
    }
  }, HOSTEL_TYPES.map(t => /*#__PURE__*/React.createElement("option", {
    key: t.id,
    value: t.id
  }, t.label)))), /*#__PURE__*/React.createElement(Button, {
    variant: "primary",
    size: "lg",
    style: {
      margin: 4
    }
  }, /*#__PURE__*/React.createElement(Icons.Search, {
    size: 16
  }), " Search")), /*#__PURE__*/React.createElement("div", {
    className: "hero-quick"
  }, HOSTEL_TYPES.map(t => /*#__PURE__*/React.createElement("button", {
    key: t.id,
    className: 'qpill ' + (quickType === t.id ? 'active' : ''),
    onClick: () => setQuickType(t.id)
  }, t.label))))), /*#__PURE__*/React.createElement("div", {
    className: "page"
  }, /*#__PURE__*/React.createElement("div", {
    className: "row gap-3",
    style: {
      justifyContent: 'space-between',
      marginBottom: 18
    }
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 20,
      fontWeight: 700
    }
  }, filtered.length, " stays found"), /*#__PURE__*/React.createElement("div", {
    className: "muted tiny"
  }, "in ", heroLocation, " \xB7 ", quickType === 'all' ? 'All types' : HOSTEL_TYPES.find(t => t.id === quickType)?.label)), /*#__PURE__*/React.createElement("div", {
    className: "row gap-2"
  }, /*#__PURE__*/React.createElement(Button, {
    variant: "ghost",
    size: "sm",
    className: "filters-toggle",
    onClick: () => setSidebarOpen(!sidebarOpen)
  }, /*#__PURE__*/React.createElement(Icons.Filter, {
    size: 14
  }), " Filters"), /*#__PURE__*/React.createElement("select", {
    className: "select",
    style: {
      width: 'auto'
    }
  }, /*#__PURE__*/React.createElement("option", null, "Sort: Recommended"), /*#__PURE__*/React.createElement("option", null, "Price: Low to High"), /*#__PURE__*/React.createElement("option", null, "Price: High to Low"), /*#__PURE__*/React.createElement("option", null, "Most vacancies"), /*#__PURE__*/React.createElement("option", null, "Highest rated")))), /*#__PURE__*/React.createElement("div", {
    className: "split"
  }, /*#__PURE__*/React.createElement("aside", {
    className: 'sidebar ' + (sidebarOpen ? '' : 'collapsed')
  }, /*#__PURE__*/React.createElement("div", {
    className: "sb-section"
  }, /*#__PURE__*/React.createElement("h4", {
    className: "sb-title"
  }, "Price per seat/month"), /*#__PURE__*/React.createElement(RangeSlider, {
    min: 2000,
    max: 20000,
    step: 100,
    value: priceRange,
    onChange: setPriceRange
  }), /*#__PURE__*/React.createElement("div", {
    className: "tiny muted",
    style: {
      marginTop: 4
    }
  }, "Selected: ", fmtBDT(priceRange[0]), " \u2013 ", fmtBDT(priceRange[1]))), /*#__PURE__*/React.createElement("div", {
    className: "sb-section"
  }, /*#__PURE__*/React.createElement("h4", {
    className: "sb-title"
  }, "Hostel type"), /*#__PURE__*/React.createElement("div", {
    className: "col gap-2"
  }, HOSTEL_TYPES.slice(1).map(t => /*#__PURE__*/React.createElement(Checkbox, {
    key: t.id,
    label: t.label,
    checked: !!typesChecked[t.id],
    onChange: v => setTypesChecked({
      ...typesChecked,
      [t.id]: v
    })
  })))), /*#__PURE__*/React.createElement("div", {
    className: "sb-section"
  }, /*#__PURE__*/React.createElement("h4", {
    className: "sb-title"
  }, "Gender policy"), /*#__PURE__*/React.createElement("div", {
    className: "col gap-2"
  }, [{
    id: 'any',
    label: 'Any'
  }, {
    id: 'male',
    label: 'Male only'
  }, {
    id: 'female',
    label: 'Female only'
  }, {
    id: 'mixed',
    label: 'Mixed'
  }].map(g => /*#__PURE__*/React.createElement(Radio, {
    key: g.id,
    name: "gender",
    label: g.label,
    checked: gender === g.id,
    onChange: () => setGender(g.id)
  })))), /*#__PURE__*/React.createElement("div", {
    className: "sb-section"
  }, /*#__PURE__*/React.createElement("h4", {
    className: "sb-title"
  }, "Location"), /*#__PURE__*/React.createElement("div", {
    className: "col gap-2"
  }, /*#__PURE__*/React.createElement("select", {
    className: "select",
    value: division,
    onChange: e => {
      setDivision(e.target.value);
      setDistrict('');
      setUpazila('');
    }
  }, /*#__PURE__*/React.createElement("option", {
    value: ""
  }, "Division"), DIVISIONS.map(d => /*#__PURE__*/React.createElement("option", {
    key: d,
    value: d
  }, d))), /*#__PURE__*/React.createElement("select", {
    className: "select",
    value: district,
    onChange: e => {
      setDistrict(e.target.value);
      setUpazila('');
    },
    disabled: !division
  }, /*#__PURE__*/React.createElement("option", {
    value: ""
  }, "District"), (DISTRICTS[division] || []).map(d => /*#__PURE__*/React.createElement("option", {
    key: d,
    value: d
  }, d))), /*#__PURE__*/React.createElement("select", {
    className: "select",
    value: upazila,
    onChange: e => setUpazila(e.target.value),
    disabled: !district
  }, /*#__PURE__*/React.createElement("option", {
    value: ""
  }, "Upazila"), (UPAZILAS[division] || []).map(u => /*#__PURE__*/React.createElement("option", {
    key: u,
    value: u
  }, u))))), /*#__PURE__*/React.createElement("div", {
    className: "sb-section"
  }, /*#__PURE__*/React.createElement("h4", {
    className: "sb-title"
  }, "Amenities"), /*#__PURE__*/React.createElement("div", {
    className: "chip-grid"
  }, AMENITIES.map(a => /*#__PURE__*/React.createElement("button", {
    key: a.id,
    className: 'chip ' + (amen[a.id] ? 'active' : ''),
    onClick: () => setAmen({
      ...amen,
      [a.id]: !amen[a.id]
    })
  }, Icons[a.icon] ? React.createElement(Icons[a.icon], {
    size: 12
  }) : null, a.label)))), /*#__PURE__*/React.createElement("div", {
    className: "sb-section"
  }, /*#__PURE__*/React.createElement("h4", {
    className: "sb-title"
  }, "Vacancies"), /*#__PURE__*/React.createElement("div", {
    className: "row gap-2",
    style: {
      alignItems: 'center'
    }
  }, /*#__PURE__*/React.createElement("span", {
    className: "tiny muted"
  }, "At least"), /*#__PURE__*/React.createElement(Stepper, {
    value: minVac,
    onChange: setMinVac,
    min: 0,
    max: 50
  }), /*#__PURE__*/React.createElement("span", {
    className: "tiny muted"
  }, "seat vacant"))), /*#__PURE__*/React.createElement("div", {
    className: "sb-section"
  }, /*#__PURE__*/React.createElement("div", {
    className: "row",
    style: {
      justifyContent: 'space-between'
    }
  }, /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    style: {
      fontSize: 13,
      fontWeight: 600
    }
  }, "Verified only"), /*#__PURE__*/React.createElement("div", {
    className: "tiny muted"
  }, "FlatNest-verified listings")), /*#__PURE__*/React.createElement(Toggle, {
    checked: verifiedOnly,
    onChange: setVerifiedOnly
  }))), /*#__PURE__*/React.createElement("div", {
    className: "sb-actions"
  }, /*#__PURE__*/React.createElement(Button, {
    variant: "ghost",
    size: "sm",
    block: true,
    onClick: resetFilters
  }, "Reset filters"), /*#__PURE__*/React.createElement(Button, {
    variant: "primary",
    size: "sm",
    block: true
  }, "Show results"))), /*#__PURE__*/React.createElement("section", null, /*#__PURE__*/React.createElement("div", {
    className: "grid-cards"
  }, filtered.map(h => /*#__PURE__*/React.createElement(HostelCard, {
    key: h.id,
    h: h,
    onOpen: () => onOpen(h.id),
    saved: !!saved[h.id],
    onToggleSave: () => toggleSave(h.id)
  }))), filtered.length === 0 ? /*#__PURE__*/React.createElement("div", {
    className: "card",
    style: {
      padding: 32,
      textAlign: 'center',
      color: 'var(--text-2)'
    }
  }, /*#__PURE__*/React.createElement(Icons.Search, {
    size: 28,
    style: {
      color: 'var(--text-3)'
    }
  }), /*#__PURE__*/React.createElement("div", {
    style: {
      marginTop: 10,
      fontWeight: 600,
      color: 'var(--text-1)'
    }
  }, "No matches"), /*#__PURE__*/React.createElement("div", {
    className: "tiny"
  }, "Try widening your filters or resetting.")) : null))));
}
window.SearchPage = SearchPage;
})(); } catch (e) { __ds_ns.__errors.push({ path: "src/search-page.jsx", error: String((e && e.message) || e) }); }

// src/ui.jsx
try { (() => {
function _extends() { return _extends = Object.assign ? Object.assign.bind() : function (n) { for (var e = 1; e < arguments.length; e++) { var t = arguments[e]; for (var r in t) ({}).hasOwnProperty.call(t, r) && (n[r] = t[r]); } return n; }, _extends.apply(null, arguments); }
// Shared small UI primitives. Uses globals: Icons.
const {
  useState,
  useEffect,
  useRef,
  useMemo,
  useCallback
} = React;
function Button({
  variant = 'primary',
  size,
  block,
  icon,
  iconRight,
  children,
  className = '',
  ...props
}) {
  const cls = ['btn', 'btn-' + variant, size === 'sm' ? 'btn-sm' : size === 'lg' ? 'btn-lg' : '', block ? 'btn-block' : '', className].filter(Boolean).join(' ');
  return /*#__PURE__*/React.createElement("button", _extends({
    className: cls
  }, props), icon, children, iconRight);
}
function Checkbox({
  checked,
  onChange,
  label
}) {
  return /*#__PURE__*/React.createElement("label", {
    className: "check"
  }, /*#__PURE__*/React.createElement("input", {
    type: "checkbox",
    checked: checked,
    onChange: e => onChange?.(e.target.checked)
  }), /*#__PURE__*/React.createElement("span", {
    className: "check-box"
  }, /*#__PURE__*/React.createElement(Icons.Check, {
    size: 12,
    strokeWidth: 3
  })), /*#__PURE__*/React.createElement("span", null, label));
}
function Radio({
  checked,
  onChange,
  label,
  name
}) {
  return /*#__PURE__*/React.createElement("label", {
    className: "check"
  }, /*#__PURE__*/React.createElement("input", {
    type: "radio",
    name: name,
    checked: checked,
    onChange: () => onChange?.()
  }), /*#__PURE__*/React.createElement("span", {
    className: "radio-box"
  }), /*#__PURE__*/React.createElement("span", null, label));
}
function Toggle({
  checked,
  onChange,
  label
}) {
  return /*#__PURE__*/React.createElement("label", {
    className: "toggle"
  }, /*#__PURE__*/React.createElement("input", {
    type: "checkbox",
    checked: checked,
    onChange: e => onChange?.(e.target.checked)
  }), /*#__PURE__*/React.createElement("span", {
    className: "toggle-track"
  }), label ? /*#__PURE__*/React.createElement("span", null, label) : null);
}
function Stepper({
  value,
  onChange,
  min = 0,
  max = 99
}) {
  return /*#__PURE__*/React.createElement("div", {
    className: "stepper"
  }, /*#__PURE__*/React.createElement("button", {
    onClick: () => onChange?.(Math.max(min, value - 1)),
    "aria-label": "decrease"
  }, /*#__PURE__*/React.createElement(Icons.Minus, {
    size: 14
  })), /*#__PURE__*/React.createElement("span", {
    className: "val"
  }, value), /*#__PURE__*/React.createElement("button", {
    onClick: () => onChange?.(Math.min(max, value + 1)),
    "aria-label": "increase"
  }, /*#__PURE__*/React.createElement(Icons.Plus, {
    size: 14
  })));
}

// Dual-handle range slider
function RangeSlider({
  min = 0,
  max = 100,
  step = 1,
  value,
  onChange
}) {
  const [lo, hi] = value;
  const pctLo = (lo - min) / (max - min) * 100;
  const pctHi = (hi - min) / (max - min) * 100;
  return /*#__PURE__*/React.createElement("div", null, /*#__PURE__*/React.createElement("div", {
    className: "range-wrap"
  }, /*#__PURE__*/React.createElement("div", {
    className: "range-track"
  }), /*#__PURE__*/React.createElement("div", {
    className: "range-fill",
    style: {
      left: pctLo + '%',
      right: 100 - pctHi + '%'
    }
  }), /*#__PURE__*/React.createElement("input", {
    type: "range",
    min: min,
    max: max,
    step: step,
    value: lo,
    onChange: e => onChange?.([Math.min(+e.target.value, hi - step), hi])
  }), /*#__PURE__*/React.createElement("input", {
    type: "range",
    min: min,
    max: max,
    step: step,
    value: hi,
    onChange: e => onChange?.([lo, Math.max(+e.target.value, lo + step)])
  })), /*#__PURE__*/React.createElement("div", {
    className: "range-vals"
  }, /*#__PURE__*/React.createElement("span", null, fmtBDT(lo)), /*#__PURE__*/React.createElement("span", null, fmtBDT(hi))));
}
function StarRow({
  value,
  size = 14,
  showVal = true,
  reviews
}) {
  return /*#__PURE__*/React.createElement("span", {
    className: "rating"
  }, /*#__PURE__*/React.createElement(Icons.StarFill, {
    size: size,
    style: {
      color: '#FFB400'
    }
  }), showVal ? /*#__PURE__*/React.createElement("span", null, value.toFixed(1)) : null, reviews != null ? /*#__PURE__*/React.createElement("span", {
    className: "rev"
  }, "(", reviews, ")") : null);
}
function PhotoPH({
  grad,
  label,
  icon,
  height,
  style
}) {
  return /*#__PURE__*/React.createElement("div", {
    style: {
      width: '100%',
      height: height || '100%',
      background: grad,
      position: 'relative',
      overflow: 'hidden',
      ...style
    }
  }, /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      inset: 0,
      background: 'radial-gradient(circle at 80% 20%, rgba(255,255,255,0.18), transparent 60%)'
    }
  }), label ? /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      left: 14,
      bottom: 12,
      color: 'rgba(255,255,255,0.92)',
      fontSize: 12,
      fontWeight: 500
    }
  }, label) : null, icon ? /*#__PURE__*/React.createElement("div", {
    style: {
      position: 'absolute',
      right: 14,
      bottom: 12,
      color: 'rgba(255,255,255,0.55)'
    }
  }, icon) : null);
}
Object.assign(window, {
  Button,
  Checkbox,
  Radio,
  Toggle,
  Stepper,
  RangeSlider,
  StarRow,
  PhotoPH
});
})(); } catch (e) { __ds_ns.__errors.push({ path: "src/ui.jsx", error: String((e && e.message) || e) }); }

})();
