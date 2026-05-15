// screens-auth.jsx — Splash, Onboarding, Login, OTP verification

function FNSplash({ t }) {
  return (
    <FNScreen t={t} bg={t.primary} statusDark>
      <div style={{
        flex: 1, display: 'flex', flexDirection: 'column',
        alignItems: 'center', justifyContent: 'center', gap: 24,
        color: '#fff', position: 'relative',
      }}>
        {/* Decorative arcs */}
        <div style={{ position: 'absolute', top: -120, left: -80, width: 280, height: 280, borderRadius: '50%', background: withAlpha('#fff', 0.06) }} />
        <div style={{ position: 'absolute', bottom: -100, right: -80, width: 240, height: 240, borderRadius: '50%', background: withAlpha('#fff', 0.06) }} />

        <div style={{
          width: 96, height: 96, borderRadius: 24,
          background: withAlpha('#fff', 0.16),
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          backdropFilter: 'blur(20px)',
        }}>
          <FNLogo size={56} />
        </div>
        <div style={{ textAlign: 'center' }}>
          <div style={{ fontSize: 34, fontWeight: 700, letterSpacing: -0.6 }}>FlatNest</div>
          <div style={{ fontSize: 14, opacity: 0.8, marginTop: 6, letterSpacing: 0.4 }}>FIND · LIST · MOVE IN</div>
        </div>
      </div>
      {/* loading dots */}
      <div style={{ display: 'flex', justifyContent: 'center', paddingBottom: 56, gap: 6 }}>
        {[0, 1, 2].map(i => (
          <div key={i} style={{
            width: 6, height: 6, borderRadius: 3,
            background: withAlpha('#fff', i === 1 ? 0.9 : 0.4),
          }} />
        ))}
      </div>
    </FNScreen>
  );
}

// Onboarding — three illustrated slides, dots, Skip/Next
function FNOnboarding({ t }) {
  const [step, setStep] = React.useState(0);
  const slides = [
    {
      tint: '#FFE0CC', icon: '🔍',
      title: 'Find your next flat',
      body: 'Browse trusted listings from verified owners across Dhaka. No brokers, no hidden fees.',
    },
    {
      tint: '#D4E7DA', icon: '📸',
      title: 'List your flat in minutes',
      body: 'Upload photos, set your price, and reach thousands of renters looking for a home like yours.',
    },
    {
      tint: '#D7DFFC', icon: '💬',
      title: 'Chat & move in',
      body: 'Message owners directly, schedule a visit, and finalize without leaving the app.',
    },
  ];
  const s = slides[step];
  return (
    <FNScreen t={t}>
      {/* illustration block — fills upper half */}
      <div style={{ height: 440, position: 'relative', background: s.tint, overflow: 'hidden' }}>
        <FNPhoto tint={s.tint} label="Onboarding illustration" style={{ width: '100%', height: '100%' }} />
        {/* big emoji as a placeholder for the actual illustration */}
        <div style={{
          position: 'absolute', inset: 0, display: 'flex',
          alignItems: 'center', justifyContent: 'center',
          fontSize: 120, opacity: 0.9,
        }}>{s.icon}</div>
        {/* skip */}
        <button style={{
          position: 'absolute', top: 64, right: 16,
          background: 'transparent', border: 'none', color: t.ink,
          fontSize: 14, fontWeight: 600, fontFamily: FN_FONT, cursor: 'pointer',
        }}>Skip</button>
      </div>
      <div style={{ flex: 1, padding: '32px 24px 0', display: 'flex', flexDirection: 'column' }}>
        <div style={{ fontSize: 24, fontWeight: 700, color: t.ink, letterSpacing: -0.3, textWrap: 'balance' }}>{s.title}</div>
        <div style={{ fontSize: 14, color: t.inkMid, marginTop: 10, lineHeight: 1.55, textWrap: 'pretty' }}>{s.body}</div>
        <div style={{ flex: 1 }} />
        {/* dots + next */}
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', paddingBottom: 32 }}>
          <div style={{ display: 'flex', gap: 6 }}>
            {slides.map((_, i) => (
              <div key={i} style={{
                width: i === step ? 22 : 6, height: 6, borderRadius: 3,
                background: i === step ? t.primary : t.inkFaint,
                transition: 'width .2s, background .2s',
              }} />
            ))}
          </div>
          <FNButton t={t} onClick={() => setStep((step + 1) % slides.length)} size="md"
            style={{ paddingLeft: 22, paddingRight: 22 }}>
            {step === slides.length - 1 ? 'Get started' : 'Next'} →
          </FNButton>
        </div>
      </div>
    </FNScreen>
  );
}

