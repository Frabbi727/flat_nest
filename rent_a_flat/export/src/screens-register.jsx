// screens-register.jsx — multi-step Sign-Up flow
// Step 1: Basic information
// Step 2: Personal details (role + DOB)
// Step 3: Avatar upload
// Step 4: Success
//
// Reuses theme.jsx tokens + ui.jsx primitives. No new colors introduced;
// the look matches Auth + Post-a-flat patterns already in the app.

// ───────────────────────────────────────────────────────────────
// Reusable form field — label + input + status + helper / error.
// state: 'idle' | 'valid' | 'error' | 'focus'
// ───────────────────────────────────────────────────────────────
function FNField({
  t, label, value, onChange, placeholder, type = 'text',
  state = 'idle', error, hint, leading, trailing,
  autoFocus, onFocus, onBlur, fixedPrefix,
}) {
  const [focused, setFocused] = React.useState(!!autoFocus);
  const showFocus = focused || state === 'focus';
  const isError = state === 'error';
  const isValid = state === 'valid';

  let borderColor = t.borderSoft;
  let glow = 'none';
  if (isError) { borderColor = t.error; glow = `0 0 0 4px ${withAlpha(t.error, 0.10)}`; }
  else if (showFocus) { borderColor = t.primary; glow = `0 0 0 4px ${withAlpha(t.primary, 0.12)}`; }
  else if (isValid) { borderColor = withAlpha(t.success, 0.6); }

  return (
    <div>
      {label && (
        <div style={{
          fontSize: 12, fontWeight: 600, color: t.inkMid,
          marginBottom: 6, letterSpacing: 0.1,
        }}>{label}</div>
      )}
      <div style={{
        position: 'relative',
        display: 'flex', alignItems: 'center',
        height: 52, borderRadius: FN_RADIUS.input,
        background: t.surface,
        border: `1.5px solid ${borderColor}`,
        boxShadow: glow,
        transition: 'border-color .15s, box-shadow .15s',
        padding: '0 14px', gap: 10,
      }}>
        {leading && <span style={{ color: showFocus ? t.primary : t.inkSoft, display: 'inline-flex' }}>{leading}</span>}
        {fixedPrefix && (
          <span style={{ fontSize: 15, color: t.ink, fontWeight: 500 }}>{fixedPrefix}</span>
        )}
        <input
          value={value || ''}
          onChange={(e) => onChange && onChange(e.target.value)}
          placeholder={placeholder}
          type={type}
          onFocus={(e) => { setFocused(true); onFocus && onFocus(e); }}
          onBlur={(e) => { setFocused(false); onBlur && onBlur(e); }}
          style={{
            flex: 1, minWidth: 0, height: '100%',
            border: 'none', outline: 'none', background: 'transparent',
            fontFamily: FN_FONT, fontSize: 15, color: t.ink,
            letterSpacing: type === 'password' && value ? 2 : 0,
          }}
        />
        {isValid && !trailing && (
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={t.success} strokeWidth="2.6" strokeLinecap="round" strokeLinejoin="round">
            <path d="M20 6L9 17l-5-5"/>
          </svg>
        )}
        {trailing}
      </div>
      {(error || hint) && (
        <div style={{
          marginTop: 6, fontSize: 12,
          color: isError ? t.error : t.inkSoft,
          display: 'flex', alignItems: 'center', gap: 4,
          lineHeight: 1.4,
        }}>
          {isError && (
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke={t.error} strokeWidth="2.4" strokeLinecap="round">
              <circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/>
            </svg>
          )}
          <span>{error || hint}</span>
        </div>
      )}
    </div>
  );
}

// ───────────────────────────────────────────────────────────────
// Stepper — three segmented bars + label row.
// Matches FNCreateListing's step indicator visually.
// ───────────────────────────────────────────────────────────────
function FNRegStepper({ t, step, labels }) {
  return (
    <div style={{ display: 'flex', gap: 8, padding: '0 24px', marginTop: 6 }}>
      {labels.map((s, i) => (
        <div key={i} style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 6 }}>
          <div style={{
            height: 4, borderRadius: 2,
            background: i <= step ? t.primary : t.borderSoft,
            transition: 'background .3s',
          }} />
          <div style={{
            fontSize: 11, fontWeight: i === step ? 700 : 500,
            color: i === step ? t.primary : (i < step ? t.inkMid : t.inkSoft),
            letterSpacing: 0.1,
          }}>{s}</div>
        </div>
      ))}
    </div>
  );
}

