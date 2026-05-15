// screens-renter.jsx — Home/Discovery, Filters (bottom sheet), Listing Detail, Map, Wishlist

// Reusable renter bottom nav config
function fnRenterTabs(t, active) {
  const C = '#0a0a0a'; // unused, just to scope
  const icon = (path, fill) => (
    <svg width="22" height="22" viewBox="0 0 24 24" fill={fill ? 'currentColor' : 'none'}
         stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      {path}
    </svg>
  );
  return [
    { key: 'home',     label: 'Home',    icon: icon(<><path d="M3 11l9-8 9 8"/><path d="M5 10v10h14V10"/></>) },
    { key: 'map',      label: 'Map',     icon: icon(<><path d="M9 4l-6 2v14l6-2 6 2 6-2V4l-6 2-6-2z"/><path d="M9 4v14M15 6v14"/></>) },
    { key: 'wishlist', label: 'Saved',   icon: icon(<path d="M12 21s-7-4.5-9.5-9C.5 8 3 4 6.5 4c2 0 3.7 1.2 5.5 3.2C13.8 5.2 15.5 4 17.5 4 21 4 23.5 8 21.5 12c-2.5 4.5-9.5 9-9.5 9z"/>) },
    { key: 'messages', label: 'Messages', icon: icon(<path d="M21 12a8 8 0 11-3.2-6.4L21 4l-1.4 3.2A7.96 7.96 0 0121 12z"/>), badge: 2 },
    { key: 'profile',  label: 'You',     icon: icon(<><circle cx="12" cy="8" r="4"/><path d="M4 21c1.5-4 4.5-6 8-6s6.5 2 8 6"/></>) },
  ];
}

