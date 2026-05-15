// screens-chat.jsx — Chat list + Chat detail

function FNChatList({ t, onOpen, tabs, active }) {
  return (
    <FNScreen t={t}>
      <FNTopBar t={t} title="Messages" right={
        <FNIconButton t={t}>
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={t.ink} strokeWidth="2" strokeLinecap="round">
            <path d="M12 5v14M5 12h14"/></svg>
        </FNIconButton>
      } />
      <div style={{ padding: '0 20px' }}>
        <FNSearch t={t} placeholder="Search conversations" />
      </div>
      <div style={{ flex: 1, overflow: 'auto', padding: '12px 0 100px' }}>
        {FN_CHATS.map((c, i) => {
          const l = FN_LISTINGS.find((x) => x.id === c.listing);
          return (
            <div key={c.id} onClick={() => onOpen(c)} style={{
              display: 'flex', gap: 12, padding: '12px 20px', cursor: 'pointer',
              borderBottom: i === FN_CHATS.length - 1 ? 'none' : `1px solid ${t.borderSoft}`,
            }}>
              <div style={{ position: 'relative', flexShrink: 0 }}>
                <FNAvatar initials={c.initials} size={52} color={c.color} t={t} />
                {c.online && (
                  <div style={{
                    position: 'absolute', bottom: 1, right: 1, width: 12, height: 12, borderRadius: 6,
                    background: t.success, border: `2px solid ${t.bg}`,
                  }} />
                )}
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', gap: 8 }}>
                  <div style={{ fontSize: 15, fontWeight: 700, color: t.ink,
                    overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{c.name}</div>
                  <div style={{ fontSize: 11, color: c.unread ? t.primary : t.inkSoft, fontWeight: c.unread ? 700 : 500, flexShrink: 0 }}>{c.time}</div>
                </div>
                {l && <div style={{ fontSize: 11, color: t.inkSoft, marginTop: 2,
                  overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>📍 {l.title}</div>}
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: 4, gap: 8 }}>
                  <div style={{ fontSize: 13, color: c.unread ? t.ink : t.inkMid,
                    fontWeight: c.unread ? 600 : 400,
                    overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap', flex: 1 }}>{c.last}</div>
                  {c.unread > 0 && (
                    <div style={{
                      minWidth: 20, height: 20, padding: '0 6px', borderRadius: 10,
                      background: t.primary, color: '#fff',
                      fontSize: 11, fontWeight: 700,
                      display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
                    }}>{c.unread}</div>
                  )}
                </div>
              </div>
            </div>
          );
        })}
      </div>
      {tabs && <FNBottomNav t={t} items={tabs} active={active || 'messages'} onChange={() => {}} />}
    </FNScreen>
  );
}

function FNChatDetail({ t, chat, onBack }) {
  const listing = FN_LISTINGS.find((x) => x.id === chat.listing);
  const msgs = chat.messages || [
    { from: 'them', text: 'Hi! Thanks for reaching out about my flat.', time: '11:02' },
    { from: 'me',   text: 'Is the listing still available?', time: '11:14' },
    { from: 'them', text: 'Yes — available from next month.', time: '11:18' },
  ];
  return (
    <FNScreen t={t}>
      {/* Top bar with listing pill */}
      <div style={{
        paddingTop: 54, paddingLeft: 12, paddingRight: 12, paddingBottom: 10,
        background: t.surface, borderBottom: `1px solid ${t.borderSoft}`,
        display: 'flex', alignItems: 'center', gap: 10,
      }}>
        <FNIconButton t={t} onClick={onBack} bg="transparent">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={t.ink} strokeWidth="2.4" strokeLinecap="round">
            <path d="M15 5l-7 7 7 7"/></svg>
        </FNIconButton>
        <div style={{ position: 'relative', flexShrink: 0 }}>
          <FNAvatar initials={chat.initials} size={36} color={chat.color} t={t} />
          {chat.online && (
            <div style={{
              position: 'absolute', bottom: 0, right: 0, width: 10, height: 10, borderRadius: 5,
              background: t.success, border: `2px solid ${t.surface}`,
            }} />
          )}
        </div>
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ fontSize: 15, fontWeight: 700, color: t.ink }}>{chat.name}</div>
          <div style={{ fontSize: 11, color: chat.online ? t.success : t.inkSoft }}>{chat.online ? 'Online now' : 'Last seen 2h ago'}</div>
        </div>
        <FNIconButton t={t} bg="transparent">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={t.ink} strokeWidth="2" strokeLinecap="round">
            <path d="M22 16.92V20a2 2 0 01-2.18 2A19.79 19.79 0 012 4.18 2 2 0 014 2h3.08a2 2 0 012 1.72 12.84 12.84 0 00.7 2.81 2 2 0 01-.45 2.11L8 10a16 16 0 006 6l1.36-1.36a2 2 0 012.11-.45 12.84 12.84 0 002.81.7A2 2 0 0122 16.92z"/>
          </svg>
        </FNIconButton>
      </div>

      {/* Listing pill */}
      {listing && (
        <div style={{
          margin: '12px 16px 0', padding: 10,
          background: t.primarySoft, borderRadius: 12,
          display: 'flex', gap: 10, alignItems: 'center',
        }}>
          <FNPhoto tint={listing.photoTint} style={{ width: 44, height: 44, borderRadius: 8 }} />
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{ fontSize: 12, fontWeight: 700, color: t.primaryInk,
              overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>{listing.title}</div>
            <div style={{ fontSize: 11, color: t.primaryInk, opacity: 0.7 }}>{listing.area} · {fnBDT(listing.price)} /mo</div>
          </div>
          <a style={{ fontSize: 12, fontWeight: 600, color: t.primary }}>View</a>
        </div>
      )}

      {/* Messages */}
      <div style={{ flex: 1, overflow: 'auto', padding: '16px 16px 80px',
        display: 'flex', flexDirection: 'column', gap: 8 }}>
        <div style={{ textAlign: 'center', fontSize: 11, color: t.inkSoft, padding: '8px 0' }}>Today</div>
        {msgs.map((m, i) => {
          const me = m.from === 'me';
          return (
            <div key={i} style={{ display: 'flex', justifyContent: me ? 'flex-end' : 'flex-start' }}>
              <div style={{ maxWidth: '78%' }}>
                <div style={{
                  background: me ? t.primary : t.surface,
                  color: me ? '#fff' : t.ink,
                  padding: '10px 14px',
                  borderRadius: 18,
                  borderTopRightRadius: me ? 6 : 18,
                  borderTopLeftRadius: me ? 18 : 6,
                  fontSize: 14, lineHeight: 1.4,
                  border: me ? 'none' : `1px solid ${t.borderSoft}`,
                  boxShadow: me ? `0 2px 6px ${withAlpha(t.primary, 0.18)}` : 'none',
                }}>{m.text}</div>
                <div style={{ fontSize: 10, color: t.inkSoft, marginTop: 4, textAlign: me ? 'right' : 'left',
                  paddingLeft: me ? 0 : 6, paddingRight: me ? 6 : 0 }}>
                  {m.time}{me && ' · ✓✓'}
                </div>
              </div>
            </div>
          );
        })}

        {/* Typing indicator */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 4, marginTop: 4 }}>
          <div style={{
            padding: '12px 14px', borderRadius: 18, borderTopLeftRadius: 6,
            background: t.surface, border: `1px solid ${t.borderSoft}`,
            display: 'inline-flex', gap: 4,
          }}>
            {[0, 1, 2].map(i => (
              <div key={i} style={{
                width: 6, height: 6, borderRadius: 3, background: t.inkSoft,
                animation: `fn-blink 1.2s infinite ${i * 0.2}s`,
              }} />
            ))}
          </div>
        </div>
      </div>

      {/* Composer */}
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0,
        background: t.surface, borderTop: `1px solid ${t.borderSoft}`,
        padding: '10px 14px 28px',
        display: 'flex', alignItems: 'center', gap: 8,
      }}>
        <FNIconButton t={t} bg="transparent">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke={t.inkMid} strokeWidth="2" strokeLinecap="round">
            <path d="M12 5v14M5 12h14"/></svg>
        </FNIconButton>
        <div style={{
          flex: 1, height: 42, padding: '0 14px', borderRadius: 21,
          background: t.bgAlt, display: 'flex', alignItems: 'center', gap: 8,
        }}>
          <input placeholder="Type a message…" style={{
            flex: 1, border: 'none', outline: 'none', background: 'transparent',
            fontSize: 14, color: t.ink, fontFamily: FN_FONT,
          }} />
          <button style={{ background: 'transparent', border: 'none', fontSize: 16, cursor: 'pointer' }}>😊</button>
        </div>
        <button style={{
          width: 42, height: 42, borderRadius: 21, background: t.primary,
          border: 'none', cursor: 'pointer', display: 'inline-flex',
          alignItems: 'center', justifyContent: 'center',
        }}>
          <svg width="18" height="18" viewBox="0 0 24 24" fill="#fff">
            <path d="M3 11L21 3l-8 18-2-8z" stroke="#fff" strokeWidth="1.5" strokeLinejoin="round"/>
          </svg>
        </button>
      </div>

      <style>{`@keyframes fn-blink { 0%, 60%, 100% { opacity: 0.3; } 30% { opacity: 1; } }`}</style>
    </FNScreen>
  );
}

Object.assign(window, { FNChatList, FNChatDetail });