// ───────────────────────────────────────────────────────────────
// Reg screen chrome — back button, step counter, stepper, slide-in
// content wrapper. Children receive their own scroll area.
// ───────────────────────────────────────────────────────────────
function FNRegChrome({ t, step, labels, onBack, title, subtitle, children }) {
  return (
    <FNScreen t={t}>
      {/* Top bar — slim, just back + counter */}
      <div style={{
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        paddingTop: 54, paddingLeft: 16, paddingRight: 24, paddingBottom: 12,
      }}>
        <FNIconButton t={t} onClick={onBack}>
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={t.ink} strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
            <path d="M15 18l-6-6 6-6"/>
          </svg>
        </FNIconButton>
        <div style={{ fontSize: 12, color: t.inkSoft, fontWeight: 500 }}>
          Step <span style={{ color: t.ink, fontWeight: 700 }}>{step + 1}</span> of {labels.length}
        </div>
      </div>

      <FNRegStepper t={t} step={step} labels={labels} />

      <div key={step} style={{
        flex: 1, overflowY: 'auto', display: 'flex', flexDirection: 'column',
        animation: 'fn-reg-slide 320ms cubic-bezier(.22,.61,.36,1)',
      }}>
        <div style={{ padding: '28px 24px 0' }}>
          <div style={{ fontSize: 26, fontWeight: 700, color: t.ink, letterSpacing: -0.5, textWrap: 'balance' }}>
            {title}
          </div>
          {subtitle && (
            <div style={{ fontSize: 14, color: t.inkMid, marginTop: 6, lineHeight: 1.5, textWrap: 'pretty' }}>
              {subtitle}
            </div>
          )}
        </div>
        {children}
      </div>

      <style>{`
        @keyframes fn-reg-slide {
          from { opacity: 0; transform: translateX(18px); }
          to   { opacity: 1; transform: translateX(0); }
        }
        @keyframes fn-reg-pop {
          0%   { opacity: 0; transform: scale(.85); }
          60%  { transform: scale(1.06); }
          100% { opacity: 1; transform: scale(1); }
        }
        @keyframes fn-spin { to { transform: rotate(360deg); } }
        @keyframes fn-confetti-1 {
          0%   { transform: translate(0,0) rotate(0); opacity: 0; }
          20%  { opacity: 1; }
          100% { transform: translate(var(--dx), var(--dy)) rotate(360deg); opacity: 0; }
        }
      `}</style>
    </FNScreen>
  );
}

// ═══════════════════════════════════════════════════════════════
// STEP 1 — Basic information
// ═══════════════════════════════════════════════════════════════
function FNRegStep1({ t, data, setData, onContinue, onBack, demoState = 'idle' }) {
  // demoState: 'idle' | 'errors' | 'valid' | 'loading'
  const labels = ['Account', 'About you', 'Avatar'];

  const [showPw, setShowPw] = React.useState(false);

  // Inline validation, very light. Email regex, password ≥ 8, phone digits.
  const emailOk  = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(data.email || '');
  const passOk   = (data.password || '').length >= 8;
  const phoneOk  = (data.phone || '').replace(/\D/g, '').length >= 9;
  const nameOk   = (data.fullName || '').trim().split(' ').filter(Boolean).length >= 2;

  // Demo-state overrides — for the static state-showcase artboards.
  const forceErrors = demoState === 'errors';
  const forceValid  = demoState === 'valid';
  const loading     = demoState === 'loading';

  const stateFor = (ok, value) => {
    if (forceErrors && value) return 'error';
    if (forceValid) return 'valid';
    if (value && ok) return 'valid';
    if (value && !ok) return 'error';
    return 'idle';
  };

  const allValid = nameOk && emailOk && passOk && phoneOk;
  const continueEnabled = forceValid || (allValid && !loading);

  // Password meter
  const pwStrength = (() => {
    const p = data.password || '';
    let s = 0;
    if (p.length >= 8) s++;
    if (/[A-Z]/.test(p)) s++;
    if (/[0-9]/.test(p)) s++;
    if (/[^A-Za-z0-9]/.test(p)) s++;
    return s; // 0..4
  })();
  const pwLabels = ['Too short', 'Weak', 'Fair', 'Good', 'Strong'];
  const pwColors = [t.error, t.error, t.warning, t.primary, t.success];

  return (
    <FNRegChrome
      t={t} step={0} labels={labels} onBack={onBack}
      title="Create your account"
      subtitle="A few details and you're in. We'll never share your information.">
      <div style={{ padding: '24px 24px 0', display: 'flex', flexDirection: 'column', gap: 16 }}>

        <FNField
          t={t} label="Full name"
          placeholder="e.g. Rashid Karim"
          value={data.fullName}
          onChange={(v) => setData({ ...data, fullName: v })}
          state={stateFor(nameOk, data.fullName)}
          error={(forceErrors || (data.fullName && !nameOk)) ? 'Please enter your first and last name.' : null}
          leading={<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
            <circle cx="12" cy="8" r="4"/><path d="M4 21c1.5-4 5-6 8-6s6.5 2 8 6"/>
          </svg>}
        />

        <FNField
          t={t} label="Email address"
          placeholder="you@example.com"
          type="email"
          value={data.email}
          onChange={(v) => setData({ ...data, email: v })}
          state={stateFor(emailOk, data.email)}
          error={forceErrors ? 'That email is already registered.' :
                 (data.email && !emailOk ? 'Enter a valid email address.' : null)}
          leading={<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
            <rect x="3" y="5" width="18" height="14" rx="2"/><path d="M3 7l9 6 9-6"/>
          </svg>}
        />

        {/* Password — with visibility toggle + strength meter */}
        <div>
          <FNField
            t={t} label="Password"
            placeholder="At least 8 characters"
            type={showPw ? 'text' : 'password'}
            value={data.password}
            onChange={(v) => setData({ ...data, password: v })}
            state={stateFor(passOk, data.password)}
            leading={<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
              <rect x="4" y="11" width="16" height="10" rx="2"/><path d="M8 11V8a4 4 0 018 0v3"/>
            </svg>}
            trailing={
              <button onClick={() => setShowPw(!showPw)} style={{
                background: 'transparent', border: 'none', cursor: 'pointer',
                color: t.inkSoft, padding: 4, display: 'inline-flex',
              }}>
                {showPw ? (
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <path d="M1 1l22 22"/>
                    <path d="M9.9 5.1A10 10 0 0112 5c7 0 11 7 11 7a18 18 0 01-4 4.5"/>
                    <path d="M6.6 6.6A18 18 0 001 12s4 7 11 7c2 0 3.7-.5 5.2-1.3"/>
                    <path d="M14.1 14.1a3 3 0 11-4.2-4.2"/>
                  </svg>
                ) : (
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <path d="M1 12s4-7 11-7 11 7 11 7-4 7-11 7S1 12 1 12z"/>
                    <circle cx="12" cy="12" r="3"/>
                  </svg>
                )}
              </button>
            }
          />
          {/* Strength meter — only shows once user types */}
          {data.password && (
            <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 8 }}>
              <div style={{ flex: 1, display: 'flex', gap: 4 }}>
                {[0,1,2,3].map((i) => (
                  <div key={i} style={{
                    flex: 1, height: 4, borderRadius: 2,
                    background: i < pwStrength ? pwColors[pwStrength] : t.borderSoft,
                    transition: 'background .25s',
                  }} />
                ))}
              </div>
              <div style={{ fontSize: 11, fontWeight: 600, color: pwStrength >= 3 ? t.success : t.inkMid, minWidth: 56, textAlign: 'right' }}>
                {pwLabels[pwStrength]}
              </div>
            </div>
          )}
        </div>

        <FNField
          t={t} label="Phone number"
          placeholder="1712 345 678"
          type="tel"
          value={data.phone}
          onChange={(v) => setData({ ...data, phone: v })}
          state={stateFor(phoneOk, data.phone)}
          fixedPrefix="+880"
          hint="We'll send a one-time code to verify."
        />

        {/* Terms — small print, secondary */}
        <div style={{
          fontSize: 12, color: t.inkSoft, lineHeight: 1.5, marginTop: 4,
        }}>
          By continuing, you agree to FlatNest's{' '}
          <span style={{ color: t.primary, fontWeight: 600 }}>Terms</span> and{' '}
          <span style={{ color: t.primary, fontWeight: 600 }}>Privacy Policy</span>.
        </div>
      </div>

      <div style={{ flex: 1, minHeight: 16 }} />

      <div style={{ padding: '16px 24px 28px', background: t.bg }}>
        <button
          disabled={!continueEnabled}
          onClick={() => continueEnabled && onContinue && onContinue()}
          style={{
            width: '100%', height: 54, borderRadius: FN_RADIUS.button,
            background: continueEnabled ? t.primary : t.bgAlt,
            color: continueEnabled ? '#fff' : t.inkFaint,
            border: 'none', fontFamily: FN_FONT, fontSize: 16, fontWeight: 600,
            cursor: continueEnabled ? 'pointer' : 'not-allowed',
            display: 'inline-flex', alignItems: 'center', justifyContent: 'center', gap: 8,
            transition: 'background .15s, color .15s',
            letterSpacing: -0.1,
          }}>
          {loading ? (
            <>
              <span style={{
                width: 18, height: 18, borderRadius: 9,
                border: `2.5px solid ${withAlpha('#fff', 0.35)}`,
                borderTopColor: '#fff',
                animation: 'fn-spin 0.7s linear infinite',
              }} />
              Creating account…
            </>
          ) : <>Continue →</>}
        </button>
        <div style={{ textAlign: 'center', marginTop: 14, fontSize: 13, color: t.inkMid }}>
          Already have an account?{' '}
          <span style={{ color: t.primary, fontWeight: 600 }}>Sign in</span>
        </div>
      </div>
    </FNRegChrome>
  );
}