// ─────────────────────────────────────────────────────────────
// Home / Discovery
// ─────────────────────────────────────────────────────────────
function FNHome({ t, onOpenListing, onOpenFilters, saved, toggleSave }) {
  const [chip, setChip] = React.useState('All');
  return (
    <FNScreen t={t}>
      {/* TopBar: hello + avatar */}
      <div style={{ paddingTop: 54, paddingLeft: 20, paddingRight: 20, paddingBottom: 12,
        display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <div>
          <div style={{ fontSize: 12, color: t.inkSoft }}>📍 Banani, Dhaka</div>
          <div style={{ fontSize: 22, fontWeight: 700, color: t.ink, letterSpacing: -0.4, marginTop: 2 }}>
            Hello, Rashid 👋
          </div>
        </div>
        <div style={{ display: 'flex', gap: 10 }}>
          <FNIconButton t={t}>
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={t.ink} strokeWidth="2" strokeLinecap="round">
              <path d="M18 8a6 6 0 10-12 0c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.7 21a2 2 0 01-3.4 0"/>
            </svg>
            <span style={{ position: 'absolute', width: 7, height: 7, borderRadius: 4, background: t.secondary,
              transform: 'translate(8px, -8px)' }} />
          </FNIconButton>
          <FNAvatar initials="RK" size={38} color={t.primarySoft} t={t} />
        </div>
      </div>

      {/* scroll body */}
      <div style={{ flex: 1, overflow: 'auto', paddingBottom: 100 }}>
        <div style={{ padding: '0 20px' }}>
          <FNSearch t={t} placeholder="Search flats by area or feature"
            trailing={
              <button onClick={onOpenFilters} style={{
                width: 32, height: 32, borderRadius: 10, background: t.primary, color: '#fff',
                border: 'none', cursor: 'pointer', display: 'inline-flex',
                alignItems: 'center', justifyContent: 'center',
              }}>
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.2" strokeLinecap="round">
                  <path d="M3 6h18M6 12h12M10 18h4"/>
                </svg>
              </button>
            } />
        </div>

        {/* Chips */}
        <div style={{ display: 'flex', gap: 8, padding: '14px 20px 14px', overflowX: 'auto' }}>
          {FN_FILTER_CHIPS.map((c) => (
            <FNChip key={c} active={chip === c} onClick={() => setChip(c)} t={t}>{c}</FNChip>
          ))}
        </div>

        {/* Hero / Featured listing */}
        <div style={{ padding: '0 20px' }}>
          <div onClick={() => onOpenListing(FN_LISTINGS[0])} style={{
            borderRadius: FN_RADIUS.card, overflow: 'hidden', position: 'relative',
            height: 220, boxShadow: t.shadow, cursor: 'pointer',
          }}>
            <FNPhoto tint={FN_LISTINGS[0].photoTint} style={{ width: '100%', height: '100%', position: 'absolute', inset: 0 }} />
            <div style={{
              position: 'absolute', inset: 0,
              background: 'linear-gradient(180deg, rgba(0,0,0,0) 30%, rgba(0,0,0,0.55) 100%)',
            }} />
            <div style={{ position: 'absolute', top: 12, left: 12 }}>
              <FNBadge t={t} kind="primary">⭐ Featured</FNBadge>
            </div>
            <div style={{ position: 'absolute', top: 8, right: 8 }}>
              <FNHeart active={!!saved[FN_LISTINGS[0].id]} onClick={() => toggleSave(FN_LISTINGS[0].id)} t={t} size={18} />
            </div>
            <div style={{ position: 'absolute', bottom: 14, left: 14, right: 14, color: '#fff' }}>
              <div style={{ fontSize: 11, fontWeight: 500, opacity: 0.85, textTransform: 'uppercase', letterSpacing: 0.5 }}>{FN_LISTINGS[0].area}</div>
              <div style={{ fontSize: 18, fontWeight: 700, letterSpacing: -0.3, marginTop: 4 }}>{FN_LISTINGS[0].title}</div>
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end', marginTop: 10 }}>
                <div style={{ fontSize: 12, opacity: 0.85 }}>🛏 {FN_LISTINGS[0].beds} BR · 🚿 {FN_LISTINGS[0].baths} Bath · {FN_LISTINGS[0].size} ft²</div>
                <div style={{ fontSize: 18, fontWeight: 700 }}>{fnBDT(FN_LISTINGS[0].price)}<span style={{ fontSize: 11, fontWeight: 500, opacity: 0.8 }}> /mo</span></div>
              </div>
            </div>
          </div>
        </div>

        {/* Section header */}
        <div style={{
          display: 'flex', alignItems: 'baseline', justifyContent: 'space-between',
          padding: '24px 20px 12px',
        }}>
          <div style={{ fontSize: 17, fontWeight: 700, color: t.ink, letterSpacing: -0.2 }}>Near you</div>
          <a style={{ fontSize: 13, color: t.primary, fontWeight: 600 }}>See all</a>
        </div>

        {/* Listings */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 16, padding: '0 20px' }}>
          {FN_LISTINGS.slice(1, 4).map((l) => (
            <FNListingCard key={l.id} listing={l} t={t}
              saved={saved[l.id]} onToggleSave={() => toggleSave(l.id)}
              onOpen={() => onOpenListing(l)} />
          ))}
        </div>
      </div>

      <FNBottomNav t={t} items={fnRenterTabs(t)} active="home" onChange={() => {}} />
    </FNScreen>
  );
}

// ─────────────────────────────────────────────────────────────
// Filters bottom sheet contents
// ─────────────────────────────────────────────────────────────
function FNFiltersSheet({ t, onClose }) {
  const [type, setType] = React.useState('Family');
  const [price, setPrice] = React.useState(35000);
  const [radius, setRadius] = React.useState(5);
  const [amen, setAmen] = React.useState({ Wifi: true, Parking: true, Gas: false, Lift: true, Generator: false, Gym: false });
  return (
    <div style={{ padding: '12px 20px 28px', flex: 1, overflow: 'auto' }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '4px 0 12px' }}>
        <div style={{ fontSize: 20, fontWeight: 700, color: t.ink, letterSpacing: -0.3 }}>Filters</div>
        <a style={{ fontSize: 13, color: t.primary, fontWeight: 600 }} onClick={onClose}>Reset</a>
      </div>

      <div style={{ marginTop: 8 }}>
        <div style={{ fontSize: 12, fontWeight: 700, color: t.inkMid, textTransform: 'uppercase', letterSpacing: 0.6, marginBottom: 10 }}>Type</div>
        <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
          {['Family', 'Bachelor', 'Couple', 'Student', 'Sublet'].map((x) => (
            <FNChip key={x} t={t} active={type === x} onClick={() => setType(x)}>{x}</FNChip>
          ))}
        </div>
      </div>

      <div style={{ marginTop: 22 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 10 }}>
          <div style={{ fontSize: 12, fontWeight: 700, color: t.inkMid, textTransform: 'uppercase', letterSpacing: 0.6 }}>Max price</div>
          <div style={{ fontSize: 14, fontWeight: 700, color: t.primary }}>{fnBDT(price)} /mo</div>
        </div>
        <input type="range" min="5000" max="80000" step="500" value={price}
          onChange={(e) => setPrice(+e.target.value)}
          style={{ width: '100%', accentColor: t.primary }} />
        <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 11, color: t.inkSoft, marginTop: 2 }}>
          <span>৳5k</span><span>৳80k</span>
        </div>
      </div>

      <div style={{ marginTop: 22 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 10 }}>
          <div style={{ fontSize: 12, fontWeight: 700, color: t.inkMid, textTransform: 'uppercase', letterSpacing: 0.6 }}>Radius</div>
          <div style={{ fontSize: 14, fontWeight: 700, color: t.primary }}>{radius} km</div>
        </div>
        <input type="range" min="1" max="15" value={radius} onChange={(e) => setRadius(+e.target.value)}
          style={{ width: '100%', accentColor: t.primary }} />
      </div>

      <div style={{ marginTop: 22 }}>
        <div style={{ fontSize: 12, fontWeight: 700, color: t.inkMid, textTransform: 'uppercase', letterSpacing: 0.6, marginBottom: 10 }}>Amenities</div>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
          {Object.keys(amen).map((k) => (
            <FNChip key={k} t={t} active={amen[k]} onClick={() => setAmen({ ...amen, [k]: !amen[k] })}>
              {amen[k] ? '✓ ' : ''}{k}
            </FNChip>
          ))}
        </div>
      </div>

      <div style={{ display: 'flex', gap: 12, marginTop: 28 }}>
        <FNButton t={t} kind="outline" size="lg" style={{ flex: 1 }} onClick={onClose}>Cancel</FNButton>
        <FNButton t={t} size="lg" style={{ flex: 2 }} onClick={onClose}>Show 124 results</FNButton>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Listing detail
