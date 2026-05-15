// app.jsx — main composition: DesignCanvas of FlatNest screens + Tweaks.

const FN_DEFAULTS = /*EDITMODE-BEGIN*/{
  "dark": false,
  "accent": "#1A6B72"
}/*EDITMODE-END*/;

// Wrap a screen in an iOS frame at our canvas's standard size.
function FNArtboard({ children, t, dark = false }) {
  // 390x780 is a touch shorter than IOSDevice's default 874 to fit nicely
  // in the canvas; we want phones, not minivans.
  return (
    <div style={{ width: 390, height: 780, display: 'flex',
      alignItems: 'center', justifyContent: 'center',
      background: '#f0eee9',
    }}>
      <IOSDevice width={390} height={780} dark={dark}>
        {children}
      </IOSDevice>
    </div>
  );
}

// Self-contained mini-flow: Home → ListingDetail → Chat
function FNRenterFlow({ t }) {
  const [view, setView] = React.useState('home');
  const [listing, setListing] = React.useState(FN_LISTINGS[1]);
  const [chat, setChat] = React.useState(FN_CHATS[0]);
  const [saved, setSaved] = React.useState({ l1: true, l3: true });
  const [filtersOpen, setFiltersOpen] = React.useState(false);
  const toggleSave = (id) => setSaved((s) => ({ ...s, [id]: !s[id] }));

  return (
    <>
      {view === 'home' && (
        <FNHome t={t}
          onOpenListing={(l) => { setListing(l); setView('detail'); }}
          onOpenFilters={() => setFiltersOpen(true)}
          saved={saved} toggleSave={toggleSave} />
      )}
      {view === 'detail' && (
        <FNListingDetail t={t} listing={listing}
          onBack={() => setView('home')}
          saved={!!saved[listing.id]} onToggleSave={() => toggleSave(listing.id)}
          onOpenChat={() => { setChat(FN_CHATS[0]); setView('chat'); }} />
      )}
      {view === 'chat' && (
        <FNChatDetail t={t} chat={chat} onBack={() => setView('detail')} />
      )}
      <FNBottomSheet open={filtersOpen} onClose={() => setFiltersOpen(false)} t={t}>
        <FNFiltersSheet t={t} onClose={() => setFiltersOpen(false)} />
      </FNBottomSheet>
    </>
  );
}

function FNOwnerFlow({ t }) {
  const [view, setView] = React.useState('dash');
  return (
    <>
      {view === 'dash' && (
        <FNOwnerDashboard t={t}
          onCreate={() => setView('create')}
          onOpenListings={() => setView('listings')} />
      )}
      {view === 'create' && <FNCreateListing t={t} onBack={() => setView('dash')} />}
      {view === 'listings' && <FNMyListings t={t} onOpenListing={() => {}} />}
    </>
  );
}