// ═══════════════════════════════════════════════════════════════
// STEP 2 — Personal details (role + DOB)
// ═══════════════════════════════════════════════════════════════
function FNRoleCard({ t, icon, title, desc, perks, selected, onClick }) {
  return (
    <button onClick={onClick} style={{
      textAlign: 'left', cursor: 'pointer',
      background: selected ? t.primarySoft : t.surface,
      border: `1.5px solid ${selected ? t.primary : t.borderSoft}`,
      borderRadius: FN_RADIUS.card,
      padding: 16, display: 'flex', gap: 14, alignItems: 'flex-start',
      width: '100%', fontFamily: FN_FONT,
      boxShadow: selected ? `0 6px 18px ${withAlpha(t.primary, 0.18)}` : t.shadow,
      transition: 'background .18s, border-color .18s, box-shadow .18s, transform .12s',
      position: 'relative',
    }}>
      <div style={{
        width: 44, height: 44, borderRadius: 12,
        background: selected ? t.primary : t.bgAlt,
        color: selected ? '#fff' : t.ink,
        display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
        flexShrink: 0, transition: 'background .18s, color .18s',
      }}>{icon}</div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{
          fontSize: 15, fontWeight: 700, color: selected ? t.primaryInk : t.ink,
          letterSpacing: -0.2,
        }}>{title}</div>
        <div style={{ fontSize: 12, color: t.inkMid, marginTop: 2, lineHeight: 1.45 }}>{desc}</div>
        {perks && (
          <div style={{ display: 'flex', flexWrap: 'wrap', gap: 6, marginTop: 10 }}>
            {perks.map((p) => (
              <span key={p} style={{
                fontSize: 10.5, fontWeight: 600, letterSpacing: 0.2,
                padding: '3px 8px', borderRadius: FN_RADIUS.chip,
                background: selected ? withAlpha(t.primary, 0.15) : t.bgAlt,
                color: selected ? t.primaryInk : t.inkMid,
                textTransform: 'uppercase',
              }}>{p}</span>
            ))}
          </div>
        )}
      </div>
      {/* radio dot */}
      <div style={{
        width: 22, height: 22, borderRadius: 11,
        border: `2px solid ${selected ? t.primary : t.inkFaint}`,
        background: selected ? t.primary : 'transparent',
        display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
        flexShrink: 0, transition: 'background .18s, border-color .18s',
      }}>
        {selected && (
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="3.4" strokeLinecap="round" strokeLinejoin="round">
            <path d="M20 6L9 17l-5-5"/>
          </svg>
        )}
      </div>
    </button>
  );
}