// ─────────────────────────────────────────────────────────────
function FNListingDetail({ t, listing: l, onBack, saved, onToggleSave, onOpenChat }) {
  const [photoIdx, setPhotoIdx] = React.useState(0);
  if (!l) return null;
  return (
    <FNScreen t={t} bg={t.bg}>
      <div style={{ flex: 1, overflow: 'auto', paddingBottom: 100 }}>
        {/* Photo carousel */}
        <div style={{ position: 'relative', height: 360 }}>
          <FNPhoto tint={l.photos[photoIdx] || l.photoTint} label={`Photo ${photoIdx + 1} of ${l.photos.length}`}
            style={{ width: '100%', height: '100%' }} />
          {/* top buttons */}
          <div style={{
            position: 'absolute', top: 56, left: 16, right: 16,
            display: 'flex', justifyContent: 'space-between',
          }}>
            <FNIconButton t={t} onClick={onBack} bg={withAlpha('#fff', 0.95)}>
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke={t.ink} strokeWidth="2.4" strokeLinecap="round">
                <path d="M15 5l-7 7 7 7"/></svg>
            </FNIconButton>
            <div style={{ display: 'flex', gap: 8 }}>
              <FNIconButton t={t} bg={withAlpha('#fff', 0.95)}>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke={t.ink} strokeWidth="2" strokeLinecap="round">
                  <path d="M4 12v8a2 2 0 002 2h12a2 2 0 002-2v-8M16 6l-4-4-4 4M12 2v14"/></svg>
              </FNIconButton>
              <FNHeart t={t} active={!!saved} onClick={onToggleSave} size={18} />
            </div>
          </div>
          {/* pagination dots */}
          <div style={{
            position: 'absolute', bottom: 16, left: '50%', transform: 'translateX(-50%)',
            display: 'flex', gap: 5,
          }}>
            {l.photos.map((_, i) => (
              <div key={i} onClick={() => setPhotoIdx(i)} style={{
                width: i === photoIdx ? 22 : 6, height: 6, borderRadius: 3,
                background: i === photoIdx ? '#fff' : withAlpha('#fff', 0.5),
                cursor: 'pointer',
              }} />
            ))}
          </div>
          {/* photo counter */}
          <div style={{
            position: 'absolute', bottom: 16, right: 16,
            padding: '4px 10px', borderRadius: FN_RADIUS.chip,
            background: withAlpha('#000', 0.55), color: '#fff',
            fontSize: 11, fontWeight: 600, backdropFilter: 'blur(6px)',
          }}>{photoIdx + 1}/{l.photos.length}</div>
        </div>

        {/* content */}
        <div style={{ padding: '20px 20px 0' }}>
          <div style={{ display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: 12 }}>
            <div style={{ flex: 1 }}>
              <FNBadge t={t} kind="primary">{l.type}</FNBadge>
              <div style={{ fontSize: 22, fontWeight: 700, color: t.ink, letterSpacing: -0.4, marginTop: 8, lineHeight: 1.25 }}>{l.title}</div>
              <div style={{ fontSize: 13, color: t.inkMid, marginTop: 6 }}>📍 {l.area} · {l.distance} away</div>
            </div>
            <div style={{ textAlign: 'right' }}>
              <div style={{ fontSize: 22, fontWeight: 700, color: t.ink }}>{fnBDT(l.price)}</div>
              <div style={{ fontSize: 11, color: t.inkSoft }}>per month</div>
            </div>
          </div>

          {/* stat strip */}
          <div style={{
            display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)',
            gap: 8, marginTop: 20,
            padding: '14px 0',
            background: t.surface, borderRadius: FN_RADIUS.card,
            border: `1px solid ${t.borderSoft}`,
          }}>
            {[
              ['🛏', l.beds, 'Bed'],
              ['🚿', l.baths, 'Bath'],
              ['📐', l.size, 'ft²'],
              ['⭐', l.rating, `${l.reviews} rev`],
            ].map(([ic, val, lab], i) => (
              <div key={i} style={{ textAlign: 'center', borderLeft: i > 0 ? `1px solid ${t.borderSoft}` : 'none' }}>
                <div style={{ fontSize: 18 }}>{ic}</div>
                <div style={{ fontSize: 14, fontWeight: 700, color: t.ink, marginTop: 4 }}>{val}</div>
                <div style={{ fontSize: 11, color: t.inkSoft }}>{lab}</div>
              </div>
            ))}
          </div>

          {/* About */}
          <div style={{ marginTop: 24 }}>
            <div style={{ fontSize: 16, fontWeight: 700, color: t.ink, letterSpacing: -0.2 }}>About this flat</div>
            <div style={{ fontSize: 13, color: t.inkMid, marginTop: 8, lineHeight: 1.55, textWrap: 'pretty' }}>
              {l.description}
            </div>
          </div>

          {/* Amenities */}
          <div style={{ marginTop: 24 }}>
            <div style={{ fontSize: 16, fontWeight: 700, color: t.ink, letterSpacing: -0.2 }}>Amenities</div>
            <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8, marginTop: 10 }}>
              {l.amenities.map((a) => (
                <div key={a} style={{
                  padding: '8px 12px', borderRadius: FN_RADIUS.chip,
                  background: t.surface, border: `1px solid ${t.borderSoft}`,
                  fontSize: 12, fontWeight: 500, color: t.ink,
                }}>✓ {a}</div>
              ))}
            </div>
          </div>

          {/* Owner card */}
          <div style={{
            marginTop: 24, padding: 14, borderRadius: FN_RADIUS.card,
            background: t.surface, border: `1px solid ${t.borderSoft}`,
            display: 'flex', alignItems: 'center', gap: 12,
          }}>
            <FNAvatar initials={l.owner.initials} size={48} color={l.photoTint} t={t} />
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
                <div style={{ fontSize: 14, fontWeight: 700, color: t.ink }}>{l.owner.name}</div>
                {l.owner.verified && (
                  <svg width="14" height="14" viewBox="0 0 24 24" fill={t.primary}>
                    <path d="M12 2l3 2.5 4-.5.5 4L22 11l-2.5 3 .5 4-4-.5L12 22l-3-2.5-4 .5-.5-4L2 13l2.5-3-.5-4 4 .5z"/>
                    <path d="M8 12l3 3 6-6" stroke="#fff" strokeWidth="2.2" fill="none" strokeLinecap="round" strokeLinejoin="round"/>
                  </svg>
                )}
              </div>
              <div style={{ fontSize: 12, color: t.inkSoft, marginTop: 2 }}>Owner · on FlatNest since {l.owner.since}</div>
            </div>
            <FNButton t={t} kind="soft" size="sm" onClick={onOpenChat}>Message</FNButton>
          </div>

          {/* Location preview */}
          <div style={{ marginTop: 24 }}>
            <div style={{ fontSize: 16, fontWeight: 700, color: t.ink, letterSpacing: -0.2 }}>Location</div>
            <div style={{
              marginTop: 10, height: 140, borderRadius: FN_RADIUS.card,
              background: t.dark ? '#23272B' : '#E8EEF2',
              border: `1px solid ${t.borderSoft}`,
              position: 'relative', overflow: 'hidden',
            }}>
              {/* fake roads */}
              {[20, 50, 80].map((y, i) => (
                <div key={i} style={{ position: 'absolute', top: `${y}%`, left: 0, right: 0,
                  height: 2, background: t.dark ? '#3A3F44' : '#D4DDE4' }} />
              ))}
              {[30, 70].map((x, i) => (
                <div key={i + 9} style={{ position: 'absolute', left: `${x}%`, top: 0, bottom: 0,
                  width: 2, background: t.dark ? '#3A3F44' : '#D4DDE4' }} />
              ))}
              {/* pin */}
              <div style={{
                position: 'absolute', top: '50%', left: '50%', transform: 'translate(-50%, -100%)',
                background: t.primary, color: '#fff',
                padding: '6px 10px', borderRadius: 999,
                fontSize: 12, fontWeight: 700,
                boxShadow: `0 6px 14px ${withAlpha(t.primary, 0.4)}`,
              }}>{fnBDT(l.price)}</div>
            </div>
          </div>
        </div>
      </div>

      {/* Sticky CTA */}
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0, zIndex: 30,
        padding: '12px 20px 32px', background: t.surface, borderTop: `1px solid ${t.borderSoft}`,
        display: 'flex', gap: 10, alignItems: 'center',
      }}>
        <FNIconButton t={t}>
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke={t.ink} strokeWidth="2" strokeLinecap="round">
            <path d="M22 16.92V20a2 2 0 01-2.18 2A19.79 19.79 0 012 4.18 2 2 0 014 2h3.08a2 2 0 012 1.72 12.84 12.84 0 00.7 2.81 2 2 0 01-.45 2.11L8 10a16 16 0 006 6l1.36-1.36a2 2 0 012.11-.45 12.84 12.84 0 002.81.7A2 2 0 0122 16.92z"/>
          </svg>
        </FNIconButton>
        <FNButton t={t} full size="lg" onClick={onOpenChat}>💬 Message Owner</FNButton>
      </div>
    </FNScreen>
  );
}

