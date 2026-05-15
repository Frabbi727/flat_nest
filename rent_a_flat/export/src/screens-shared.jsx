// screens-shared.jsx — Profile, Notifications

function FNProfile({ t, role, tabs }) {
  const user = role === 'owner'
    ? { name: 'Tahmid R.', sub: 'Owner · Banani', initials: 'TR', flag: '🇧🇩' }
    : { name: 'Rashid K.', sub: 'Renter · Looking in Banani', initials: 'RK', flag: '🇧🇩' };

  const sections = role === 'owner' ? [
    [
      { ic: '🏠', label: 'My listings', detail: '4' },
      { ic: '📊', label: 'Performance & analytics' },
      { ic: '💰', label: 'Payouts & invoices' },
    ],
    [
      { ic: '🛡', label: 'Verification', detail: 'Verified', kind: 'success' },
      { ic: '🔔', label: 'Notifications' },
      { ic: '🌐', label: 'Language', detail: 'English' },
    ],
    [
      { ic: '❓', label: 'Help & support' },
      { ic: '📄', label: 'Terms & privacy' },
    ],
  ] : [
    [
      { ic: '❤️', label: 'Saved flats', detail: '3' },
      { ic: '📝', label: 'My visits', detail: '1 scheduled' },
      { ic: '⭐', label: 'Reviews I left' },
    ],
    [
      { ic: '🛡', label: 'Identity verification', detail: 'Verified', kind: 'success' },
      { ic: '🔔', label: 'Notifications' },
      { ic: '🌐', label: 'Language', detail: 'English' },
    ],
    [
      { ic: '❓', label: 'Help & support' },
      { ic: '📄', label: 'Terms & privacy' },
    ],
  ];

  return (
    <FNScreen t={t}>
      <FNTopBar t={t} title="Profile" right={
        <FNIconButton t={t}>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke={t.ink} strokeWidth="2" strokeLinecap="round">
            <circle cx="12" cy="12" r="3"/><path d="M19 12a7 7 0 00-.1-1l2-1.6-2-3.4-2.4 1a7 7 0 00-1.7-1L14 3.5h-4l-.8 2.5a7 7 0 00-1.7 1l-2.4-1-2 3.4 2 1.6a7 7 0 00-.1 1c0 .3 0 .7.1 1L3.1 14l2 3.4 2.4-1a7 7 0 001.7 1L10 20.5h4l.8-2.5a7 7 0 001.7-1l2.4 1 2-3.4-2-1.6c.1-.3.1-.7.1-1z"/>
          </svg>
        </FNIconButton>
      } />
      <div style={{ flex: 1, overflow: 'auto', paddingBottom: 100 }}>
        {/* Header card */}
        <div style={{ padding: '0 20px' }}>
          <div style={{
            padding: 18, borderRadius: FN_RADIUS.card,
            background: t.surface, border: `1px solid ${t.borderSoft}`, boxShadow: t.shadow,
            display: 'flex', alignItems: 'center', gap: 14,
          }}>
            <div style={{ position: 'relative' }}>
              <FNAvatar initials={user.initials} size={62} color={t.primarySoft} t={t} />
              <div style={{
                position: 'absolute', bottom: -2, right: -2, width: 22, height: 22, borderRadius: 11,
                background: t.surface, border: `2px solid ${t.surface}`,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                boxShadow: '0 2px 4px rgba(0,0,0,0.1)',
              }}>
                <svg width="12" height="12" viewBox="0 0 24 24" fill={t.primary}>
                  <path d="M12 2l3 2.5 4-.5.5 4L22 11l-2.5 3 .5 4-4-.5L12 22l-3-2.5-4 .5-.5-4L2 13l2.5-3-.5-4 4 .5z"/>
                  <path d="M8 12l3 3 6-6" stroke="#fff" strokeWidth="2.2" fill="none" strokeLinecap="round" strokeLinejoin="round"/>
                </svg>
              </div>
            </div>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 18, fontWeight: 700, color: t.ink, letterSpacing: -0.2 }}>{user.name}</div>
              <div style={{ fontSize: 13, color: t.inkMid, marginTop: 2 }}>{user.sub}</div>
              <div style={{ marginTop: 6 }}><FNBadge t={t} kind="primary">{user.flag} Member since 2024</FNBadge></div>
            </div>
          </div>

          {/* role / switch */}
          {role === 'renter' && (
            <div style={{
              marginTop: 12, padding: 14, borderRadius: FN_RADIUS.card,
              background: t.primarySoft,
              display: 'flex', alignItems: 'center', gap: 12,
            }}>
              <div style={{ fontSize: 24 }}>🏠</div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 13, fontWeight: 700, color: t.primaryInk }}>Have a flat to rent out?</div>
                <div style={{ fontSize: 11, color: t.primaryInk, opacity: 0.7, marginTop: 2 }}>Switch to owner mode and list it in minutes.</div>
              </div>
              <FNButton t={t} kind="primary" size="sm">Switch</FNButton>
            </div>
          )}
        </div>

        {/* Settings sections */}
        {sections.map((sec, si) => (
          <div key={si} style={{ marginTop: 24, padding: '0 20px' }}>
            <div style={{
              background: t.surface, borderRadius: FN_RADIUS.card,
              border: `1px solid ${t.borderSoft}`, overflow: 'hidden',
            }}>
              {sec.map((r, ri) => (
                <div key={ri} style={{
                  display: 'flex', alignItems: 'center', gap: 12,
                  padding: '14px 16px',
                  borderTop: ri > 0 ? `1px solid ${t.borderSoft}` : 'none',
                }}>
                  <div style={{ fontSize: 18 }}>{r.ic}</div>
                  <div style={{ flex: 1, fontSize: 14, fontWeight: 500, color: t.ink }}>{r.label}</div>
                  {r.detail && (
                    r.kind === 'success'
                      ? <FNBadge t={t} kind="active">{r.detail}</FNBadge>
                      : <div style={{ fontSize: 13, color: t.inkSoft }}>{r.detail}</div>
                  )}
                  <svg width="6" height="10" viewBox="0 0 8 14"><path d="M1 1l6 6-6 6" stroke={t.inkFaint} strokeWidth="2" fill="none" strokeLinecap="round"/></svg>
                </div>
              ))}
            </div>
          </div>
        ))}

        <div style={{ padding: '24px 20px' }}>
          <FNButton t={t} kind="outline" full size="md" style={{ color: t.error, borderColor: t.errorSoft }}>
            Sign out
          </FNButton>
        </div>
      </div>
      {tabs && <FNBottomNav t={t} items={tabs} active="profile" onChange={() => {}} fab={role === 'owner' ? 'post' : undefined} />}
    </FNScreen>
  );
}