function App() {
  const [tweaks, setTweak] = useTweaks(FN_DEFAULTS);
  const t = fnTheme({ dark: tweaks.dark, accent: tweaks.accent });

  // Inject base font + scrollbar reset
  React.useEffect(() => {
    const id = 'fn-base';
    if (document.getElementById(id)) return;
    const s = document.createElement('style');
    s.id = id;
    s.textContent = `
      *, *::before, *::after { box-sizing: border-box; }
      ::-webkit-scrollbar { display: none; }
      input, textarea, button { font-family: ${FN_FONT}; }
    `;
    document.head.appendChild(s);
  }, []);

  return (
    <>
      <DesignCanvas>
        {/* ───────── Auth ───────── */}
        <DCSection id="auth" title="Auth flow" subtitle="Splash → Onboarding → Sign in → Verify">
          <DCArtboard id="splash" label="Splash" width={390} height={780}>
            <FNArtboard t={t} dark><FNSplash t={t} /></FNArtboard>
          </DCArtboard>
          <DCArtboard id="onboarding" label="Onboarding · 3 slides" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}><FNOnboarding t={t} /></FNArtboard>
          </DCArtboard>
          <DCArtboard id="login" label="Sign in" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}><FNLogin t={t} /></FNArtboard>
          </DCArtboard>
          <DCArtboard id="verify" label="OTP verify" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}><FNVerify t={t} /></FNArtboard>
          </DCArtboard>
        </DCSection>

        {/* ───────── Register flow ───────── */}
        <DCSection id="register" title="Register" subtitle="3-step sign-up · Basic info → Personal → Avatar → Success">
          <DCArtboard id="reg-flow" label="Full flow (live · click Continue)" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}><FNRegisterFlow t={t} /></FNArtboard>
          </DCArtboard>
          <DCArtboard id="reg-1-empty" label="Step 1 · empty" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}>
              <FNRegStep1 t={t}
                data={{ fullName: '', email: '', password: '', phone: '' }}
                setData={() => {}} onContinue={() => {}} onBack={() => {}} />
            </FNArtboard>
          </DCArtboard>
          <DCArtboard id="reg-1-errors" label="Step 1 · validation errors" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}>
              <FNRegStep1 t={t}
                data={{ fullName: 'R', email: 'rashid@', password: '123', phone: '17' }}
                setData={() => {}} onContinue={() => {}} onBack={() => {}}
                demoState="errors" />
            </FNArtboard>
          </DCArtboard>
          <DCArtboard id="reg-1-valid" label="Step 1 · all valid · loading" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}>
              <FNRegStep1 t={t}
                data={{ fullName: 'Rashid Karim', email: 'rashid.k@example.com', password: 'Bashundh@ra2024', phone: '1712345678' }}
                setData={() => {}} onContinue={() => {}} onBack={() => {}}
                demoState="loading" />
            </FNArtboard>
          </DCArtboard>
          <DCArtboard id="reg-2" label="Step 2 · role + DOB" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}>
              <FNRegStep2 t={t}
                data={{ fullName: 'Rashid Karim', role: 'renter', dob: { day: 14, month: 6, year: 1998 } }}
                setData={() => {}} onContinue={() => {}} onBack={() => {}} />
            </FNArtboard>
          </DCArtboard>
          <DCArtboard id="reg-3-empty" label="Step 3 · empty" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}>
              <FNRegStep3 t={t}
                data={{ fullName: 'Rashid Karim', role: 'renter' }}
                setData={() => {}} onFinish={() => {}} onBack={() => {}}
                demoState="empty" />
            </FNArtboard>
          </DCArtboard>
          <DCArtboard id="reg-3-uploading" label="Step 3 · uploading" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}>
              <FNRegStep3 t={t}
                data={{ fullName: 'Rashid Karim', role: 'renter' }}
                setData={() => {}} onFinish={() => {}} onBack={() => {}}
                demoState="uploading" />
            </FNArtboard>
          </DCArtboard>
          <DCArtboard id="reg-3-done" label="Step 3 · uploaded" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}>
              <FNRegStep3 t={t}
                data={{ fullName: 'Rashid Karim', role: 'renter' }}
                setData={() => {}} onFinish={() => {}} onBack={() => {}}
                demoState="uploaded" />
            </FNArtboard>
          </DCArtboard>
          <DCArtboard id="reg-3-error" label="Step 3 · upload error" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}>
              <FNRegStep3 t={t}
                data={{ fullName: 'Rashid Karim', role: 'renter' }}
                setData={() => {}} onFinish={() => {}} onBack={() => {}}
                demoState="error" />
            </FNArtboard>
          </DCArtboard>
          <DCArtboard id="reg-success" label="Success · Start exploring" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}>
              <FNRegSuccess t={t}
                data={{ fullName: 'Rashid Karim', role: 'renter' }}
                onStart={() => {}} />
            </FNArtboard>
          </DCArtboard>
        </DCSection>

        {/* ───────── Renter flow (interactive stack) ───────── */}
        <DCSection id="renter" title="Renter" subtitle="Discover → details → message owner · click to interact">
          <DCArtboard id="renter-flow" label="Home → Detail → Chat (live)" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}><FNRenterFlow t={t} /></FNArtboard>
          </DCArtboard>
          <DCArtboard id="map" label="Map view" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}><FNMap t={t} /></FNArtboard>
          </DCArtboard>
          <DCArtboard id="wishlist" label="Saved flats" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}>
              <FNWishlistDemo t={t} />
            </FNArtboard>
          </DCArtboard>
          <DCArtboard id="filters" label="Filters bottom sheet" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}>
              <FNFiltersDemo t={t} />
            </FNArtboard>
          </DCArtboard>
        </DCSection>

        {/* ───────── Chat ───────── */}
        <DCSection id="chat" title="Conversations" subtitle="List → per-listing thread">
          <DCArtboard id="chat-list" label="Chat list" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}>
              <FNChatList t={t} onOpen={() => {}} tabs={fnRenterTabs(t)} active="messages" />
            </FNArtboard>
          </DCArtboard>
          <DCArtboard id="chat-detail" label="Chat with Tahmid" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}>
              <FNChatDetail t={t} chat={FN_CHATS[0]} onBack={() => {}} />
            </FNArtboard>
          </DCArtboard>
        </DCSection>

        {/* ───────── Owner flow ───────── */}
        <DCSection id="owner" title="Owner" subtitle="Manage listings + post new ones">
          <DCArtboard id="owner-flow" label="Dashboard → Post → My listings (live)" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}><FNOwnerFlow t={t} /></FNArtboard>
          </DCArtboard>
          <DCArtboard id="my-listings" label="My listings · status badges" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}><FNMyListings t={t} onOpenListing={() => {}} /></FNArtboard>
          </DCArtboard>
          <DCArtboard id="post-detail" label="Post · step 1 of 4" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}><FNCreateListing t={t} onBack={() => {}} /></FNArtboard>
          </DCArtboard>
        </DCSection>

        {/* ───────── Shared ───────── */}
        <DCSection id="shared" title="Shared" subtitle="Profile + Notifications">
          <DCArtboard id="profile-renter" label="Renter profile" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}><FNProfile t={t} role="renter" tabs={fnRenterTabs(t)} /></FNArtboard>
          </DCArtboard>
          <DCArtboard id="profile-owner" label="Owner profile" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}><FNProfile t={t} role="owner" tabs={fnOwnerTabs(t)} /></FNArtboard>
          </DCArtboard>
          <DCArtboard id="notifications" label="Notifications" width={390} height={780}>
            <FNArtboard t={t} dark={t.dark}><FNNotifications t={t} onBack={() => {}} /></FNArtboard>
          </DCArtboard>
        </DCSection>

        <DCPostIt top={120} left={40} rotate={-3}>
          Tap any phone to open it fullscreen — the renter & owner artboards are fully interactive.
        </DCPostIt>
      </DesignCanvas>

      <TweaksPanel title="Tweaks">
        <TweakSection label="Theme" />
        <TweakToggle label="Dark mode" value={tweaks.dark}
          onChange={(v) => setTweak('dark', v)} />
        <TweakColor label="Accent" value={tweaks.accent}
          options={['#1A6B72', '#4F46E5', '#1F7A4E', '#6A2B7A', '#1C1C1E']}
          onChange={(v) => setTweak('accent', v)} />
      </TweaksPanel>
    </>
  );
}

