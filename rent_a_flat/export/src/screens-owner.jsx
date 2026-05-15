// screens-owner.jsx — Owner Dashboard, Create Listing, My Listings, Listing Analytics

function fnOwnerTabs(t) {
  const icon = (path, fill) => (
    <svg width="22" height="22" viewBox="0 0 24 24" fill={fill ? 'currentColor' : 'none'}
         stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      {path}
    </svg>
  );
  return [
    { key: 'dash',     label: 'Dashboard', icon: icon(<><path d="M3 12l4-8 4 6 4-4 6 10"/><path d="M3 20h18"/></>) },
    { key: 'listings', label: 'My listings', icon: icon(<><rect x="3" y="4" width="7" height="7" rx="1"/><rect x="14" y="4" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></>) },
    { key: 'post',     label: 'Post',      icon: <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.4" strokeLinecap="round"><path d="M12 5v14M5 12h14"/></svg> },
    { key: 'messages', label: 'Messages',  icon: icon(<path d="M21 12a8 8 0 11-3.2-6.4L21 4l-1.4 3.2A7.96 7.96 0 0121 12z"/>), badge: 4 },
    { key: 'profile',  label: 'You',       icon: icon(<><circle cx="12" cy="8" r="4"/><path d="M4 21c1.5-4 4.5-6 8-6s6.5 2 8 6"/></>) },
  ];
}

// ─────────────────────────────────────────────────────────────
// Dashboard — KPI cards + recent activity + listings overview
// ─────────────────────────────────────────────────────────────
function FNOwnerDashboard({ t, onCreate, onOpenListings, onOpenListing }) {
  const kpis = [
    { label: 'Active listings', v: '4',   d: '+1 this month', kind: 'primary' },
    { label: 'Views (7d)',      v: '1.2k',d: '↑ 18% vs last',  kind: 'success' },
    { label: 'Inquiries',       v: '23',  d: '6 unread',       kind: 'warning' },
    { label: 'Saved by',        v: '142', d: 'renters',        kind: 'neutral' },
  ];
  const bars = [12, 18, 22, 14, 28, 34, 30, 26, 20, 32, 38, 42, 36, 44];
  return (
    <FNScreen t={t}>
      {/* greeting */}
      <div style={{
        paddingTop: 54, padding: '54px 20px 16px',
        background: t.primary, color: '#fff',
        borderBottomLeftRadius: 28, borderBottomRightRadius: 28,
      }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div>
            <div style={{ fontSize: 12, opacity: 0.7 }}>Welcome back,</div>
            <div style={{ fontSize: 22, fontWeight: 700, letterSpacing: -0.4, marginTop: 2 }}>Tahmid R.</div>
          </div>
          <FNAvatar initials="TR" size={42} color={withAlpha('#fff', 0.18)} t={{ ...t, ink: '#fff' }} />
        </div>

        {/* mini stats inline */}
        <div style={{
          marginTop: 18, padding: 14,
          background: withAlpha('#fff', 0.12), backdropFilter: 'blur(20px)',
          borderRadius: FN_RADIUS.card,
          display: 'flex', justifyContent: 'space-between', alignItems: 'center',
        }}>
          <div>
            <div style={{ fontSize: 11, opacity: 0.7 }}>This week's revenue</div>
            <div style={{ fontSize: 22, fontWeight: 700, marginTop: 2 }}>৳1,18,000</div>
          </div>
          <div style={{ display: 'flex', alignItems: 'flex-end', gap: 3, height: 38 }}>
            {bars.map((h, i) => (
              <div key={i} style={{ width: 5, height: `${(h / 44) * 100}%`,
                background: withAlpha('#fff', 0.7), borderRadius: 1.5 }} />
            ))}
          </div>
        </div>
      </div>

      <div style={{ flex: 1, overflow: 'auto', paddingBottom: 100 }}>
        {/* KPIs */}
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12, padding: '20px 20px 0' }}>
          {kpis.map((k, i) => (
            <div key={i} style={{
              padding: 14, borderRadius: FN_RADIUS.card,
              background: t.surface, border: `1px solid ${t.borderSoft}`, boxShadow: t.shadow,
            }}>
              <div style={{ fontSize: 11, color: t.inkSoft, fontWeight: 500 }}>{k.label}</div>
              <div style={{ fontSize: 24, fontWeight: 700, color: t.ink, marginTop: 6, letterSpacing: -0.4 }}>{k.v}</div>
              <div style={{ marginTop: 8 }}>
                <FNBadge t={t} kind={k.kind}>{k.d}</FNBadge>
              </div>
            </div>
          ))}
        </div>

        {/* Quick actions */}
        <div style={{ padding: '20px 20px 0' }}>
          <FNButton t={t} full size="lg" onClick={onCreate}
            leading={<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.4" strokeLinecap="round"><path d="M12 5v14M5 12h14"/></svg>}>
            Post a new flat
          </FNButton>
        </div>

        {/* My listings preview */}
        <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', padding: '24px 20px 12px' }}>
          <div style={{ fontSize: 17, fontWeight: 700, color: t.ink, letterSpacing: -0.2 }}>Your listings</div>
          <a onClick={onOpenListings} style={{ fontSize: 13, color: t.primary, fontWeight: 600, cursor: 'pointer' }}>Manage</a>
        </div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 10, padding: '0 20px' }}>
          {[
            { l: FN_LISTINGS[0], status: 'active', views: 412, inq: 8 },
            { l: FN_LISTINGS[1], status: 'active', views: 280, inq: 5 },
            { l: FN_LISTINGS[3], status: 'pending', views: 0,  inq: 0 },
          ].map((r, i) => (
            <div key={i} onClick={() => onOpenListing && onOpenListing(r.l)} style={{
              padding: 12, borderRadius: FN_RADIUS.card, background: t.surface,
              border: `1px solid ${t.borderSoft}`, display: 'flex', gap: 12,
              cursor: 'pointer',
            }}>
              <FNPhoto tint={r.l.photoTint} style={{ width: 64, height: 64, borderRadius: 10 }} />
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: 8 }}>
                  <div style={{ fontSize: 13, fontWeight: 700, color: t.ink,
                    overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap', flex: 1 }}>{r.l.title}</div>
                  <FNBadge t={t} kind={r.status}>{r.status}</FNBadge>
                </div>
                <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 2 }}>{r.l.area} · {fnBDT(r.l.price)} /mo</div>
                <div style={{ display: 'flex', gap: 14, marginTop: 6, fontSize: 11, color: t.inkMid }}>
                  <span>👁 {r.views}</span><span>💬 {r.inq}</span>
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* Activity */}
        <div style={{ padding: '24px 20px 12px', fontSize: 17, fontWeight: 700, color: t.ink, letterSpacing: -0.2 }}>Recent activity</div>
        <div style={{ padding: '0 20px', display: 'flex', flexDirection: 'column', gap: 8 }}>
          {[
            { ic: '💬', t: 'New inquiry from Rashid K.', s: '“Is the unit still available?”', time: '12m' },
            { ic: '⭐', t: 'Sunlit 2BR got a 5-star review', s: 'by Faisal M.', time: '2h' },
            { ic: '👁', t: '34 new views today', s: 'across all your listings', time: '5h' },
          ].map((a, i) => (
            <div key={i} style={{
              display: 'flex', gap: 12, padding: 12,
              background: t.surface, borderRadius: 12, border: `1px solid ${t.borderSoft}`,
            }}>
              <div style={{ width: 36, height: 36, borderRadius: 10, background: t.primarySoft,
                display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 16 }}>{a.ic}</div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ fontSize: 13, fontWeight: 600, color: t.ink }}>{a.t}</div>
                <div style={{ fontSize: 12, color: t.inkSoft, marginTop: 2 }}>{a.s}</div>
              </div>
              <div style={{ fontSize: 11, color: t.inkSoft, flexShrink: 0 }}>{a.time}</div>
            </div>
          ))}
        </div>
      </div>

      <FNBottomNav t={t} items={fnOwnerTabs(t)} active="dash" onChange={() => {}} fab="post" />
    </FNScreen>
  );
}

