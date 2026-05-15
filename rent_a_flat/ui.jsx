// ui.jsx — shared FlatNest UI primitives
// Loaded after theme.jsx. Exposes window-level components.

// Format BDT as "৳28,000"
function fnBDT(n) {
  return '৳' + Math.round(n).toLocaleString('en-US');
}

// ─────────────────────────────────────────────────────────────
// Photo placeholder — striped SVG with optional tint + label
// Used wherever a real flat photo would go.
// ─────────────────────────────────────────────────────────────
function FNPhoto({ tint = '#D6CFC4', label, style, children }) {
  const stripe = `repeating-linear-gradient(135deg, ${withAlpha('#000', 0.04)} 0 1px, transparent 1px 18px)`;
  return (
    <div style={{
      position: 'relative', overflow: 'hidden', background: tint,
      backgroundImage: stripe, ...style,
    }}>
      {/* subtle vignette so labels read */}
      <div style={{
        position: 'absolute', inset: 0,
        background: `linear-gradient(180deg, ${withAlpha('#000', 0)} 50%, ${withAlpha('#000', 0.18)} 100%)`,
      }} />
      {label && (
        <div style={{
          position: 'absolute', bottom: 6, left: 8,
          fontFamily: 'ui-monospace, SFMono-Regular, Menlo, monospace',
          fontSize: 9, color: withAlpha('#fff', 0.85),
          textTransform: 'uppercase', letterSpacing: 0.4,
        }}>{label}</div>
      )}
      {children}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Status pill — colored badge
// ─────────────────────────────────────────────────────────────
function FNBadge({ children, kind = 'neutral', t }) {
  const map = {
    active:   { bg: t.successSoft, fg: t.success },
    pending:  { bg: t.warningSoft, fg: t.warning },
    rejected: { bg: t.errorSoft,   fg: t.error },
    rented:   { bg: t.bgAlt,       fg: t.inkMid },
    primary:  { bg: t.primarySoft, fg: t.primary },
    neutral:  { bg: t.bgAlt,       fg: t.inkMid },
  };
  const c = map[kind] || map.neutral;
  return (
    <span style={{
      display: 'inline-flex', alignItems: 'center', gap: 4,
      padding: '3px 9px', borderRadius: FN_RADIUS.chip,
      fontSize: 11, fontWeight: 600, letterSpacing: 0.1,
      background: c.bg, color: c.fg, whiteSpace: 'nowrap',
    }}>{children}</span>
  );
}

// ─────────────────────────────────────────────────────────────
// Avatar with initials
// ─────────────────────────────────────────────────────────────
function FNAvatar({ initials, size = 36, color, t }) {
  const bg = color || t.bgAlt;
  return (
    <div style={{
      width: size, height: size, borderRadius: size / 2,
      background: bg, color: t.ink,
      display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
      fontSize: size * 0.36, fontWeight: 600, flexShrink: 0,
    }}>{initials}</div>
  );
}

// ─────────────────────────────────────────────────────────────
// Animated heart — pop scale + colorfill
// ─────────────────────────────────────────────────────────────
function FNHeart({ active, onClick, t, size = 22 }) {
  const [pop, setPop] = React.useState(false);
  const handle = (e) => {
    e.stopPropagation();
    setPop(true); setTimeout(() => setPop(false), 320);
    onClick && onClick();
  };
  return (
    <button onClick={handle} style={{
      width: size + 14, height: size + 14, borderRadius: 999,
      background: withAlpha('#fff', 0.9), border: 'none',
      display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
      cursor: 'pointer', padding: 0,
      boxShadow: '0 2px 8px rgba(0,0,0,0.12)',
      transform: pop ? 'scale(1.18)' : 'scale(1)',
      transition: 'transform 280ms cubic-bezier(.34,1.56,.64,1)',
    }}>
      <svg width={size} height={size} viewBox="0 0 24 24" fill={active ? t.secondary : 'none'}
           stroke={active ? t.secondary : '#3b3b3b'} strokeWidth={active ? 0 : 2}>
        <path d="M12 21s-7-4.5-9.5-9C.5 8 3 4 6.5 4c2 0 3.7 1.2 5.5 3.2C13.8 5.2 15.5 4 17.5 4 21 4 23.5 8 21.5 12c-2.5 4.5-9.5 9-9.5 9z"
              strokeLinecap="round" strokeLinejoin="round"/>
      </svg>
    </button>
  );
}

// ─────────────────────────────────────────────────────────────
// Primary / secondary / ghost button
// ─────────────────────────────────────────────────────────────
function FNButton({ children, kind = 'primary', size = 'md', t, full, onClick, leading, style }) {
  const sizes = { sm: { h: 36, px: 14, fs: 13 }, md: { h: 48, px: 18, fs: 15 }, lg: { h: 54, px: 22, fs: 16 } };
  const s = sizes[size];
  const kinds = {
    primary:   { bg: t.primary,    fg: '#fff',     bd: 'transparent' },
    secondary: { bg: t.secondary,  fg: '#fff',     bd: 'transparent' },
    soft:      { bg: t.primarySoft, fg: t.primaryInk, bd: 'transparent' },
    outline:   { bg: 'transparent', fg: t.ink,      bd: t.border },
    ghost:     { bg: 'transparent', fg: t.ink,      bd: 'transparent' },
  };
  const k = kinds[kind] || kinds.primary;
  return (
    <button onClick={onClick} style={{
      height: s.h, padding: `0 ${s.px}px`, borderRadius: FN_RADIUS.button,
      background: k.bg, color: k.fg, border: `1px solid ${k.bd}`,
      fontSize: s.fs, fontWeight: 600, fontFamily: FN_FONT,
      display: 'inline-flex', alignItems: 'center', justifyContent: 'center', gap: 8,
      width: full ? '100%' : undefined, cursor: 'pointer',
      letterSpacing: -0.1, transition: 'transform .12s, filter .12s',
      ...style,
    }}
    onMouseDown={(e) => (e.currentTarget.style.transform = 'scale(0.98)')}
    onMouseUp={(e) => (e.currentTarget.style.transform = 'scale(1)')}
    onMouseLeave={(e) => (e.currentTarget.style.transform = 'scale(1)')}>
      {leading}{children}
    </button>
  );
}

// ─────────────────────────────────────────────────────────────
// Filter chip — horizontally scrollable
// ─────────────────────────────────────────────────────────────
function FNChip({ children, active, onClick, t }) {
  return (
    <button onClick={onClick} style={{
      height: 34, padding: '0 14px', borderRadius: FN_RADIUS.chip,
      background: active ? t.ink : t.surface,
      color: active ? '#fff' : t.ink,
      border: `1px solid ${active ? t.ink : t.border}`,
      fontSize: 13, fontWeight: 500, fontFamily: FN_FONT,
      whiteSpace: 'nowrap', cursor: 'pointer', flexShrink: 0,
    }}>{children}</button>
  );
}

Object.assign(window, { fnBDT, FNPhoto, FNBadge, FNAvatar, FNHeart, FNButton, FNChip });
