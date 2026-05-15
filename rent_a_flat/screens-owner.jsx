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
function FNCreateListing({ t, onBack, initialStep = 0 }) {
  const [step, setStep] = React.useState(initialStep);
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

// Bangladesh administrative location hierarchy (mock subset).
// Division → District → Upazila → Union. Picked the cities/areas a
// renter on FlatNest is most likely to filter.
const FN_BD_LOCATIONS = {
  'Dhaka': {
    'Dhaka': {
      'Gulshan': ['Gulshan 1', 'Gulshan 2', 'Niketan', 'Baridhara DOHS'],
      'Banani': ['Banani DOHS', 'Banani Block A', 'Banani Block C', 'Banani Block F'],
      'Dhanmondi': ['Dhanmondi 27', 'Dhanmondi 32', 'Lalmatia', 'Kalabagan'],
      'Mirpur': ['Mirpur 1', 'Mirpur 10', 'Mirpur 11', 'Pallabi', 'Kazipara'],
      'Mohammadpur': ['Mohammadpur', 'Adabor', 'Shyamoli', 'Tajmahal Road'],
      'Uttara': ['Sector 3', 'Sector 7', 'Sector 11', 'Sector 13'],
    },
    'Gazipur': {
      'Gazipur Sadar': ['Joydebpur', 'Tongi', 'Konabari', 'Board Bazar'],
      'Kaliakair': ['Kaliakair Sadar', 'Mouchak', 'Safipur'],
    },
    'Narayanganj': {
      'Narayanganj Sadar': ['Fatullah', 'Siddhirganj', 'Bandar'],
      'Rupganj': ['Rupganj Sadar', 'Murapara', 'Tarabo'],
    },
  },
  'Chattogram': {
    'Chattogram': {
      'Panchlaish': ['Probortok', 'O.R. Nizam Road', 'Mehedibag'],
      'Khulshi': ['East Khulshi', 'West Khulshi', 'GEC'],
      'Pahartali': ['Foy\u2019s Lake', 'Akbar Shah'],
    },
    'Cox\u2019s Bazar': {
      'Cox\u2019s Bazar Sadar': ['Kolatoli', 'Sugandha', 'Laboni'],
    },
  },
  'Sylhet': {
    'Sylhet': {
      'Sylhet Sadar': ['Zindabazar', 'Amberkhana', 'Shahjalal Uposhohor'],
      'Beanibazar': ['Beanibazar Sadar', 'Kurar Bazar'],
    },
  },
  'Khulna': {
    'Khulna': {
      'Khulna Sadar': ['Sonadanga', 'Khalishpur', 'Daulatpur'],
    },
  },
  'Rajshahi': {
    'Rajshahi': {
      'Boalia': ['Shaheb Bazar', 'Uposhohor', 'Lakshmipur'],
    },
  },
  'Barishal': {
    'Barishal': {
      'Barishal Sadar': ['Band Road', 'Nathullabad', 'Rupatoli'],
    },
  },
  'Rangpur': {
    'Rangpur': {
      'Rangpur Sadar': ['Dhap', 'Jahaj Company More', 'Modern More'],
    },
  },
  'Mymensingh': {
    'Mymensingh': {
      'Mymensingh Sadar': ['Charpara', 'Ganginar Par', 'Maskanda'],
    },
  },
};

// Get child list for a path
function fnLocChildren(div, dist, upa) {
  if (!div) return Object.keys(FN_BD_LOCATIONS);
  const d = FN_BD_LOCATIONS[div]; if (!d) return [];
  if (!dist) return Object.keys(d);
  const u = d[dist]; if (!u) return [];
  if (!upa) return Object.keys(u);
  return u[upa] || [];
}

// ─────────────────────────────────────────────────────────────
// Cascading select — closed pill with label + value + caret.
// Tap to open an inline picker rendered below.
// state: 'idle' | 'loading' | 'disabled'
// ─────────────────────────────────────────────────────────────
function FNCascadeSelect({
  t, label, placeholder, value, options, loading, disabled,
  open, onToggle, onPick,
}) {
  return (
    <div style={{ marginBottom: 12, opacity: disabled ? 0.55 : 1 }}>
      <div style={{
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        marginBottom: 6,
      }}>
        <div style={{ fontSize: 12, fontWeight: 600, color: t.inkMid, letterSpacing: 0.1 }}>{label}</div>
        {loading && (
          <div style={{ display: 'flex', alignItems: 'center', gap: 5, fontSize: 10, color: t.inkSoft }}>
            <span style={{
              width: 10, height: 10, borderRadius: 5,
              border: `1.5px solid ${t.borderSoft}`, borderTopColor: t.primary,
              animation: 'fn-spin .6s linear infinite', display: 'inline-block',
            }} />
            Loading
          </div>
        )}
      </div>
      <button
        disabled={disabled}
        onClick={() => !disabled && !loading && onToggle && onToggle()}
        style={{
          width: '100%', minHeight: 48, padding: '0 14px',
          borderRadius: FN_RADIUS.input,
          background: t.surface,
          border: `1.5px solid ${open ? t.primary : (value ? t.borderSoft : t.borderSoft)}`,
          boxShadow: open ? `0 0 0 4px ${withAlpha(t.primary, 0.12)}` : 'none',
          display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 10,
          fontFamily: FN_FONT, cursor: disabled ? 'not-allowed' : 'pointer',
          transition: 'border-color .15s, box-shadow .15s',
        }}>
        <span style={{
          fontSize: 15, fontWeight: value ? 600 : 500,
          color: value ? t.ink : t.inkFaint, textAlign: 'left',
        }}>
          {value || placeholder}
        </span>
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke={t.inkSoft} strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round"
          style={{ transform: open ? 'rotate(180deg)' : 'none', transition: 'transform .2s' }}>
          <path d="M6 9l6 6 6-6"/>
        </svg>
      </button>

      {open && (
        <div style={{
          marginTop: 6, borderRadius: FN_RADIUS.input,
          background: t.surface, border: `1px solid ${t.borderSoft}`,
          boxShadow: t.shadowLg, overflow: 'hidden',
          animation: 'fn-loc-down 180ms cubic-bezier(.2,.7,.3,1)',
        }}>
          <div style={{
            padding: '8px 12px', fontSize: 11, fontWeight: 600,
            color: t.inkSoft, letterSpacing: 0.4, textTransform: 'uppercase',
            background: t.bgAlt, borderBottom: `1px solid ${t.borderSoft}`,
          }}>{options.length} option{options.length === 1 ? '' : 's'}</div>
          <div style={{ maxHeight: 196, overflowY: 'auto' }}>
            {options.map((opt) => {
              const selected = opt === value;
              return (
                <button key={opt} onClick={() => onPick && onPick(opt)} style={{
                  width: '100%', padding: '12px 14px',
                  background: selected ? t.primarySoft : 'transparent',
                  border: 'none', borderBottom: `1px solid ${t.borderSoft}`,
                  display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 10,
                  fontFamily: FN_FONT, fontSize: 14,
                  color: selected ? t.primaryInk : t.ink,
                  fontWeight: selected ? 600 : 500,
                  cursor: 'pointer', textAlign: 'left',
                }}>
                  <span>{opt}</span>
                  {selected && (
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke={t.primary} strokeWidth="2.8" strokeLinecap="round" strokeLinejoin="round">
                      <path d="M20 6L9 17l-5-5"/>
                    </svg>
                  )}
                </button>
              );
            })}
          </div>
        </div>
      )}
    </div>
  );
}

function FNStepLocation({ t }) {
  const [div, setDiv]   = React.useState('Dhaka');
  const [dist, setDist] = React.useState('Dhaka');
  const [upa, setUpa]   = React.useState('Banani');
  const [uni, setUni]   = React.useState('');
  const [open, setOpen] = React.useState('uni'); // which dropdown is open
  const [loading, setLoading] = React.useState(null); // which child is "fetching"
  const [gpsState, setGpsState] = React.useState('idle'); // idle | locating | done
  const [coords, setCoords] = React.useState({ lat: 23.7937, lng: 90.4066 }); // Banani default

  // Simulate API load when a parent changes — child shows spinner briefly.
  const fetchChild = (childKey) => {
    setLoading(childKey);
    clearTimeout(fetchChild._t);
    fetchChild._t = setTimeout(() => setLoading(null), 650);
  };

  const pickDiv = (v) => {
    setDiv(v); setDist(''); setUpa(''); setUni('');
    fetchChild('dist'); setOpen('dist');
  };
  const pickDist = (v) => {
    setDist(v); setUpa(''); setUni('');
    fetchChild('upa'); setOpen('upa');
  };
  const pickUpa = (v) => {
    setUpa(v); setUni('');
    fetchChild('uni'); setOpen('uni');
  };
  // Tiny lookup so each Union gets plausible Dhaka-ish coords.
  const fnCoordsFor = (d, di, u, un) => {
    const seed = (d + di + u + un).split('').reduce((a, c) => a + c.charCodeAt(0), 0);
    const j = (n) => ((seed * (n + 7)) % 1000) / 100000; // tiny jitter
    const base = { lat: 23.7937, lng: 90.4066 };
    if (d === 'Chattogram') Object.assign(base, { lat: 22.3569, lng: 91.7832 });
    else if (d === 'Sylhet') Object.assign(base, { lat: 24.8949, lng: 91.8687 });
    else if (d === 'Khulna') Object.assign(base, { lat: 22.8456, lng: 89.5403 });
    else if (d === 'Rajshahi') Object.assign(base, { lat: 24.3745, lng: 88.6042 });
    else if (d === 'Barishal') Object.assign(base, { lat: 22.7010, lng: 90.3535 });
    else if (d === 'Rangpur') Object.assign(base, { lat: 25.7439, lng: 89.2752 });
    else if (d === 'Mymensingh') Object.assign(base, { lat: 24.7471, lng: 90.4203 });
    return { lat: +(base.lat + j(1) - 0.005).toFixed(6), lng: +(base.lng + j(2) - 0.005).toFixed(6) };
  };

  const pickUni = (v) => {
    setUni(v); setOpen(null);
    setCoords(fnCoordsFor(div, dist, upa, v));
  };

  const runGps = () => {
    setGpsState('locating');
    setTimeout(() => {
      setDiv('Dhaka'); setDist('Dhaka'); setUpa('Banani'); setUni('Banani DOHS');
      setCoords({ lat: 23.793712, lng: 90.406589 });
      setGpsState('done'); setOpen(null);
    }, 1400);
  };

  const labelPath = [div, dist, upa, uni].filter(Boolean).join(' · ');

  return (
    <div>
      {/* GPS auto-detect */}
      <button onClick={runGps} disabled={gpsState === 'locating'} style={{
        width: '100%', minHeight: 52, padding: '10px 14px',
        borderRadius: FN_RADIUS.input,
        background: gpsState === 'done' ? t.successSoft : t.primarySoft,
        border: `1px solid ${gpsState === 'done' ? withAlpha(t.success, 0.4) : withAlpha(t.primary, 0.25)}`,
        display: 'flex', alignItems: 'center', gap: 12,
        fontFamily: FN_FONT, cursor: gpsState === 'locating' ? 'progress' : 'pointer',
        marginBottom: 18, textAlign: 'left',
        transition: 'background .2s, border-color .2s',
      }}>
        <div style={{
          width: 34, height: 34, borderRadius: 17,
          background: gpsState === 'done' ? t.success : t.primary,
          color: '#fff', display: 'inline-flex',
          alignItems: 'center', justifyContent: 'center', flexShrink: 0,
        }}>
          {gpsState === 'locating' ? (
            <span style={{
              width: 16, height: 16, borderRadius: 8,
              border: `2px solid ${withAlpha('#fff', 0.35)}`, borderTopColor: '#fff',
              animation: 'fn-spin .7s linear infinite', display: 'inline-block',
            }} />
          ) : gpsState === 'done' ? (
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
              <path d="M20 6L9 17l-5-5"/>
            </svg>
          ) : (
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M12 22s7-7.5 7-13a7 7 0 10-14 0c0 5.5 7 13 7 13z"/>
              <circle cx="12" cy="9" r="2.5"/>
            </svg>
          )}
        </div>
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ fontSize: 13.5, fontWeight: 700, color: gpsState === 'done' ? t.success : t.primaryInk }}>
            {gpsState === 'locating' ? 'Detecting your location…' :
             gpsState === 'done' ? 'Location detected' : 'Use my current location'}
          </div>
          <div style={{ fontSize: 11.5, color: t.inkMid, marginTop: 2 }}>
            {gpsState === 'done' ? labelPath : 'We\u2019ll fill in the fields below from GPS.'}
          </div>
        </div>
      </button>

      {/* divider */}
      <div style={{ display: 'flex', alignItems: 'center', gap: 10, margin: '0 0 18px' }}>
        <div style={{ flex: 1, height: 1, background: t.borderSoft }} />
        <div style={{ fontSize: 10, fontWeight: 600, letterSpacing: 0.8, color: t.inkSoft, textTransform: 'uppercase' }}>or enter manually</div>
        <div style={{ flex: 1, height: 1, background: t.borderSoft }} />
      </div>

      {/* Cascading dropdowns */}
      <FNCascadeSelect t={t}
        label="Division"
        placeholder="Select division"
        value={div}
        options={fnLocChildren()}
        open={open === 'div'}
        onToggle={() => setOpen(open === 'div' ? null : 'div')}
        onPick={pickDiv}
      />
      <FNCascadeSelect t={t}
        label="District"
        placeholder={div ? 'Select district' : 'Select division first'}
        value={dist}
        options={fnLocChildren(div)}
        disabled={!div}
        loading={loading === 'dist'}
        open={open === 'dist'}
        onToggle={() => setOpen(open === 'dist' ? null : 'dist')}
        onPick={pickDist}
      />
      <FNCascadeSelect t={t}
        label="Upazila / Thana"
        placeholder={dist ? 'Select upazila' : 'Select district first'}
        value={upa}
        options={fnLocChildren(div, dist)}
        disabled={!dist}
        loading={loading === 'upa'}
        open={open === 'upa'}
        onToggle={() => setOpen(open === 'upa' ? null : 'upa')}
        onPick={pickUpa}
      />
      <FNCascadeSelect t={t}
        label="Union / Area"
        placeholder={upa ? 'Select union' : 'Select upazila first'}
        value={uni}
        options={fnLocChildren(div, dist, upa)}
        disabled={!upa}
        loading={loading === 'uni'}
        open={open === 'uni'}
        onToggle={() => setOpen(open === 'uni' ? null : 'uni')}
        onPick={pickUni}
      />

      {/* Road & house number */}
      <FNFormGroup t={t} label="Road & house number" hint="Shown only to renters you've replied to.">
        <FNInput t={t} defaultValue="House 24, Road 11" />
      </FNFormGroup>

      {/* Pin on map */}
      <FNFormGroup t={t} label="Pin on map">
        <div style={{
          height: 180, borderRadius: FN_RADIUS.card,
          background: t.bgAlt, border: `1px solid ${t.borderSoft}`,
          position: 'relative', overflow: 'hidden',
        }}>
          <svg style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }}>
            <path d="M0 80 Q120 60 240 100 T400 90" stroke={t.borderSoft} strokeWidth="6" fill="none"/>
            <path d="M40 160 Q120 200 250 150" stroke={t.borderSoft} strokeWidth="6" fill="none"/>
            <path d="M100 0 L100 200" stroke={t.borderSoft} strokeWidth="4" fill="none"/>
          </svg>
          <div style={{
            position: 'absolute', top: 10, left: 10,
            background: withAlpha(t.surface, 0.95),
            padding: '6px 10px', borderRadius: 999,
            fontSize: 11, fontWeight: 600, color: t.ink,
            boxShadow: t.shadow, display: 'flex', alignItems: 'center', gap: 5,
            maxWidth: 'calc(100% - 20px)',
          }}>
            <svg width="11" height="11" viewBox="0 0 24 24" fill={t.primary}>
              <path d="M12 22s7-7.5 7-13a7 7 0 10-14 0c0 5.5 7 13 7 13z"/>
            </svg>
            <span style={{ overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
              {labelPath || 'No location selected'}
            </span>
          </div>
          {/* concentric accuracy rings around pin */}
          <div style={{
            position: 'absolute', top: '50%', left: '50%',
            width: 96, height: 96, borderRadius: 48,
            transform: 'translate(-50%, -50%)',
            background: withAlpha(t.primary, 0.10),
            border: `1px solid ${withAlpha(t.primary, 0.3)}`,
            animation: 'fn-loc-pulse 2.4s ease-in-out infinite',
          }} />
          <div style={{
            position: 'absolute', top: '50%', left: '50%',
            transform: 'translate(-50%, -100%)',
            color: t.primary, fontSize: 36,
            filter: `drop-shadow(0 4px 6px ${withAlpha(t.primary, 0.4)})`,
          }}>📍</div>
          {/* drag-to-adjust hint */}
          <div style={{
            position: 'absolute', bottom: 10, left: 10, right: 10,
            background: withAlpha(t.ink, 0.78), color: '#fff',
            padding: '6px 10px', borderRadius: 8,
            fontSize: 10.5, fontWeight: 500, letterSpacing: 0.2,
            display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 8,
            backdropFilter: 'blur(4px)',
          }}>
            <span>Drag the pin to fine-tune the exact spot.</span>
            <span style={{
              padding: '2px 6px', borderRadius: 4,
              background: withAlpha('#fff', 0.18),
              fontFamily: 'ui-monospace, SFMono-Regular, Menlo, monospace',
              fontSize: 10, fontWeight: 600,
            }}>±5m</span>
          </div>
        </div>
      </FNFormGroup>

      {/* Precise coordinates readout */}
      <FNFormGroup t={t} label="Precise coordinates" hint="Auto-filled from GPS or pin drag. Editable for fine corrections.">
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
          <div style={{
            display: 'flex', alignItems: 'center', gap: 8,
            height: 48, padding: '0 12px', borderRadius: FN_RADIUS.input,
            background: t.surface, border: `1px solid ${t.borderSoft}`,
          }}>
            <span style={{ fontSize: 10, fontWeight: 700, color: t.inkSoft, letterSpacing: 0.4 }}>LAT</span>
            <input
              value={coords.lat}
              onChange={(e) => setCoords({ ...coords, lat: e.target.value })}
              style={{
                flex: 1, minWidth: 0, height: '100%', border: 'none', outline: 'none',
                background: 'transparent', fontFamily: 'ui-monospace, SFMono-Regular, Menlo, monospace',
                fontSize: 13, fontWeight: 600, color: t.ink, letterSpacing: -0.2,
              }}
            />
          </div>
          <div style={{
            display: 'flex', alignItems: 'center', gap: 8,
            height: 48, padding: '0 12px', borderRadius: FN_RADIUS.input,
            background: t.surface, border: `1px solid ${t.borderSoft}`,
          }}>
            <span style={{ fontSize: 10, fontWeight: 700, color: t.inkSoft, letterSpacing: 0.4 }}>LNG</span>
            <input
              value={coords.lng}
              onChange={(e) => setCoords({ ...coords, lng: e.target.value })}
              style={{
                flex: 1, minWidth: 0, height: '100%', border: 'none', outline: 'none',
                background: 'transparent', fontFamily: 'ui-monospace, SFMono-Regular, Menlo, monospace',
                fontSize: 13, fontWeight: 600, color: t.ink, letterSpacing: -0.2,
              }}
            />
          </div>
        </div>
        <div style={{
          display: 'flex', alignItems: 'center', gap: 6, marginTop: 8,
          fontSize: 11, color: gpsState === 'done' ? t.success : t.inkSoft,
        }}>
          {gpsState === 'done' ? (
            <>
              <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke={t.success} strokeWidth="3" strokeLinecap="round">
                <path d="M20 6L9 17l-5-5"/>
              </svg>
              <span style={{ fontWeight: 600 }}>GPS lock acquired</span>
              <span style={{ color: t.inkSoft, fontWeight: 500 }}>· accuracy ±4.2m</span>
            </>
          ) : (
            <>
              <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                <circle cx="12" cy="12" r="10"/><path d="M12 8v4l3 2"/>
              </svg>
              Coordinates estimated from selected area.
            </>
          )}
        </div>
      </FNFormGroup>

      {/* Amenities */}
      <FNFormGroup t={t} label="Amenities">
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
          {['Wifi', 'Parking', 'Gas', 'Lift', 'Generator', 'Gym', 'Roof', 'Furnished', 'AC'].map((a, i) => (
            <FNChip key={a} t={t} active={i < 5}>{i < 5 ? '✓ ' : ''}{a}</FNChip>
          ))}
        </div>
      </FNFormGroup>

      <style>{`
        @keyframes fn-loc-down {
          from { opacity: 0; transform: translateY(-4px); }
          to   { opacity: 1; transform: translateY(0); }
        }
        @keyframes fn-spin { to { transform: rotate(360deg); } }
        @keyframes fn-loc-pulse {
          0%, 100% { opacity: 0.5; transform: translate(-50%, -50%) scale(0.9); }
          50%      { opacity: 0.9; transform: translate(-50%, -50%) scale(1.08); }
        }
      `}</style>
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