// ─────────────────────────────────────────────────────────────
// Create Listing — multi-step form
// ─────────────────────────────────────────────────────────────
function FNCreateListing({ t, onBack }) {
  const [step, setStep] = React.useState(0);
  const steps = ['Details', 'Photos', 'Location', 'Preview'];
  return (
    <FNScreen t={t}>
      <div style={{
        paddingTop: 54, padding: '54px 16px 14px',
        background: t.surface, borderBottom: `1px solid ${t.borderSoft}`,
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10, marginBottom: 14 }}>
          <FNIconButton t={t} onClick={onBack} bg="transparent">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={t.ink} strokeWidth="2.4" strokeLinecap="round">
              <path d="M15 5l-7 7 7 7"/></svg>
          </FNIconButton>
          <div style={{ fontSize: 17, fontWeight: 700, color: t.ink }}>Post a flat</div>
          <div style={{ flex: 1 }} />
          <div style={{ fontSize: 12, color: t.inkSoft }}>Step {step + 1} of {steps.length}</div>
        </div>
        {/* Step indicator */}
        <div style={{ display: 'flex', gap: 6 }}>
          {steps.map((s, i) => (
            <div key={i} style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 6 }}>
              <div style={{ height: 4, borderRadius: 2,
                background: i <= step ? t.primary : t.borderSoft, transition: 'background .2s' }} />
              <div style={{ fontSize: 11, fontWeight: i === step ? 700 : 500,
                color: i === step ? t.primary : t.inkSoft }}>{s}</div>
            </div>
          ))}
        </div>
      </div>

      <div style={{ flex: 1, overflow: 'auto', padding: '20px 20px 130px' }}>
        {step === 0 && <FNStepDetails t={t} />}
        {step === 1 && <FNStepPhotos t={t} />}
        {step === 2 && <FNStepLocation t={t} />}
        {step === 3 && <FNStepPreview t={t} />}
      </div>

      {/* Sticky footer nav */}
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0,
        background: t.surface, borderTop: `1px solid ${t.borderSoft}`,
        padding: '12px 16px 28px', display: 'flex', gap: 10,
      }}>
        {step > 0 && (
          <FNButton t={t} kind="outline" size="lg" style={{ flex: 1 }}
            onClick={() => setStep(step - 1)}>Back</FNButton>
        )}
        <FNButton t={t} size="lg" style={{ flex: step > 0 ? 2 : 1 }}
          onClick={() => setStep(Math.min(steps.length - 1, step + 1))}>
          {step === steps.length - 1 ? 'Submit for review' : 'Continue →'}
        </FNButton>
      </div>
    </FNScreen>
  );
}