// ─────────────────────────────────────────────────────────────
// Map view
// ─────────────────────────────────────────────────────────────
function FNMap({ t }) {
  const [selected, setSelected] = React.useState('l1');
  const sel = FN_LISTINGS.find((x) => x.id === selected);
  // Generate organic-looking landmasses
  return (
    <FNScreen t={t} bg={t.dark ? '#1A1F22' : '#E4EBF0'}>
      {/* fake map */}
      <div style={{ position: 'absolute', inset: 0 }}>
        {/* water/road grid */}
        <div style={{
          position: 'absolute', inset: 0,
          background: t.dark ? '#1A1F22' : '#E4EBF0',
          backgroundImage: `
            linear-gradient(${t.dark ? '#252B30' : '#D2DCE3'} 1px, transparent 1px),
            linear-gradient(90deg, ${t.dark ? '#252B30' : '#D2DCE3'} 1px, transparent 1px)`,
          backgroundSize: '36px 36px',
        }} />
        {/* land blobs */}
        <div style={{
          position: 'absolute', top: 100, left: -40, width: 280, height: 280,
          borderRadius: '50% 60% 40% 70% / 50% 40% 60% 50%',
          background: t.dark ? '#23282C' : '#EEF3F6',
        }} />
        <div style={{
          position: 'absolute', top: 280, right: -60, width: 320, height: 320,
          borderRadius: '60% 40% 70% 50% / 50% 60% 40% 50%',
          background: t.dark ? '#23282C' : '#EEF3F6',
        }} />
        <div style={{
          position: 'absolute', top: 480, left: 60, width: 240, height: 240,
          borderRadius: '70% 50% 40% 60% / 60% 50% 50% 40%',
          background: t.dark ? '#23282C' : '#EEF3F6',
        }} />
        {/* roads */}
        <svg style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}>
          <path d="M0 200 Q150 240 280 180 T400 240" stroke={t.dark ? '#2C3236' : '#C7D2DA'} strokeWidth="6" fill="none"/>
          <path d="M40 400 Q150 380 220 460 T400 450" stroke={t.dark ? '#2C3236' : '#C7D2DA'} strokeWidth="6" fill="none"/>
          <path d="M120 60 L120 800" stroke={t.dark ? '#2C3236' : '#C7D2DA'} strokeWidth="5" fill="none"/>
        </svg>
      </div>

      {/* top search overlay */}
      <div style={{
        position: 'absolute', top: 54, left: 16, right: 16, zIndex: 5,
      }}>
        <FNSearch t={t} placeholder="Banani · ৳20k–35k · 2BR"
          trailing={
            <button style={{
              width: 32, height: 32, borderRadius: 10, background: t.primary,
              border: 'none', cursor: 'pointer', color: '#fff',
              display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
            }}>
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.2" strokeLinecap="round">
                <path d="M3 6h18M6 12h12M10 18h4"/>
              </svg>
            </button>
          } />
      </div>

      {/* pins */}
      {FN_LISTINGS.map((l) => (
        <button key={l.id} onClick={() => setSelected(l.id)} style={{
          position: 'absolute', top: `${l.coords.y}%`, left: `${l.coords.x}%`,
          transform: 'translate(-50%, -100%)',
          border: 'none', background: selected === l.id ? t.ink : t.surface,
          color: selected === l.id ? '#fff' : t.ink,
          padding: '6px 10px', borderRadius: 999,
          fontSize: 12, fontWeight: 700,
          boxShadow: '0 4px 14px rgba(0,0,0,0.18)',
          cursor: 'pointer',
        }}>{fnBDT(l.price)}</button>
      ))}

      {/* legend / location button */}
      <div style={{
        position: 'absolute', right: 16, top: 130, zIndex: 5,
        display: 'flex', flexDirection: 'column', gap: 8,
      }}>
        {['+', '−', '🧭'].map((c, i) => (
          <button key={i} style={{
            width: 40, height: 40, borderRadius: 12, background: t.surface,
            border: `1px solid ${t.borderSoft}`, fontSize: 16, fontWeight: 600,
            cursor: 'pointer', boxShadow: t.shadow,
          }}>{c}</button>
        ))}
      </div>

      {/* mini-card preview */}
      {sel && (
        <div style={{
          position: 'absolute', left: 16, right: 16, bottom: 100, zIndex: 5,
          background: t.surface, borderRadius: FN_RADIUS.card,
          padding: 12, boxShadow: t.shadowLg,
          display: 'flex', gap: 12,
        }}>
          <FNPhoto tint={sel.photoTint} style={{ width: 80, height: 80, borderRadius: 12 }} />
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline' }}>
              <div style={{ fontSize: 11, color: t.inkSoft }}>{sel.area} · {sel.distance}</div>
              <div style={{ fontSize: 12, fontWeight: 700, color: t.ink }}>⭐ {sel.rating}</div>
            </div>
            <div style={{ fontSize: 14, fontWeight: 700, color: t.ink, marginTop: 2,
              overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{sel.title}</div>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: 6 }}>
              <div style={{ fontSize: 11, color: t.inkMid }}>🛏 {sel.beds} · 🚿 {sel.baths} · {sel.size} ft²</div>
              <div style={{ fontSize: 14, fontWeight: 700, color: t.primary }}>{fnBDT(sel.price)}</div>
            </div>
          </div>
        </div>
      )}

      <FNBottomNav t={t} items={fnRenterTabs(t)} active="map" onChange={() => {}} />
    </FNScreen>
  );
}