// Inline iOS-style 3-column wheel for DOB.
// We don't actually scroll — visual mock shows 5 rows with selected middle.
function FNDOBWheel({ t, value, onChange }) {
  const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  const day = value.day || 14;
  const month = value.month || 6;          // 1..12
  const year = value.year || 1998;

  const rangeAround = (center, span, fmt) => {
    const out = [];
    for (let i = -2; i <= 2; i++) out.push({ d: i, v: center + i, label: fmt(center + i) });
    return out;
  };
  const dayRows   = rangeAround(day, 2, (n) => String(n).padStart(2, '0'));
  const monthRows = rangeAround(month, 2, (n) => {
    const m = ((n - 1) % 12 + 12) % 12; return months[m];
  });
  const yearRows  = rangeAround(year, 2, (n) => String(n));

  const Col = ({ rows, onUp, onDn }) => (
    <div style={{
      flex: 1, position: 'relative', height: 180,
      display: 'flex', flexDirection: 'column', alignItems: 'center',
      overflow: 'hidden',
    }}>
      {rows.map((r) => {
        const dist = Math.abs(r.d);
        const opacity = dist === 0 ? 1 : dist === 1 ? 0.55 : 0.22;
        const fontSize = dist === 0 ? 22 : dist === 1 ? 18 : 15;
        const fontWeight = dist === 0 ? 700 : 500;
        return (
          <div key={r.d} style={{
            height: 36, display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontSize, fontWeight, color: dist === 0 ? t.primary : t.ink,
            opacity, letterSpacing: dist === 0 ? -0.2 : 0,
            transition: 'all .2s',
          }}>{r.label}</div>
        );
      })}
      {/* invisible up/down hit areas */}
      <button onClick={onUp} style={{
        position: 'absolute', top: 0, left: 0, right: 0, height: 60,
        background: 'transparent', border: 'none', cursor: 'pointer',
      }} aria-label="previous" />
      <button onClick={onDn} style={{
        position: 'absolute', bottom: 0, left: 0, right: 0, height: 60,
        background: 'transparent', border: 'none', cursor: 'pointer',
      }} aria-label="next" />
    </div>
  );

  const clamp = (n, min, max) => Math.max(min, Math.min(max, n));

  return (
    <div style={{
      position: 'relative', borderRadius: 14,
      background: t.surface, border: `1px solid ${t.borderSoft}`,
      padding: '10px 8px', overflow: 'hidden',
    }}>
      {/* highlight bar through middle */}
      <div style={{
        position: 'absolute', left: 8, right: 8, top: '50%', height: 36,
        transform: 'translateY(-50%)',
        background: t.primarySoft, borderRadius: 10, zIndex: 0,
      }} />
      {/* fade top + bottom */}
      <div style={{
        position: 'absolute', left: 0, right: 0, top: 0, height: 56,
        background: `linear-gradient(180deg, ${t.surface} 10%, ${withAlpha(t.surface, 0)} 100%)`,
        pointerEvents: 'none', zIndex: 2,
      }} />
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0, height: 56,
        background: `linear-gradient(0deg, ${t.surface} 10%, ${withAlpha(t.surface, 0)} 100%)`,
        pointerEvents: 'none', zIndex: 2,
      }} />
      <div style={{ display: 'flex', gap: 8, position: 'relative', zIndex: 1 }}>
        <Col rows={dayRows}
          onUp={() => onChange({ ...value, day: clamp(day - 1, 1, 31) })}
          onDn={() => onChange({ ...value, day: clamp(day + 1, 1, 31) })} />
        <Col rows={monthRows}
          onUp={() => onChange({ ...value, month: clamp(month - 1, 1, 12) })}
          onDn={() => onChange({ ...value, month: clamp(month + 1, 1, 12) })} />
        <Col rows={yearRows}
          onUp={() => onChange({ ...value, year: clamp(year - 1, 1920, 2010) })}
          onDn={() => onChange({ ...value, year: clamp(year + 1, 1920, 2010) })} />
      </div>
    </div>
  );
}

