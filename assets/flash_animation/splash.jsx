// FlatNest animated splash — "drop a pin" concept.
// Globals: React, IOSDevice, useTweaks, TweaksPanel, Tweak* controls.
const { useState } = React;

const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "pin": "#EE6A63",
  "bg": ["#DEEAE7", "#CEDFE1"],
  "tagline": "Your spot, marked",
  "speed": "normal",
  "clouds": true,
  "loader": false
} /*EDITMODE-END*/;

const SPEED_MAP = { relaxed: 1.35, normal: 1, snappy: 0.7 };

// ── A soft two-puff cloud ──────────────────────────────────
function Cloud({ w = 150 }) {
  const h = w * 0.46;
  return (
    <svg width={w} height={h} viewBox="0 0 150 70" fill="none">
      <ellipse cx="58" cy="42" rx="56" ry="26" fill="#E7EFEE" stroke="rgba(150,172,172,0.32)" strokeWidth="1.3" />
      <ellipse cx="104" cy="40" rx="40" ry="22" fill="#E7EFEE" stroke="rgba(150,172,172,0.32)" strokeWidth="1.3" />
      <ellipse cx="58" cy="40" rx="53" ry="23" fill="#EEF4F3" />
      <ellipse cx="104" cy="38" rx="37" ry="19" fill="#EEF4F3" />
    </svg>);

}

// ── The keyhole / drop-pin mark ────────────────────────────
function PinMark() {
  return (
    <div className="fn-pin">
      <svg width="106" height="132" viewBox="0 0 120 150" fill="var(--fn-pin)">
        <circle cx="60" cy="50" r="46" />
        <rect x="30" y="48" width="60" height="86" rx="28" />
      </svg>
    </div>);

}

function Stage({ runId, t }) {
  const spd = SPEED_MAP[t.speed] || 1;
  const dots = Array.from({ length: 13 });
  return (
    <div
      className="fn-screen"
      key={runId}
      style={{
        "--fn-pin": t.pin,
        "--fn-bg-top": t.bg[0],
        "--fn-bg-bot": t.bg[1],
        "--spd": spd
      }}>
      
      {t.clouds &&
      <div className="fn-sky">
          <div className="fn-cloud fn-cloud-1"><Cloud w={150} /></div>
          <div className="fn-cloud fn-cloud-2"><Cloud w={168} /></div>
          <div className="fn-cloud fn-cloud-3"><Cloud w={120} /></div>
        </div>
      }

      <div className="fn-trail">
        {dots.map((_, i) =>
        <span
          key={i}
          className="fn-dot-trail"
          style={{ animationDelay: `calc(${150 + i * 55}ms * var(--spd))` }} />

        )}
      </div>

      <div className="fn-pinstage">
        <div className="fn-ripple"></div>
        <PinMark />
      </div>

      <div className="fn-shadow"></div>

      <div className="fn-text">
        <h1 className="fn-word"><span className="b">flat</span><span className="r">nest</span></h1>
        <p className="fn-tag">{t.tagline}</p>
      </div>

      {t.loader &&
      <div className="fn-loader"><span></span><span></span><span></span></div>
      }
    </div>);

}

function Splash() {
  const [t, setTweak] = useTweaks(TWEAK_DEFAULTS);
  // Bumping the key remounts the animated stack so it replays from frame 0.
  const [runId, setRunId] = useState(0);

  return (
    <div className="fn-stage">
      <IOSDevice>
        <Stage runId={runId} t={t} />
      </IOSDevice>

      <button className="fn-replay" onClick={() => setRunId((n) => n + 1)}>
        ↻ Replay animation
      </button>

      <TweaksPanel>
        <TweakSection label="Brand" />
        <TweakColor
          label="Pin color" value={t.pin}
          options={["#EE6A63", "#1A6B72", "#5B8DEF", "#E8A33D", "#7A5AE0"]}
          onChange={(v) => setTweak("pin", v)} />
        
        <TweakColor
          label="Background" value={t.bg}
          options={[
          ["#DEEAE7", "#CEDFE1"],
          ["#EDE6E1", "#E2D6CE"],
          ["#E7E9F0", "#D6DAE6"],
          ["#1A2A2E", "#0E1B1E"]]
          }
          onChange={(v) => setTweak("bg", v)} />
        
        <TweakText label="Tagline" value={t.tagline} onChange={(v) => setTweak("tagline", v)} />

        <TweakSection label="Motion" />
        <TweakRadio
          label="Pace" value={t.speed}
          options={["relaxed", "normal", "snappy"]}
          onChange={(v) => {setTweak("speed", v);setRunId((n) => n + 1);}} />
        
        <TweakToggle label="Clouds" value={t.clouds} onChange={(v) => setTweak("clouds", v)} />
        <TweakToggle label="Loading dots" value={t.loader} onChange={(v) => setTweak("loader", v)} />
      </TweaksPanel>
    </div>);

}

ReactDOM.createRoot(document.getElementById('root')).render(<Splash />);