// Login — email/password + social
function FNLogin({ t }) {
  const [email, setEmail] = React.useState('rashid.k@example.com');
  const [password, setPassword] = React.useState('••••••••');
  const [showPw, setShowPw] = React.useState(false);
  const inp = {
    height: 52, width: '100%', borderRadius: FN_RADIUS.input,
    background: t.surface, border: `1px solid ${t.borderSoft}`,
    padding: '0 16px', fontSize: 15, color: t.ink, fontFamily: FN_FONT, outline: 'none',
  };
  return (
    <FNScreen t={t}>
      <div style={{ padding: '72px 24px 0' }}>
        <div style={{
          width: 56, height: 56, borderRadius: 14, background: t.primary,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}><FNLogo size={32} /></div>
        <div style={{ fontSize: 28, fontWeight: 700, color: t.ink, letterSpacing: -0.5, marginTop: 24 }}>Welcome back</div>
        <div style={{ fontSize: 14, color: t.inkMid, marginTop: 6 }}>Sign in to find or list your next flat.</div>

        <div style={{ display: 'flex', flexDirection: 'column', gap: 12, marginTop: 32 }}>
          <div>
            <div style={{ fontSize: 12, fontWeight: 600, color: t.inkMid, marginBottom: 6 }}>Email</div>
            <input value={email} onChange={(e) => setEmail(e.target.value)} style={inp} />
          </div>
          <div>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', marginBottom: 6 }}>
              <div style={{ fontSize: 12, fontWeight: 600, color: t.inkMid }}>Password</div>
              <a style={{ fontSize: 12, color: t.primary, fontWeight: 600 }}>Forgot?</a>
            </div>
            <div style={{ position: 'relative' }}>
              <input type={showPw ? 'text' : 'password'} value={password} onChange={(e) => setPassword(e.target.value)}
                style={{ ...inp, paddingRight: 56 }} />
              <button onClick={() => setShowPw(!showPw)} style={{
                position: 'absolute', right: 12, top: '50%', transform: 'translateY(-50%)',
                background: 'transparent', border: 'none', fontSize: 12, fontWeight: 600,
                color: t.primary, cursor: 'pointer',
              }}>{showPw ? 'Hide' : 'Show'}</button>
            </div>
          </div>
        </div>

        <div style={{ marginTop: 24 }}><FNButton t={t} full size="lg">Sign in</FNButton></div>

        {/* divider */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 12, margin: '24px 0' }}>
          <div style={{ flex: 1, height: 1, background: t.borderSoft }} />
          <div style={{ fontSize: 11, color: t.inkSoft, textTransform: 'uppercase', letterSpacing: 0.6 }}>or continue with</div>
          <div style={{ flex: 1, height: 1, background: t.borderSoft }} />
        </div>

        <div style={{ display: 'flex', gap: 12 }}>
          {['Google', 'Apple', 'Phone'].map((l) => (
            <FNButton key={l} t={t} kind="outline" full size="md" style={{ fontSize: 13 }}>{l}</FNButton>
          ))}
        </div>
      </div>
      <div style={{ flex: 1 }} />
      <div style={{ textAlign: 'center', padding: '24px 0 40px', fontSize: 13, color: t.inkMid }}>
        New here? <span style={{ color: t.primary, fontWeight: 600 }}>Create an account</span>
      </div>
    </FNScreen>
  );
}

// OTP — 6-digit code input with autofocus visual
function FNVerify({ t }) {
  const code = ['7', '3', '1', '8', '', ''];
  return (
    <FNScreen t={t}>
      <div style={{ padding: '72px 24px 0' }}>
        <div style={{
          width: 56, height: 56, borderRadius: 14, background: t.primarySoft,
          display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 28,
        }}>📩</div>
        <div style={{ fontSize: 26, fontWeight: 700, color: t.ink, letterSpacing: -0.4, marginTop: 24 }}>Verify your number</div>
        <div style={{ fontSize: 14, color: t.inkMid, marginTop: 6, lineHeight: 1.5 }}>
          We sent a 6-digit code to <b style={{ color: t.ink }}>+880 1712 ••• 482</b>.
        </div>

        <div style={{ display: 'flex', gap: 10, marginTop: 32, justifyContent: 'space-between' }}>
          {code.map((d, i) => (
            <div key={i} style={{
              width: 48, height: 56, borderRadius: 12,
              background: t.surface,
              border: `1.5px solid ${i === 4 ? t.primary : t.borderSoft}`,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              fontSize: 24, fontWeight: 700, color: t.ink,
              boxShadow: i === 4 ? `0 0 0 4px ${withAlpha(t.primary, 0.12)}` : 'none',
            }}>
              {d || (i === 4 && <div style={{
                width: 2, height: 22, background: t.primary,
                animation: 'fn-caret 1s steps(2) infinite',
              }} />)}
            </div>
          ))}
        </div>

        <div style={{ fontSize: 13, color: t.inkMid, marginTop: 20, textAlign: 'center' }}>
          Didn't get it? <span style={{ color: t.primary, fontWeight: 600 }}>Resend in 0:42</span>
        </div>

        <div style={{ marginTop: 32 }}><FNButton t={t} full size="lg">Verify & continue</FNButton></div>
      </div>
      <style>{`@keyframes fn-caret { 50% { opacity: 0; } }`}</style>
    </FNScreen>
  );
}

Object.assign(window, { FNSplash, FNOnboarding, FNLogin, FNVerify });