function FNFormGroup({ t, label, hint, children }) {
  return (
    <div style={{ marginBottom: 18 }}>
      <div style={{ fontSize: 12, fontWeight: 600, color: t.inkMid, marginBottom: 6, letterSpacing: 0.1 }}>{label}</div>
      {children}
      {hint && <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 4 }}>{hint}</div>}
    </div>
  );
}

function FNInput({ t, value, defaultValue, placeholder, prefix, suffix, type = 'text', rows }) {
  const baseStyle = {
    width: '100%', minHeight: 48, padding: '12px 14px',
    borderRadius: FN_RADIUS.input,
    background: t.surface, border: `1px solid ${t.borderSoft}`,
    fontSize: 15, color: t.ink, fontFamily: FN_FONT, outline: 'none',
    boxSizing: 'border-box',
  };
  if (rows) return <textarea defaultValue={defaultValue} placeholder={placeholder} rows={rows} style={{ ...baseStyle, minHeight: 24 * rows, resize: 'none' }} />;
  if (prefix || suffix) {
    return (
      <div style={{ display: 'flex', alignItems: 'center', background: t.surface, border: `1px solid ${t.borderSoft}`,
        borderRadius: FN_RADIUS.input }}>
        {prefix && <div style={{ padding: '0 4px 0 14px', fontSize: 15, color: t.inkMid }}>{prefix}</div>}
        <input type={type} defaultValue={defaultValue} placeholder={placeholder}
          style={{ ...baseStyle, border: 'none', background: 'transparent', padding: '12px 14px 12px 8px' }} />
        {suffix && <div style={{ padding: '0 14px 0 4px', fontSize: 13, color: t.inkMid }}>{suffix}</div>}
      </div>
    );
  }
  return <input type={type} defaultValue={defaultValue} placeholder={placeholder} style={baseStyle} />;
}

function FNStepDetails({ t }) {
  const [tp, setTp] = React.useState('Family');
  return (
    <div>
      <FNFormGroup t={t} label="Listing title">
        <FNInput t={t} defaultValue="Sunlit 2BR Studio in Banani" />
      </FNFormGroup>
      <FNFormGroup t={t} label="Type">
        <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
          {['Family', 'Bachelor', 'Couple', 'Student', 'Sublet'].map((x) => (
            <FNChip key={x} t={t} active={tp === x} onClick={() => setTp(x)}>{x}</FNChip>
          ))}
        </div>
      </FNFormGroup>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
        <FNFormGroup t={t} label="Monthly rent">
          <FNInput t={t} prefix="৳" suffix="/mo" defaultValue="28,000" />
        </FNFormGroup>
        <FNFormGroup t={t} label="Deposit (months)">
          <FNInput t={t} defaultValue="2" suffix="mo" />
        </FNFormGroup>
      </div>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 12 }}>
        <FNFormGroup t={t} label="Bedrooms"><FNInput t={t} defaultValue="2" /></FNFormGroup>
        <FNFormGroup t={t} label="Baths"><FNInput t={t} defaultValue="2" /></FNFormGroup>
        <FNFormGroup t={t} label="Size"><FNInput t={t} defaultValue="1100" suffix="ft²" /></FNFormGroup>
      </div>
      <FNFormGroup t={t} label="Description" hint="A few honest sentences works better than buzzwords.">
        <FNInput t={t} rows={4} defaultValue="Bright corner unit with park view, two balconies, semi-furnished. Walking distance to Banani lake." />
      </FNFormGroup>
    </div>
  );
}