function FNNotifications({ t, onBack }) {
  const iconFor = (k) => k === 'message' ? '💬' : k === 'price' ? '💰' : k === 'match' ? '✨' : '🛡';
  const bgFor = (k) => k === 'message' ? t.primarySoft : k === 'price' ? t.warningSoft : k === 'match' ? t.successSoft : t.bgAlt;
  return (
    <FNScreen t={t}>
      <div style={{
        paddingTop: 54, padding: '54px 16px 12px',
        display: 'flex', alignItems: 'center', gap: 10,
      }}>
        <FNIconButton t={t} onClick={onBack} bg="transparent">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={t.ink} strokeWidth="2.4" strokeLinecap="round">
            <path d="M15 5l-7 7 7 7"/></svg>
        </FNIconButton>
        <div style={{ fontSize: 17, fontWeight: 700, color: t.ink }}>Notifications</div>
        <div style={{ flex: 1 }} />
        <a style={{ fontSize: 12, fontWeight: 600, color: t.primary }}>Mark all read</a>
      </div>
      <div style={{ flex: 1, overflow: 'auto', padding: '8px 0 40px' }}>
        <div style={{ fontSize: 11, fontWeight: 700, color: t.inkSoft, textTransform: 'uppercase',
          letterSpacing: 0.6, padding: '8px 20px' }}>Today</div>
        {FN_NOTIFICATIONS.slice(0, 3).map((n, i) => (
          <FNNotifRow key={n.id} n={n} t={t} iconFor={iconFor} bgFor={bgFor} />
        ))}
        <div style={{ fontSize: 11, fontWeight: 700, color: t.inkSoft, textTransform: 'uppercase',
          letterSpacing: 0.6, padding: '16px 20px 8px' }}>Earlier</div>
        {FN_NOTIFICATIONS.slice(3).map((n) => (
          <FNNotifRow key={n.id} n={n} t={t} iconFor={iconFor} bgFor={bgFor} />
        ))}
      </div>
    </FNScreen>
  );
}

function FNNotifRow({ n, t, iconFor, bgFor }) {
  return (
    <div style={{
      display: 'flex', gap: 12, padding: '12px 20px',
      background: n.unread ? t.primarySoft : 'transparent',
      borderLeft: n.unread ? `3px solid ${t.primary}` : '3px solid transparent',
    }}>
      <div style={{
        width: 40, height: 40, borderRadius: 12, background: bgFor(n.kind),
        display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: 18, flexShrink: 0,
      }}>{iconFor(n.kind)}</div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', gap: 8 }}>
          <div style={{ fontSize: 14, fontWeight: 600, color: t.ink, lineHeight: 1.3 }}>{n.title}</div>
          <div style={{ fontSize: 11, color: t.inkSoft, flexShrink: 0 }}>{n.time}</div>
        </div>
        <div style={{ fontSize: 12, color: t.inkMid, marginTop: 4, lineHeight: 1.4 }}>{n.body}</div>
      </div>
    </div>
  );
}

Object.assign(window, { FNProfile, FNNotifications });