// Stand-in for screens that need a controlled saved-state
function FNWishlistDemo({ t }) {
  const [saved, setSaved] = React.useState({ l1: true, l3: true, l5: true });
  return <FNWishlist t={t} saved={saved} toggleSave={(id) => setSaved((s) => ({ ...s, [id]: !s[id] }))} onOpenListing={() => {}} />;
}
function FNFiltersDemo({ t }) {
  return (
    <div style={{ width: '100%', height: '100%', position: 'relative', background: t.bg }}>
      {/* dim background that suggests Home behind it */}
      <FNHome t={t} onOpenListing={() => {}} onOpenFilters={() => {}} saved={{ l1: true }} toggleSave={() => {}} />
      <div style={{ position: 'absolute', inset: 0, background: 'rgba(15,20,30,0.45)', zIndex: 75 }} />
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0, zIndex: 80,
        height: 600, background: t.surface,
        borderTopLeftRadius: FN_RADIUS.sheet, borderTopRightRadius: FN_RADIUS.sheet,
        display: 'flex', flexDirection: 'column',
        boxShadow: '0 -8px 24px rgba(0,0,0,0.15)',
      }}>
        <div style={{ display: 'flex', justifyContent: 'center', padding: '8px 0 4px' }}>
          <div style={{ width: 40, height: 4, borderRadius: 2, background: t.inkFaint }} />
        </div>
        <FNFiltersSheet t={t} onClose={() => {}} />
      </div>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<App />);