function FNRegStep2({ t, data, setData, onContinue, onBack }) {
  const labels = ['Account', 'About you', 'Avatar'];
  const role = data.role;
  const dob = data.dob || { day: 14, month: 6, year: 1998 };
  const months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
  const dobLabel = `${String(dob.day).padStart(2,'0')} ${months[dob.month - 1]} ${dob.year}`;
  const age = 2026 - dob.year;

  const canContinue = !!role;

  return (
    <FNRegChrome
      t={t} step={1} labels={labels} onBack={onBack}
      title="Tell us about you"
      subtitle="Pick the option that fits best — you can switch later.">
      <div style={{ padding: '24px 24px 0', display: 'flex', flexDirection: 'column', gap: 24 }}>

        {/* Role selector */}
        <div>
          <div style={{ fontSize: 12, fontWeight: 600, color: t.inkMid, marginBottom: 10, letterSpacing: 0.1 }}>
            I'M HERE TO
          </div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
            <FNRoleCard
              t={t} selected={role === 'renter'}
              onClick={() => setData({ ...data, role: 'renter' })}
              title="Find a flat"
              desc="Browse listings, save favorites, and message owners directly."
              perks={['Renter', 'Free forever']}
              icon={
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <circle cx="11" cy="11" r="7"/><path d="M20 20l-3.5-3.5"/>
                </svg>
              }
            />
            <FNRoleCard
              t={t} selected={role === 'owner'}
              onClick={() => setData({ ...data, role: 'owner' })}
              title="List my flat"
              desc="Post your property, manage inquiries, and rent it out faster."
              perks={['Owner', 'Verified listings']}
              icon={
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M3 11l9-7 9 7v9a2 2 0 01-2 2h-4v-7h-6v7H5a2 2 0 01-2-2v-9z"/>
                </svg>
              }
            />
          </div>
        </div>

        {/* DOB */}
        <div>
          <div style={{
            display: 'flex', alignItems: 'baseline', justifyContent: 'space-between',
            marginBottom: 10,
          }}>
            <div style={{ fontSize: 12, fontWeight: 600, color: t.inkMid, letterSpacing: 0.1 }}>
              DATE OF BIRTH
            </div>
            <div style={{ fontSize: 12, color: t.inkSoft }}>
              <span style={{ color: t.ink, fontWeight: 600 }}>{dobLabel}</span> · age {age}
            </div>
          </div>
          <FNDOBWheel t={t} value={dob} onChange={(v) => setData({ ...data, dob: v })} />
          <div style={{
            fontSize: 11, color: t.inkSoft, marginTop: 8, display: 'flex', alignItems: 'center', gap: 4,
          }}>
            <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round">
              <circle cx="12" cy="12" r="10"/><path d="M12 8v4M12 16h.01"/>
            </svg>
            You must be 18 or older to use FlatNest.
          </div>
        </div>
      </div>

      <div style={{ flex: 1, minHeight: 16 }} />

      <div style={{ padding: '16px 24px 28px', background: t.bg }}>
        <button
          disabled={!canContinue}
          onClick={() => canContinue && onContinue && onContinue()}
          style={{
            width: '100%', height: 54, borderRadius: FN_RADIUS.button,
            background: canContinue ? t.primary : t.bgAlt,
            color: canContinue ? '#fff' : t.inkFaint,
            border: 'none', fontFamily: FN_FONT, fontSize: 16, fontWeight: 600,
            cursor: canContinue ? 'pointer' : 'not-allowed',
            display: 'inline-flex', alignItems: 'center', justifyContent: 'center', gap: 8,
            transition: 'background .15s, color .15s',
          }}>
          Continue →
        </button>
      </div>
    </FNRegChrome>
  );
}