// ─────────────────────────────────────────────────────────────
// Wishlist
// ─────────────────────────────────────────────────────────────
function FNWishlist({ t, saved, toggleSave, onOpenListing }) {
  const items = FN_LISTINGS.filter((l) => saved[l.id]);
  return (
    <FNScreen t={t}>
      <FNTopBar t={t} title="Saved flats" right={
        <FNIconButton t={t}>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke={t.ink} strokeWidth="2" strokeLinecap="round">
            <path d="M3 6h18M6 12h12M10 18h4"/></svg>
        </FNIconButton>} />
      <div style={{ flex: 1, overflow: 'auto', padding: '4px 20px 100px' }}>
        <div style={{ fontSize: 13, color: t.inkSoft, marginBottom: 14 }}>
          {items.length} {items.length === 1 ? 'flat' : 'flats'} · Swipe left to remove
        </div>
        {items.length === 0 ? (
          <div style={{ textAlign: 'center', padding: '60px 20px' }}>
            <div style={{ fontSize: 56 }}>💔</div>
            <div style={{ fontSize: 17, fontWeight: 700, color: t.ink, marginTop: 16, letterSpacing: -0.2 }}>Nothing saved yet</div>
            <div style={{ fontSize: 13, color: t.inkMid, marginTop: 8, lineHeight: 1.5, maxWidth: 260, margin: '8px auto 0' }}>
              Tap the heart on any flat to save it here for later.
            </div>
            <div style={{ marginTop: 22 }}><FNButton t={t} kind="soft" size="md">Browse flats</FNButton></div>
          </div>
        ) : (
          <div style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
            {items.map((l) => (
              <FNListingCard key={l.id} listing={l} t={t} saved onToggleSave={() => toggleSave(l.id)}
                onOpen={() => onOpenListing(l)} />
            ))}
          </div>
        )}
      </div>
      <FNBottomNav t={t} items={fnRenterTabs(t)} active="wishlist" onChange={() => {}} />
    </FNScreen>
  );
}

Object.assign(window, { fnRenterTabs, FNHome, FNFiltersSheet, FNListingDetail, FNMap, FNWishlist });
