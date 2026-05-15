// ui-app.jsx — app-shell UI: phone screen container, top bars, bottom nav,
// listing card, bottom sheet, search bar, toast.

// Phone-screen container — fills the iOS frame's content area. Status bar
// is overlaid by IOSDevice; we add top padding so content clears it.
function FNScreen({ children, t, bg, statusDark = false, style }) {
  return (
    <div style={{
      width: '100%', height: '100%', overflow: 'hidden',
      background: bg ?? t.bg,
      color: t.ink, fontFamily: FN_FONT,
      display: 'flex', flexDirection: 'column',
      colorScheme: t.dark ? 'dark' : 'light',
      ...style,
    }} data-status-dark={statusDark ? 1 : 0}>
      {children}
    </div>
  );
}

// FlatNest logo mark — abstract roof + window
function FNLogo({ size = 28, color }) {
  const c = color || '#fff';
  return (
    <svg width={size} height={size} viewBox="0 0 32 32" fill="none">
      <path d="M4 16L16 5l12 11v10a3 3 0 01-3 3H7a3 3 0 01-3-3V16z"
            fill={c} fillOpacity="0.18" stroke={c} strokeWidth="2" strokeLinejoin="round"/>
      <rect x="12.5" y="15.5" width="7" height="9" rx="1.2" stroke={c} strokeWidth="1.8" fill={c} fillOpacity="0.5"/>
      <path d="M16 15.5V24.5M12.5 20H19.5" stroke={c} strokeWidth="1.5"/>
    </svg>
  );
}

// ─────────────────────────────────────────────────────────────
// Top bar (in-screen, below status bar)
// ─────────────────────────────────────────────────────────────
function FNTopBar({ left, right, title, t, transparent, sticky }) {
  return (
    <div style={{
      position: sticky ? 'sticky' : 'relative', top: 0, zIndex: 5,
      paddingTop: 54, paddingLeft: 16, paddingRight: 16, paddingBottom: 8,
      display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      background: transparent ? 'transparent' : t.bg,
      gap: 12,
    }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 10, minWidth: 0 }}>
        {left}
        {title && <div style={{ fontSize: 17, fontWeight: 600, color: t.ink, letterSpacing: -0.2 }}>{title}</div>}
      </div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>{right}</div>
    </div>
  );
}

function FNIconButton({ children, onClick, t, bg, size = 38 }) {
  return (
    <button onClick={onClick} style={{
      width: size, height: size, borderRadius: size / 2,
      background: bg || t.surface, border: `1px solid ${t.borderSoft}`,
      display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
      cursor: 'pointer', padding: 0, color: t.ink,
    }}>{children}</button>
  );
}