// ═══════════════════════════════════════════════════════════════
// STEP 3 — Avatar upload
// ═══════════════════════════════════════════════════════════════
// state: 'empty' | 'uploading' | 'uploaded' | 'error'
function FNAvatarUpload({ t, name, state, progress, image, error }) {
  const initials = (name || 'YN')
    .split(' ').filter(Boolean).slice(0, 2)
    .map(s => s[0].toUpperCase()).join('') || 'YN';
  const size = 168;
  return (
    <div style={{
      position: 'relative', width: size, height: size,
      margin: '0 auto', borderRadius: '50%',
    }}>
      {/* outer dashed ring when empty / progress ring when uploading */}
      {state === 'empty' && (
        <svg width={size} height={size} style={{ position: 'absolute', inset: 0 }}>
          <circle cx={size/2} cy={size/2} r={size/2 - 2}
            fill="none" stroke={t.inkFaint} strokeWidth="2" strokeDasharray="6 8"/>
        </svg>
      )}
      {state === 'uploading' && (
        <svg width={size} height={size} style={{ position: 'absolute', inset: 0, transform: 'rotate(-90deg)' }}>
          <circle cx={size/2} cy={size/2} r={size/2 - 3}
            fill="none" stroke={t.borderSoft} strokeWidth="4" />
          <circle cx={size/2} cy={size/2} r={size/2 - 3}
            fill="none" stroke={t.primary} strokeWidth="4" strokeLinecap="round"
            strokeDasharray={2 * Math.PI * (size/2 - 3)}
            strokeDashoffset={2 * Math.PI * (size/2 - 3) * (1 - (progress || 0) / 100)}
            style={{ transition: 'stroke-dashoffset .25s' }} />
        </svg>
      )}
      {state === 'uploaded' && (
        <svg width={size} height={size} style={{ position: 'absolute', inset: 0 }}>
          <circle cx={size/2} cy={size/2} r={size/2 - 3}
            fill="none" stroke={t.success} strokeWidth="3" />
        </svg>
      )}
      {state === 'error' && (
        <svg width={size} height={size} style={{ position: 'absolute', inset: 0 }}>
          <circle cx={size/2} cy={size/2} r={size/2 - 3}
            fill="none" stroke={t.error} strokeWidth="3" />
        </svg>
      )}

      {/* inner photo */}
      <div style={{
        position: 'absolute', inset: 12, borderRadius: '50%',
        background: image ? '#000' : t.primarySoft,
        overflow: 'hidden', display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>
        {image ? (
          <img src={image} alt="" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
        ) : (
          <span style={{
            fontSize: 52, fontWeight: 700, color: t.primaryInk, letterSpacing: -1,
          }}>{initials}</span>
        )}

        {/* upload progress overlay */}
        {state === 'uploading' && (
          <div style={{
            position: 'absolute', inset: 0,
            background: withAlpha('#000', image ? 0.45 : 0),
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            flexDirection: 'column', gap: 4,
            color: image ? '#fff' : t.primaryInk,
          }}>
            <div style={{ fontSize: 28, fontWeight: 700, letterSpacing: -0.5 }}>{Math.round(progress || 0)}%</div>
            <div style={{ fontSize: 11, opacity: 0.8, textTransform: 'uppercase', letterSpacing: 0.6 }}>
              Uploading
            </div>
          </div>
        )}
      </div>

      {/* small status badge bottom-right */}
      {(state === 'uploaded' || state === 'error') && (
        <div style={{
          position: 'absolute', bottom: 4, right: 4,
          width: 34, height: 34, borderRadius: 17,
          background: state === 'uploaded' ? t.success : t.error,
          border: `3px solid ${t.bg}`,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          animation: 'fn-reg-pop 360ms cubic-bezier(.34,1.56,.64,1)',
        }}>
          {state === 'uploaded' ? (
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="3.2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M20 6L9 17l-5-5"/>
            </svg>
          ) : (
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="3.2" strokeLinecap="round">
              <path d="M18 6L6 18M6 6l12 12"/>
            </svg>
          )}
        </div>
      )}
    </div>
  );
}

function FNRegStep3({ t, data, setData, onFinish, onBack, demoState }) {
  // demoState lets us pin a state for showcase artboards; otherwise local.
  const [localState, setLocalState] = React.useState('empty');
  const [progress, setProgress] = React.useState(0);
  const [image, setImage] = React.useState(null);
  const fileRef = React.useRef(null);
  const timerRef = React.useRef(null);

  const uploadState = demoState || localState;
  const liveProgress = demoState ? (demoState === 'uploading' ? 64 : (demoState === 'uploaded' ? 100 : 0)) : progress;
  const liveImage = demoState ? (demoState === 'uploaded' || demoState === 'uploading'
    ? data.avatarPreview || null : null) : image;

  const startUpload = (file) => {
    if (!file) {
      // Demo: pretend we picked a file even though there's none.
      setLocalState('uploading'); setProgress(0);
      let p = 0;
      timerRef.current = setInterval(() => {
        p += 9 + Math.random() * 6;
        if (p >= 100) { p = 100; clearInterval(timerRef.current); setLocalState('uploaded'); }
        setProgress(p);
      }, 140);
      return;
    }
    const reader = new FileReader();
    reader.onload = (e) => {
      setImage(e.target.result);
      setData({ ...data, avatarPreview: e.target.result });
    };
    reader.readAsDataURL(file);
    setLocalState('uploading'); setProgress(0);
    let p = 0;
    timerRef.current = setInterval(() => {
      p += 8 + Math.random() * 8;
      if (p >= 100) { p = 100; clearInterval(timerRef.current); setLocalState('uploaded'); }
      setProgress(p);
    }, 150);
  };

  const onPick = (e) => {
    const f = e.target.files && e.target.files[0];
    if (f) startUpload(f);
  };

  const remove = () => {
    if (timerRef.current) clearInterval(timerRef.current);
    setImage(null); setProgress(0); setLocalState('empty');
    setData({ ...data, avatarPreview: null });
  };

  React.useEffect(() => () => timerRef.current && clearInterval(timerRef.current), []);

  const labels = ['Account', 'About you', 'Avatar'];

  const isUploading = uploadState === 'uploading';
  const isUploaded = uploadState === 'uploaded';
  const isError = uploadState === 'error';

  return (
    <FNRegChrome
      t={t} step={2} labels={labels} onBack={onBack}
      title="Add a profile photo"
      subtitle="Helps owners and renters recognize you. You can skip and add it later.">

      <div style={{ padding: '32px 24px 0', textAlign: 'center' }}>
        <FNAvatarUpload
          t={t} name={data.fullName}
          state={uploadState} progress={liveProgress} image={liveImage}
        />

        {/* dynamic status text */}
        <div style={{
          marginTop: 20, fontSize: 14,
          color: isError ? t.error : isUploaded ? t.success : t.inkMid,
          fontWeight: isUploaded || isError ? 600 : 500,
          minHeight: 22,
        }}>
          {uploadState === 'empty' && 'No photo yet — square works best.'}
          {isUploading && `Uploading… ${Math.round(liveProgress)}% complete`}
          {isUploaded && '✓ Photo uploaded successfully'}
          {isError && 'Upload failed — try a different image.'}
        </div>

        {/* action area */}
        <div style={{ marginTop: 24, display: 'flex', flexDirection: 'column', gap: 12 }}>
          {(uploadState === 'empty' || isError) && (
            <>
              <input
                ref={fileRef} type="file" accept="image/*" capture="user"
                onChange={onPick} style={{ display: 'none' }}
              />
              <button onClick={() => fileRef.current ? fileRef.current.click() : startUpload()}
                style={primaryBtn(t)}>
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M23 19a2 2 0 01-2 2H3a2 2 0 01-2-2V8a2 2 0 012-2h4l2-3h6l2 3h4a2 2 0 012 2z"/>
                  <circle cx="12" cy="13" r="4"/>
                </svg>
                Take a photo
              </button>
              <button onClick={() => fileRef.current ? fileRef.current.click() : startUpload()}
                style={secondaryBtn(t)}>
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <rect x="3" y="3" width="18" height="18" rx="2"/>
                  <circle cx="9" cy="9" r="2"/>
                  <path d="M21 15l-5-5L5 21"/>
                </svg>
                Choose from gallery
              </button>
            </>
          )}

          {isUploading && (
            <>
              <div style={{
                display: 'flex', alignItems: 'center', gap: 12,
                padding: '12px 16px', borderRadius: FN_RADIUS.input,
                background: t.surface, border: `1px solid ${t.borderSoft}`,
                textAlign: 'left',
              }}>
                <div style={{
                  width: 36, height: 36, borderRadius: 8,
                  background: t.primarySoft, color: t.primary,
                  display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
                }}>
                  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <rect x="3" y="3" width="18" height="18" rx="2"/>
                    <circle cx="9" cy="9" r="2"/>
                    <path d="M21 15l-5-5L5 21"/>
                  </svg>
                </div>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ fontSize: 13, fontWeight: 600, color: t.ink, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
                    profile-photo.jpg
                  </div>
                  <div style={{ marginTop: 6, height: 4, borderRadius: 2, background: t.borderSoft, overflow: 'hidden' }}>
                    <div style={{
                      height: '100%', width: `${liveProgress}%`,
                      background: t.primary, borderRadius: 2,
                      transition: 'width .2s',
                    }} />
                  </div>
                </div>
                <button onClick={remove} style={iconLinkBtn(t)} aria-label="cancel">
                  <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke={t.inkSoft} strokeWidth="2" strokeLinecap="round">
                    <path d="M18 6L6 18M6 6l12 12"/>
                  </svg>
                </button>
              </div>
            </>
          )}

          {isUploaded && (
            <div style={{ display: 'flex', gap: 12 }}>
              <button onClick={() => { remove(); setTimeout(() => fileRef.current && fileRef.current.click(), 50); }}
                style={{ ...secondaryBtn(t), flex: 1 }}>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M3 12a9 9 0 0115-6.7L21 8"/><path d="M21 3v5h-5"/>
                  <path d="M21 12a9 9 0 01-15 6.7L3 16"/><path d="M3 21v-5h5"/>
                </svg>
                Change
              </button>
              <button onClick={remove} style={{ ...ghostBtn(t), flex: 1 }}>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M3 6h18M8 6V4a2 2 0 012-2h4a2 2 0 012 2v2M19 6l-1 14a2 2 0 01-2 2H8a2 2 0 01-2-2L5 6"/>
                </svg>
                Remove
              </button>
            </div>
          )}
        </div>
      </div>

      <div style={{ flex: 1, minHeight: 16 }} />

      <div style={{ padding: '16px 24px 28px', background: t.bg }}>
        <button
          disabled={isUploading}
          onClick={() => !isUploading && onFinish && onFinish()}
          style={{
            width: '100%', height: 54, borderRadius: FN_RADIUS.button,
            background: isUploading ? t.bgAlt : t.primary,
            color: isUploading ? t.inkFaint : '#fff',
            border: 'none', fontFamily: FN_FONT, fontSize: 16, fontWeight: 600,
            cursor: isUploading ? 'not-allowed' : 'pointer',
            display: 'inline-flex', alignItems: 'center', justifyContent: 'center', gap: 8,
            transition: 'background .15s, color .15s',
          }}>
          {isUploading
            ? <>Uploading photo…</>
            : <>Finish registration ✓</>}
        </button>
        {uploadState === 'empty' && (
          <button onClick={() => onFinish && onFinish()} style={{
            width: '100%', marginTop: 8, height: 44,
            background: 'transparent', border: 'none',
            color: t.inkMid, fontSize: 13, fontWeight: 600, fontFamily: FN_FONT,
            cursor: 'pointer',
          }}>
            Skip for now
          </button>
        )}
      </div>
    </FNRegChrome>
  );
}

// ═══════════════════════════════════════════════════════════════
// STEP 4 — Success screen
// ═══════════════════════════════════════════════════════════════
function FNRegSuccess({ t, data, onStart }) {
  const name = (data.fullName || '').split(' ')[0] || 'there';

  // Confetti — random dots radiating from center.
  const confetti = React.useMemo(() => {
    const colors = [t.primary, t.secondary, t.success, t.warning, t.primaryInk];
    return Array.from({ length: 16 }).map((_, i) => {
      const ang = (i / 16) * Math.PI * 2 + Math.random() * 0.4;
      const dist = 140 + Math.random() * 80;
      return {
        x: Math.cos(ang) * dist,
        y: Math.sin(ang) * dist - 40,
        c: colors[i % colors.length],
        d: Math.random() * 0.6,
        size: 6 + Math.random() * 6,
        rot: Math.random() * 360,
      };
    });
  }, [t.primary, t.secondary, t.success, t.warning, t.primaryInk]);

  return (
    <FNScreen t={t}>
      <div style={{ position: 'absolute', top: 64, right: 24, zIndex: 1 }}>
        {/* no chrome — just a subtle skip-to-home action is unneeded */}
      </div>
      <div style={{
        flex: 1, padding: '24px 24px 0',
        display: 'flex', flexDirection: 'column', alignItems: 'center',
        justifyContent: 'center', position: 'relative', overflow: 'hidden',
      }}>
        {/* decorative bg arcs */}
        <div style={{
          position: 'absolute', top: -120, left: -80, width: 280, height: 280,
          borderRadius: '50%', background: t.primarySoft, opacity: 0.7,
        }} />
        <div style={{
          position: 'absolute', bottom: -100, right: -80, width: 240, height: 240,
          borderRadius: '50%', background: withAlpha(t.secondary, 0.10),
        }} />

        {/* confetti */}
        {confetti.map((p, i) => (
          <div key={i} style={{
            position: 'absolute', width: p.size, height: p.size * 0.55,
            background: p.c, borderRadius: 2,
            left: '50%', top: '38%',
            '--dx': `${p.x}px`, '--dy': `${p.y}px`,
            animation: `fn-confetti-1 1.6s ${p.d}s cubic-bezier(.18,.7,.4,1) forwards`,
            transform: `rotate(${p.rot}deg)`,
          }} />
        ))}

        {/* main check */}
        <div style={{
          width: 112, height: 112, borderRadius: 56,
          background: t.primary,
          display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: `0 18px 40px ${withAlpha(t.primary, 0.35)}`,
          animation: 'fn-reg-pop 480ms cubic-bezier(.34,1.56,.64,1)',
          position: 'relative', zIndex: 1,
        }}>
          <svg width="56" height="56" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="3.2" strokeLinecap="round" strokeLinejoin="round">
            <path d="M20 6L9 17l-5-5"/>
          </svg>
        </div>

        <div style={{
          fontSize: 28, fontWeight: 700, color: t.ink,
          letterSpacing: -0.5, marginTop: 32, textAlign: 'center',
          position: 'relative', zIndex: 1,
        }}>
          You're all set, {name}!
        </div>
        <div style={{
          fontSize: 15, color: t.inkMid, marginTop: 10,
          textAlign: 'center', lineHeight: 1.55, maxWidth: 300,
          textWrap: 'pretty', position: 'relative', zIndex: 1,
        }}>
          Your FlatNest account is ready. Let's find you a place to call home.
        </div>

        {/* small profile card preview */}
        <div style={{
          marginTop: 28, display: 'flex', alignItems: 'center', gap: 12,
          background: t.surface, padding: '10px 14px 10px 10px',
          borderRadius: 999, boxShadow: t.shadow,
          position: 'relative', zIndex: 1,
        }}>
          {data.avatarPreview ? (
            <img src={data.avatarPreview} alt="" style={{
              width: 36, height: 36, borderRadius: 18, objectFit: 'cover',
            }} />
          ) : (
            <FNAvatar t={t} size={36} color={t.primarySoft}
              initials={(data.fullName || 'YN').split(' ').filter(Boolean).slice(0,2).map(s=>s[0].toUpperCase()).join('') || 'YN'} />
          )}
          <div style={{ fontSize: 13 }}>
            <div style={{ fontWeight: 700, color: t.ink }}>{data.fullName || 'Your name'}</div>
            <div style={{ color: t.inkMid, fontSize: 11 }}>
              {data.role === 'owner' ? 'Owner account' : 'Renter account'} · Verified
            </div>
          </div>
        </div>
      </div>

      <div style={{ padding: '16px 24px 28px', background: t.bg, position: 'relative', zIndex: 1 }}>
        <button onClick={onStart} style={primaryBtn(t, true)}>
          Start exploring →
        </button>
        <div style={{ textAlign: 'center', marginTop: 14, fontSize: 12, color: t.inkSoft }}>
          You can edit your profile anytime from settings.
        </div>
      </div>

      <style>{`
        @keyframes fn-reg-pop {
          0%   { opacity: 0; transform: scale(.7); }
          60%  { transform: scale(1.08); }
          100% { opacity: 1; transform: scale(1); }
        }
        @keyframes fn-confetti-1 {
          0%   { transform: translate(-50%, -50%) rotate(0); opacity: 0; }
          15%  { opacity: 1; }
          100% { transform: translate(calc(-50% + var(--dx)), calc(-50% + var(--dy))) rotate(540deg); opacity: 0; }
        }
      `}</style>
    </FNScreen>
  );
}

// ═══════════════════════════════════════════════════════════════
// Shared button presets (used inside Step 3 + Success)
// ═══════════════════════════════════════════════════════════════
function primaryBtn(t, full = true) {
  return {
    width: full ? '100%' : 'auto',
    height: 54, borderRadius: FN_RADIUS.button,
    background: t.primary, color: '#fff', border: 'none',
    fontFamily: FN_FONT, fontSize: 16, fontWeight: 600,
    cursor: 'pointer', letterSpacing: -0.1,
    display: 'inline-flex', alignItems: 'center', justifyContent: 'center', gap: 8,
    boxShadow: `0 8px 18px ${withAlpha(t.primary, 0.28)}`,
  };
}
function secondaryBtn(t) {
  return {
    width: '100%', height: 50, borderRadius: FN_RADIUS.button,
    background: t.surface, color: t.ink,
    border: `1px solid ${t.border}`,
    fontFamily: FN_FONT, fontSize: 15, fontWeight: 600,
    cursor: 'pointer',
    display: 'inline-flex', alignItems: 'center', justifyContent: 'center', gap: 8,
  };
}
function ghostBtn(t) {
  return {
    width: '100%', height: 50, borderRadius: FN_RADIUS.button,
    background: 'transparent', color: t.error,
    border: `1px solid ${withAlpha(t.error, 0.3)}`,
    fontFamily: FN_FONT, fontSize: 15, fontWeight: 600,
    cursor: 'pointer',
    display: 'inline-flex', alignItems: 'center', justifyContent: 'center', gap: 8,
  };
}
function iconLinkBtn(t) {
  return {
    width: 32, height: 32, borderRadius: 16,
    background: t.bgAlt, border: 'none',
    cursor: 'pointer', flexShrink: 0,
    display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
  };
}

// ═══════════════════════════════════════════════════════════════
// Interactive flow wrapper — Step 1 → 2 → 3 → Success
// ═══════════════════════════════════════════════════════════════
function FNRegisterFlow({ t, onClose }) {
  const [step, setStep] = React.useState(0);
  const [data, setData] = React.useState({
    fullName: '', email: '', password: '', phone: '',
    role: null, dob: { day: 14, month: 6, year: 1998 },
    avatarPreview: null,
  });

  const next = () => setStep((s) => Math.min(s + 1, 3));
  const back = () => step === 0 ? (onClose && onClose()) : setStep((s) => s - 1);

  return (
    <>
      {step === 0 && <FNRegStep1   t={t} data={data} setData={setData} onContinue={next} onBack={back} />}
      {step === 1 && <FNRegStep2   t={t} data={data} setData={setData} onContinue={next} onBack={back} />}
      {step === 2 && <FNRegStep3   t={t} data={data} setData={setData} onFinish={next}   onBack={back} />}
      {step === 3 && <FNRegSuccess t={t} data={data} onStart={() => setStep(0)} />}
    </>
  );
}

Object.assign(window, {
  FNField, FNRegStepper, FNRegChrome,
  FNRegStep1, FNRegStep2, FNRegStep3, FNRegSuccess,
  FNRegisterFlow, FNAvatarUpload, FNRoleCard, FNDOBWheel,
});
