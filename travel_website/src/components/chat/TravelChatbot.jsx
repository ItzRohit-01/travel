import React, { useEffect, useMemo, useRef, useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';

const bubble = {
  borderRadius: 14,
  padding: '10px 12px',
  maxWidth: '90%',
  boxShadow: '0 10px 30px rgba(15,23,42,0.08)'
};

function TravelChatbot({ destinations = [] }) {
  const [open, setOpen] = useState(true);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const [messages, setMessages] = useState([
    { role: 'bot', text: 'Hi, I am Globalbot · AI Assistant. Ask about any place, budget, best season, or a 3-7 day plan.' }
  ]);

  const normalized = useMemo(
    () =>
      destinations.map((d) => ({
        name: d.name,
        key: d.name.toLowerCase(),
        region: d.region,
        bestTime: d.bestTime,
        avgCost: d.avgCost,
        highlights: d.highlights || [],
        attractions: d.attractions || [],
        rating: d.rating,
        reviews: d.reviews
      })),
    [destinations]
  );

  const quickPrompts = useMemo(() => {
    const names = normalized.slice(0, 3).map((d) => d.name);
    return [
      names[0] ? `3-day ${names[0]} with food picks` : '3-day Japan with food picks',
      names[1] ? `Best time to visit ${names[1]}` : 'Best time to visit Iceland',
      names[2] ? `Budget for ${names[2]} in summer` : 'Budget for Bali in summer',
      'Weekend plan: top 5 must-dos'
    ];
  }, [normalized]);

  const listRef = useRef(null);

  useEffect(() => {
    if (listRef.current) {
      listRef.current.scrollTop = listRef.current.scrollHeight;
    }
  }, [messages, loading]);

  const panelStyle = useMemo(
    () => ({
      position: 'fixed',
      bottom: 18,
      right: 18,
      width: 'min(380px, 92vw)',
      zIndex: 1200,
      fontFamily: "'Segoe UI', 'Helvetica Neue', Arial, sans-serif"
    }),
    []
  );

  const findDestination = (text) => {
    const lower = text.toLowerCase();
    return normalized.find((d) => lower.includes(d.key)) || null;
  };

  const buildAnswer = (query) => {
    const lower = query.toLowerCase();
    const dest = findDestination(lower);
    const daysMatch = lower.match(/(\d+)[- ]?day/);
    const days = daysMatch ? parseInt(daysMatch[1], 10) : 3;
    const budgetCue = /budget|cost|price/.test(lower);
    const seasonCue = /season|best time|weather/.test(lower);
    const riskCue = /family|kids|remote|work|budget|luxury/.test(lower);

    if (dest) {
      const topHighlights = dest.highlights.slice(0, 3).join(', ');
      const heroAttraction = dest.attractions[0]?.name;
      const secondAttraction = dest.attractions[1]?.name;
      const tripPace = riskCue ? 'balanced mornings + 1 anchor per half-day' : 'city core day, icon day, nature/food day';
      return `Here is a ${days}-day take for ${dest.name} (${dest.region}):\n- Best window: ${dest.bestTime} ${seasonCue ? '(best weather + lighter crowds)' : ''}\n- Budget guide: ${budgetCue ? `${dest.avgCost} with mid-range stays and metros` : dest.avgCost}\n- Highlights: ${topHighlights || 'culture, food, and scenery'}\n- Day flow: ${tripPace}\n- Must-sees: ${heroAttraction || 'historic core'}${secondAttraction ? ` and ${secondAttraction}` : ''}\n- Quality check: ⭐ ${dest.rating} (${dest.reviews} reviews)\n- Next: want stays vs food picks? Ask and I will tailor.`;
    }

    if (budgetCue) {
      return 'For most trips, set flights at ~45%, stays 30%, food 15%, experiences 10%. Share the destination and month, and I will size a realistic daily range.';
    }

    if (seasonCue) {
      return 'Shoulder months are usually best (spring/fall). Drop the destination, and I will give the exact months plus packing hints.';
    }

    if (/itinerary|plan|schedule/.test(lower)) {
      return 'I can sketch day-by-day: Day 1 city core + food crawl, Day 2 icons + sunset viewpoint, Day 3 nature or museum + local dinner. Tell me the city and pacing (slow/balanced/fast).';
    }

    return 'I can help with destinations, seasons, budgets, and 3-7 day plans. Ask about a place or give me dates and vibe (budget, adventure, remote work).';
  };

  const handleSend = () => {
    if (!input.trim()) return;
    const userText = input.trim();
    setMessages((prev) => [...prev, { role: 'user', text: userText }]);
    setInput('');
    setLoading(true);

    setTimeout(() => {
      const answer = buildAnswer(userText);
      setMessages((prev) => [...prev, { role: 'bot', text: answer }]);
      setLoading(false);
    }, 220);
  };

  const handleQuickPrompt = (text) => {
    setInput(text);
    setTimeout(handleSend, 30);
  };

  return (
    <div style={panelStyle}>
      <motion.div
        initial={{ opacity: 0, y: 12 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.35 }}
        style={{
          background: '#0f172a',
          color: '#e2e8f0',
          borderRadius: 18,
          boxShadow: '0 24px 70px rgba(15,23,42,0.35)',
          overflow: 'hidden',
          border: '1px solid rgba(255,255,255,0.08)'
        }}
      >
        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '12px 14px', background: 'linear-gradient(135deg, #0ea5e9 0%, #6366f1 100%)' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
            <span style={{ width: 12, height: 12, borderRadius: '50%', background: '#22c55e' }} />
            <div>
              <div style={{ fontWeight: 800, color: '#fff' }}>Globalbot</div>
              <div style={{ fontSize: 12, color: 'rgba(255,255,255,0.85)' }}>AI Assistant</div>
            </div>
          </div>
          <button onClick={() => setOpen((v) => !v)} style={{ background: 'rgba(255,255,255,0.18)', color: '#fff', border: '1px solid rgba(255,255,255,0.35)', borderRadius: 10, padding: '8px 10px', cursor: 'pointer', fontWeight: 700 }}>
            {open ? 'Hide' : 'Open'}
          </button>
        </div>

        <AnimatePresence initial={false}>
          {open && (
            <motion.div
              key="body"
              initial={{ height: 0, opacity: 0 }}
              animate={{ height: 'auto', opacity: 1 }}
              exit={{ height: 0, opacity: 0 }}
              transition={{ duration: 0.25 }}
              style={{ display: 'grid', gap: 10, padding: '12px 12px 14px 12px', background: '#0b1224' }}
            >
              <div ref={listRef} style={{ maxHeight: 320, overflowY: 'auto', display: 'grid', gap: 10, paddingRight: 4 }}>
                {messages.map((m, idx) => (
                  <div key={idx} style={{ display: 'flex', justifyContent: m.role === 'user' ? 'flex-end' : 'flex-start' }}>
                    <div
                      style={{
                        ...bubble,
                        background: m.role === 'user' ? 'linear-gradient(135deg, #22d3ee 0%, #6366f1 100%)' : 'rgba(255,255,255,0.06)',
                        color: m.role === 'user' ? '#0b1224' : '#e2e8f0'
                      }}
                    >
                      {m.text.split('\n').map((line, i) => (
                        <div key={i} style={{ marginTop: i === 0 ? 0 : 4 }}>{line}</div>
                      ))}
                    </div>
                  </div>
                ))}
                {loading && (
                  <div style={{ display: 'flex', justifyContent: 'flex-start' }}>
                    <div style={{ ...bubble, background: 'rgba(255,255,255,0.06)', color: '#e2e8f0', display: 'flex', gap: 6 }}>
                      <span>Typing</span>
                      <motion.span animate={{ opacity: [0.4, 1, 0.4] }} transition={{ repeat: Infinity, duration: 1 }}>. . .</motion.span>
                    </div>
                  </div>
                )}
              </div>

              <div style={{ display: 'flex', flexWrap: 'wrap', gap: 8 }}>
                {quickPrompts.map((prompt) => (
                  <button
                    key={prompt}
                    onClick={() => handleQuickPrompt(prompt)}
                    style={{ padding: '8px 10px', borderRadius: 10, border: '1px solid rgba(255,255,255,0.08)', background: 'rgba(255,255,255,0.04)', color: '#e2e8f0', cursor: 'pointer', fontWeight: 700, fontSize: 12 }}
                  >
                    {prompt}
                  </button>
                ))}
              </div>

              <div style={{ display: 'flex', gap: 8 }}>
                <input
                  value={input}
                  onChange={(e) => setInput(e.target.value)}
                  onKeyDown={(e) => {
                    if (e.key === 'Enter') handleSend();
                  }}
                  placeholder="Ask about a place, season, or budget"
                  style={{ flex: 1, padding: '12px 12px', borderRadius: 12, border: '1px solid rgba(255,255,255,0.12)', background: 'rgba(255,255,255,0.04)', color: '#e2e8f0' }}
                />
                <motion.button
                  whileHover={{ y: -1 }}
                  whileTap={{ scale: 0.98 }}
                  onClick={handleSend}
                  style={{ padding: '12px 14px', borderRadius: 12, border: 'none', background: 'linear-gradient(135deg, #22d3ee 0%, #6366f1 100%)', color: '#0b1224', fontWeight: 800, cursor: 'pointer' }}
                >
                  Send
                </motion.button>
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </motion.div>
    </div>
  );
}

export default TravelChatbot;