// ─────────────────────────────────────────────────────────────
// Bottom navigation — sits absolutely at the bottom of the screen,
// inside the iOS frame. The home indicator is on top (zIndex 60 in
// IOSDevice) — we add 18px of bottom padding so labels clear it.
// ─────────────────────────────────────────────────────────────
function FNBottomNav({ items, active, onChange, t, fab }) {
  return (
    <div style={{
      position: 'absolute', left: 0, right: 0, bottom: 0, zIndex: 30,
      paddingTop: 8, paddingBottom: 22,
      background: t.surface, borderTop: `1px solid ${t.borderSoft}`,
      display: 'flex', alignItems: 'stretch', justifyContent: 'space-around',
      boxShadow: '0 -2px 12px rgba(15,20,30,0.04)',
    }}>
      {items.map((it, i) => {
        const isFab = fab === it.key;
        const isActive = active === it.key;
        if (isFab) {
          return (
            <button key={it.key} onClick={() => onChange(it.key)} style={{
              border: 'none', background: 'transparent', cursor: 'pointer',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              padding: 0, flex: 1,
            }}>
              <div style={{
                width: 48, height: 48, borderRadius: 14, background: t.primary,
                display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
                color: '#fff', boxShadow: `0 8px 20px ${withAlpha(t.primary, 0.4)}`,
                marginTop: -10,
              }}>{it.icon}</div>
            </button>
          );
        }
        return (
          <button key={it.key} onClick={() => onChange(it.key)} style={{
            flex: 1, border: 'none', background: 'transparent', cursor: 'pointer',
            display: 'flex', flexDirection: 'column', alignItems: 'center',
            gap: 3, color: isActive ? t.primary : t.inkSoft,
            padding: 0,
          }}>
            <div style={{ position: 'relative', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
              {it.icon}
              {it.badge && (
                <span style={{
                  position: 'absolute', top: -3, right: -8,
                  minWidth: 16, height: 16, padding: '0 4px', borderRadius: 8,
                  background: t.secondary, color: '#fff',
                  fontSize: 10, fontWeight: 700,
                  display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
                }}>{it.badge}</span>
              )}
            </div>
            <span style={{ fontSize: 10.5, fontWeight: isActive ? 600 : 500 }}>{it.label}</span>
          </button>
        );
      })}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Search bar — pill input with leading icon
// ─────────────────────────────────────────────────────────────
function FNSearch({ value, onChange, placeholder = 'Search area, price, type…', t, trailing }) {
  return (
    <div style={{
      display: 'flex', alignItems: 'center', gap: 10,
      height: 48, padding: '0 14px',
      borderRadius: 14, background: t.surface,
      border: `1px solid ${t.borderSoft}`,
      boxShadow: '0 1px 2px rgba(15,20,30,0.03)',
    }}>
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={t.inkSoft} strokeWidth="2.2" strokeLinecap="round">
        <circle cx="11" cy="11" r="7"/><path d="M20 20l-3.5-3.5"/>
      </svg>
      <input value={value || ''} onChange={(e) => onChange && onChange(e.target.value)}
        placeholder={placeholder}
        style={{
          flex: 1, border: 'none', outline: 'none', background: 'transparent',
          fontFamily: FN_FONT, fontSize: 14, color: t.ink,
        }} />
      {trailing}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Listing card — the spec's flagship component
// Photo with price badge top-left, heart top-right, distance chip,
// title + area, owner avatar, beds/baths/sqft row.
// ─────────────────────────────────────────────────────────────
function FNListingCard({ listing: l, t, onOpen, saved, onToggleSave, layout = 'feed' }) {
  const compact = layout === 'compact';
  const ph = compact ? 130 : 180;
  return (
    <div onClick={onOpen} style={{
      background: t.surface, borderRadius: FN_RADIUS.card,
      overflow: 'hidden', boxShadow: t.shadow,
      border: t.dark ? `1px solid ${t.borderSoft}` : 'none',
      cursor: 'pointer',
    }}>
      <FNPhoto tint={l.photoTint} label={compact ? null : 'Flat photo'}
        style={{ width: '100%', height: ph, position: 'relative' }}>
        {/* price badge */}
        <div style={{
          position: 'absolute', top: 10, left: 10,
          background: withAlpha('#fff', 0.96),
          padding: '5px 10px', borderRadius: FN_RADIUS.chip,
          fontSize: 13, fontWeight: 700, color: t.ink,
          boxShadow: '0 2px 6px rgba(0,0,0,0.10)',
        }}>{fnBDT(l.price)}<span style={{ fontWeight: 500, color: t.inkSoft, fontSize: 11 }}> /mo</span></div>
        {/* distance chip */}
        <div style={{
          position: 'absolute', bottom: 10, left: 10,
          background: withAlpha('#000', 0.55), color: '#fff',
          padding: '4px 8px', borderRadius: FN_RADIUS.chip,
          fontSize: 11, fontWeight: 500,
          backdropFilter: 'blur(6px)',
        }}>📍 {l.distance}</div>
        {/* heart */}
        <div style={{ position: 'absolute', top: 8, right: 8 }}>
          <FNHeart active={!!saved} onClick={onToggleSave} t={t} size={18} />
        </div>
      </FNPhoto>
      <div style={{ padding: 14 }}>
        <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: 10 }}>
          <div style={{ minWidth: 0, flex: 1 }}>
            <div style={{ fontSize: 14.5, fontWeight: 600, color: t.ink, letterSpacing: -0.2,
              overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{l.title}</div>
            <div style={{ fontSize: 12, color: t.inkSoft, marginTop: 2 }}>{l.area} · {l.type}</div>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 3, fontSize: 12, color: t.ink, fontWeight: 600 }}>
            <svg width="12" height="12" viewBox="0 0 24 24" fill={t.warning}><path d="M12 2l3 6.5 7 1-5 5 1.5 7L12 18l-6.5 3.5L7 14.5 2 9.5l7-1z"/></svg>
            {l.rating}
          </div>
        </div>
        <div style={{
          display: 'flex', gap: 14, marginTop: 10,
          fontSize: 12, color: t.inkMid, fontWeight: 500,
          borderTop: `1px dashed ${t.borderSoft}`, paddingTop: 10,
        }}>
          <span>🛏 {l.beds} BR</span>
          <span>🚿 {l.baths} Bath</span>
          <span>📐 {l.size} ft²</span>
        </div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Bottom sheet — slides up from bottom, semi-transparent backdrop
// ─────────────────────────────────────────────────────────────
function FNBottomSheet({ open, onClose, t, children, height = 520 }) {
  // Render even when closed for the exit animation; we mount/unmount with
  // a short delay so opacity/transform can transition. Simple "open" prop
  // drives everything inline.
  return (
    <div style={{
      position: 'absolute', inset: 0, zIndex: 80,
      pointerEvents: open ? 'auto' : 'none',
    }}>
      <div onClick={onClose} style={{
        position: 'absolute', inset: 0,
        background: 'rgba(15,20,30,0.4)',
        opacity: open ? 1 : 0,
        transition: 'opacity 220ms ease',
      }} />
      <div style={{
        position: 'absolute', bottom: 0, left: 0, right: 0,
        height, background: t.surface,
        borderTopLeftRadius: FN_RADIUS.sheet, borderTopRightRadius: FN_RADIUS.sheet,
        transform: open ? 'translateY(0)' : 'translateY(100%)',
        transition: 'transform 280ms cubic-bezier(.4,.0,.2,1)',
        display: 'flex', flexDirection: 'column',
        boxShadow: '0 -8px 24px rgba(0,0,0,0.15)',
      }}>
        <div style={{ display: 'flex', justifyContent: 'center', padding: '8px 0 4px' }}>
          <div style={{ width: 40, height: 4, borderRadius: 2, background: t.inkFaint }} />
        </div>
        {children}
      </div>
    </div>
  );
}

Object.assign(window, {
  FNScreen, FNLogo, FNTopBar, FNIconButton, FNBottomNav,
  FNSearch, FNListingCard, FNBottomSheet,
});
