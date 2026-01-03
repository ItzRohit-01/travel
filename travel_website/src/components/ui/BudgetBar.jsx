import React, { useMemo } from 'react';
import { motion } from 'framer-motion';

function getRiskColor(ratio) {
	if (ratio <= 0.6) return '#10b981';
	if (ratio <= 0.9) return '#f59e0b';
	return '#ef4444';
}

function BudgetBar({ totalBudget = 0, usedBudget = 0 }) {
	const safeTotal = Math.max(totalBudget, 0.0001);
	const ratio = Math.min(usedBudget / safeTotal, 1.2);
	const color = useMemo(() => getRiskColor(ratio), [ratio]);

	return (
		<div style={{ width: '100%', background: '#e2e8f0', borderRadius: '12px', padding: '10px', boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.6)' }}>
			<div style={{ display: 'flex', justifyContent: 'space-between', fontSize: 13, color: '#475569', marginBottom: 6 }}>
				<span>Budget usage</span>
				<span>
					₹{usedBudget.toLocaleString()} / ₹{totalBudget.toLocaleString()}
				</span>
			</div>
			<div style={{ height: 14, background: '#f8fafc', borderRadius: '10px', overflow: 'hidden', position: 'relative' }}>
				<motion.div
					initial={{ width: 0 }}
					animate={{ width: `${Math.min(ratio * 100, 100)}%` }}
					transition={{ duration: 0.8, ease: 'easeOut' }}
					style={{ height: '100%', background: color, boxShadow: '0 6px 12px rgba(0,0,0,0.08)' }}
				/>
				{ratio > 1 && (
					<div style={{ position: 'absolute', inset: 0, display: 'grid', placeItems: 'center', color: '#ef4444', fontWeight: 700, fontSize: 12 }}>
						Over budget
					</div>
				)}
			</div>
		</div>
	);
}

export default BudgetBar;