function FNStepPhotos({ t }) {
  const slots = [
    { tint: '#FFD9A8' }, { tint: '#A8C4D6' }, { tint: '#D4C3B7' },
    { tint: '#C9D8B7' }, { tint: '#FFE0CC' }, null, null, null,
  ];
  return (
    <div>
      <div style={{ fontSize: 14, color: t.inkMid, marginBottom: 16, lineHeight: 1.5 }}>
        Add at least 3 clear photos. The first one is your cover.
      </div>
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 10 }}>
        {slots.map((s, i) => (
          <div key={i} style={{ aspectRatio: '1', position: 'relative' }}>
            {s ? (
              <>
                <FNPhoto tint={s.tint} style={{ width: '100%', height: '100%', borderRadius: 12 }} />
                {i === 0 && (
                  <div style={{ position: 'absolute', top: 6, left: 6,
                    background: t.primary, color: '#fff',
                    padding: '3px 8px', borderRadius: 999, fontSize: 10, fontWeight: 700 }}>Cover</div>
                )}
                <button style={{
                  position: 'absolute', top: 4, right: 4, width: 22, height: 22, borderRadius: 11,
                  background: withAlpha('#000', 0.6), color: '#fff', border: 'none', cursor: 'pointer',
                  fontSize: 12,
                }}>×</button>
              </>
            ) : (
              <div style={{
                width: '100%', height: '100%', borderRadius: 12,
                border: `1.5px dashed ${t.borderSoft}`, background: t.bgAlt,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                color: t.inkSoft, fontSize: 22,
              }}>+</div>
            )}
          </div>
        ))}
      </div>
      <div style={{
        marginTop: 16, padding: 12, borderRadius: 12, background: t.warningSoft,
        fontSize: 12, color: t.ink, display: 'flex', alignItems: 'flex-start', gap: 10,
      }}>
        <span style={{ fontSize: 16 }}>💡</span>
        <div><b>Tip:</b> Daylight photos with the windows open get 3× more inquiries. Drag-to-reorder anytime.</div>
      </div>
    </div>
  );
}

function FNStepLocation({ t }) {
  return (
    <div>
      <FNFormGroup t={t} label="Area / Neighborhood">
        <FNInput t={t} defaultValue="Banani" />
      </FNFormGroup>
      <FNFormGroup t={t} label="Road & house number" hint="Shown only to renters you've replied to.">
        <FNInput t={t} defaultValue="House 24, Road 11" />
      </FNFormGroup>
      <FNFormGroup t={t} label="Pin on map">
        <div style={{
          height: 200, borderRadius: FN_RADIUS.card,
          background: t.bgAlt, border: `1px solid ${t.borderSoft}`,
          position: 'relative', overflow: 'hidden',
        }}>
          {/* fake map */}
          <svg style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}>
            <path d="M0 80 Q120 60 240 100 T400 90" stroke={t.borderSoft} strokeWidth="6" fill="none"/>
            <path d="M40 160 Q120 200 250 150" stroke={t.borderSoft} strokeWidth="6" fill="none"/>
            <path d="M100 0 L100 200" stroke={t.borderSoft} strokeWidth="4" fill="none"/>
          </svg>
          <div style={{
            position: 'absolute', top: '50%', left: '50%', transform: 'translate(-50%, -100%)',
            color: t.primary, fontSize: 36,
          }}>📍</div>
          <button style={{
            position: 'absolute', right: 10, bottom: 10,
            padding: '8px 14px', borderRadius: 10, background: t.surface,
            border: `1px solid ${t.borderSoft}`, fontSize: 12, fontWeight: 600,
            color: t.ink, cursor: 'pointer',
          }}>Use my location</button>
        </div>
      </FNFormGroup>
      <FNFormGroup t={t} label="Amenities">
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
          {['Wifi', 'Parking', 'Gas', 'Lift', 'Generator', 'Gym', 'Roof', 'Furnished', 'AC'].map((a, i) => (
            <FNChip key={a} t={t} active={i < 5}>{i < 5 ? '✓ ' : ''}{a}</FNChip>
          ))}
        </div>
      </FNFormGroup>
    </div>
  );
}

function FNStepPreview({ t }) {
  return (
    <div>
      <div style={{ fontSize: 13, color: t.inkMid, marginBottom: 14, lineHeight: 1.5 }}>
        Looks good? Submit to publish. We'll review within 24h.
      </div>
      <FNListingCard listing={FN_LISTINGS[0]} t={t} saved={false} onToggleSave={() => {}} onOpen={() => {}} />
      <div style={{
        marginTop: 16, padding: 14, borderRadius: 12,
        background: t.primarySoft,
        display: 'flex', flexDirection: 'column', gap: 6,
      }}>
        <div style={{ fontSize: 13, fontWeight: 700, color: t.primaryInk }}>What happens next?</div>
        <div style={{ fontSize: 12, color: t.primaryInk, lineHeight: 1.5 }}>
          We'll verify your details and your flat goes live within a day. You'll get push + email when it's approved.
        </div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// My listings
// ─────────────────────────────────────────────────────────────
function FNMyListings({ t, onOpenListing }) {
  const rows = [
    { l: FN_LISTINGS[0], status: 'active', views: 412, inq: 8 },
    { l: FN_LISTINGS[1], status: 'active', views: 280, inq: 5 },
    { l: FN_LISTINGS[3], status: 'pending', views: 0,  inq: 0 },
    { l: FN_LISTINGS[2], status: 'rented', views: 122, inq: 0 },
    { l: FN_LISTINGS[4], status: 'rejected', views: 18, inq: 0 },
  ];
  const [filter, setFilter] = React.useState('All');
  return (
    <FNScreen t={t}>
      <FNTopBar t={t} title="My listings" right={
        <FNIconButton t={t}>
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={t.ink} strokeWidth="2" strokeLinecap="round">
            <path d="M12 5v14M5 12h14"/></svg>
        </FNIconButton>
      } />
      <div style={{ display: 'flex', gap: 8, padding: '0 20px 14px', overflowX: 'auto' }}>
        {['All', 'Active', 'Pending', 'Rented', 'Rejected'].map((f) => (
          <FNChip key={f} t={t} active={filter === f} onClick={() => setFilter(f)}>{f}</FNChip>
        ))}
      </div>
      <div style={{ flex: 1, overflow: 'auto', padding: '0 20px 100px', display: 'flex', flexDirection: 'column', gap: 12 }}>
        {rows.map((r, i) => (
          <div key={i} onClick={() => onOpenListing && onOpenListing(r.l)} style={{
            background: t.surface, borderRadius: FN_RADIUS.card,
            border: `1px solid ${t.borderSoft}`, boxShadow: t.shadow,
            overflow: 'hidden', cursor: 'pointer',
          }}>
            <div style={{ display: 'flex', gap: 12, padding: 12 }}>
              <FNPhoto tint={r.l.photoTint} style={{ width: 90, height: 90, borderRadius: 12 }} />
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', gap: 8 }}>
                  <div style={{ fontSize: 14, fontWeight: 700, color: t.ink, lineHeight: 1.3, flex: 1 }}>{r.l.title}</div>
                  <FNBadge t={t} kind={r.status}>{r.status}</FNBadge>
                </div>
                <div style={{ fontSize: 12, color: t.inkSoft, marginTop: 4 }}>{r.l.area} · {fnBDT(r.l.price)} /mo</div>
                <div style={{ display: 'flex', gap: 16, marginTop: 8, fontSize: 12, color: t.inkMid }}>
                  <span>👁 <b style={{ color: t.ink }}>{r.views}</b> views</span>
                  <span>💬 <b style={{ color: t.ink }}>{r.inq}</b> inquiries</span>
                </div>
              </div>
            </div>
            <div style={{ display: 'flex', borderTop: `1px solid ${t.borderSoft}` }}>
              {['Edit', 'Analytics', 'Share'].map((a, j) => (
                <button key={a} style={{
                  flex: 1, padding: '11px 0', background: 'transparent',
                  border: 'none', borderLeft: j > 0 ? `1px solid ${t.borderSoft}` : 'none',
                  fontSize: 13, fontWeight: 600, color: t.ink,
                  fontFamily: FN_FONT, cursor: 'pointer',
                }}>{a}</button>
              ))}
            </div>
          </div>
        ))}
      </div>
      <FNBottomNav t={t} items={fnOwnerTabs(t)} active="listings" onChange={() => {}} fab="post" />
    </FNScreen>
  );
}

Object.assign(window, { fnOwnerTabs, FNOwnerDashboard, FNCreateListing, FNMyListings });
