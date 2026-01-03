import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFF0F6FDE);
const Color kSurfaceColor = Color(0xFFF6F8FB);
const Color kTextMuted = Color(0xFF5F6B7A);

enum BudgetStatus { safe, tight, over }

class TripSummary {
	const TripSummary({
		required this.name,
		required this.dateRange,
		required this.citiesCount,
		required this.budgetUsedRatio,
		required this.status,
	});

	final String name;
	final String dateRange;
	final int citiesCount;
	final double budgetUsedRatio; // 0.0 - 1.0
	final BudgetStatus status;
}

class DestinationSuggestion {
	const DestinationSuggestion({
		required this.city,
		required this.avgCostPerDay,
	});

	final String city;
	final int avgCostPerDay;
}

class DashboardPage extends StatelessWidget {
	const DashboardPage({super.key});

	List<TripSummary> get _trips => const [
				TripSummary(
					name: 'Goa Escape',
					dateRange: '12 Jan - 18 Jan',
					citiesCount: 2,
					budgetUsedRatio: 0.82,
					status: BudgetStatus.over,
				),
				TripSummary(
					name: 'Alps Trek',
					dateRange: '02 Feb - 09 Feb',
					citiesCount: 3,
					budgetUsedRatio: 0.58,
					status: BudgetStatus.tight,
				),
				TripSummary(
					name: 'Kyoto Culture',
					dateRange: '18 Mar - 24 Mar',
					citiesCount: 2,
					budgetUsedRatio: 0.32,
					status: BudgetStatus.safe,
				),
			];

	List<DestinationSuggestion> get _suggestions => const [
				DestinationSuggestion(city: 'Da Nang', avgCostPerDay: 120),
				DestinationSuggestion(city: 'Tbilisi', avgCostPerDay: 95),
				DestinationSuggestion(city: 'Kuala Lumpur', avgCostPerDay: 110),
			];

	@override
	Widget build(BuildContext context) {
		final bool isOffline = false;
		final bool isLoading = false;
		final int onTrack = _trips.where((t) => t.status == BudgetStatus.safe).length;
		final int overBudget = _trips.where((t) => t.status == BudgetStatus.over).length;
		final int upcoming = _trips.length;

		return Scaffold(
			backgroundColor: kSurfaceColor,
			bottomNavigationBar: _buildBottomNav(),
			body: SafeArea(
				child: Stack(
					children: [
						NestedScrollView(
							headerSliverBuilder: (context, _) => [
								SliverAppBar(
									pinned: true,
									floating: false,
									backgroundColor: Colors.white,
									surfaceTintColor: Colors.transparent,
									titleSpacing: 16,
									title: Row(
										children: [
											Container(
												padding: const EdgeInsets.all(8),
												decoration: BoxDecoration(
													  color: kPrimaryColor.withOpacity(0.08),
													borderRadius: BorderRadius.circular(12),
												),
												child: const Icon(Icons.travel_explore, color: kPrimaryColor),
											),
											const SizedBox(width: 10),
											const Text(
												'Travel Studio',
												style: TextStyle(fontWeight: FontWeight.w700),
											),
										],
									),
									actions: [
										TextButton.icon(
											onPressed: () {},
											style: TextButton.styleFrom(
												foregroundColor: Colors.white,
												backgroundColor: kPrimaryColor,
												padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
												shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
											),
											icon: const Icon(Icons.add),
											label: const Text('Plan New Trip'),
										),
										const SizedBox(width: 12),
										IconButton(
											onPressed: () {},
											  icon: const Icon(Icons.notifications_none_rounded, color: kTextMuted),
										),
										const SizedBox(width: 4),
										Padding(
											padding: const EdgeInsets.only(right: 12),
											child: CircleAvatar(
												backgroundColor: kPrimaryColor.withOpacity(0.12),
												child: const Icon(Icons.person, color: kPrimaryColor),
											),
										),
									],
								),
							],
							body: RefreshIndicator(
								onRefresh: () async {},
								child: SingleChildScrollView(
									padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
									physics: const AlwaysScrollableScrollPhysics(),
									child: Column(
										crossAxisAlignment: CrossAxisAlignment.stretch,
										children: [
											_buildWelcomeStrip(onTrack: onTrack, overBudget: overBudget, upcoming: upcoming),
											const SizedBox(height: 16),
											_buildTripGrid(isLoading: isLoading),
											const SizedBox(height: 16),
											_buildBudgetOverview(),
											const SizedBox(height: 16),
											_buildQuickActions(),
											const SizedBox(height: 16),
											_buildInspiration(),
											const SizedBox(height: 16),
										],
									),
								),
							),
						),
						if (isOffline) _OfflineBanner(),
					],
				),
			),
		);
	}

	Widget _buildWelcomeStrip({required int onTrack, required int overBudget, required int upcoming}) {
		return Container(
			padding: const EdgeInsets.all(16),
			decoration: BoxDecoration(
				color: Colors.white,
				borderRadius: BorderRadius.circular(16),
				boxShadow: [
					BoxShadow(
						color: Colors.black.withOpacity(0.03),
						blurRadius: 16,
						offset: const Offset(0, 8),
					),
				],
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					const Text(
						'Welcome back,',
						style: TextStyle(fontSize: 16, color: kTextMuted),
					),
					const SizedBox(height: 6),
					const Text(
						'Your travel cockpit is ready.',
						style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
					),
					const SizedBox(height: 12),
					Wrap(
						spacing: 8,
						runSpacing: 8,
						children: [
							_StatusBadge(color: Colors.green, icon: Icons.check_circle, label: 'Trips On Track', value: onTrack),
							_StatusBadge(color: Colors.red, icon: Icons.warning_amber_rounded, label: 'Over Budget', value: overBudget),
							_StatusBadge(color: Colors.indigo, icon: Icons.event_available, label: 'Upcoming', value: upcoming),
						],
					),
				],
			),
		);
	}

	Widget _buildTripGrid({required bool isLoading}) {
		return _SectionCard(
			title: 'Active & Upcoming Trips',
			subtitle: 'Stay above the fold — quick actions at hand',
			child: LayoutBuilder(
				builder: (context, constraints) {
					final double width = constraints.maxWidth;
					int columns = 1;
					if (width > 1100) {
						columns = 3;
					} else if (width > 700) {
						columns = 2;
					}

					if (isLoading) {
						return _SkeletonGrid(columns: columns);
					}

					return GridView.builder(
						shrinkWrap: true,
						physics: const NeverScrollableScrollPhysics(),
						gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
							crossAxisCount: columns,
							mainAxisSpacing: 12,
							crossAxisSpacing: 12,
							childAspectRatio: columns == 1 ? 1.5 : 1.3,
						),
						itemCount: _trips.length,
						itemBuilder: (context, index) {
							final trip = _trips[index];
							return _TripCard(trip: trip);
						},
					);
				},
			),
		);
	}

	Widget _buildBudgetOverview() {
		return _SectionCard(
			title: 'Budget Health Overview',
			subtitle: 'Budget-first visibility with explainable risk',
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					LayoutBuilder(
						builder: (context, constraints) {
							final bool isWide = constraints.maxWidth > 640;
							final double tileWidth = isWide ? (constraints.maxWidth - 24) / 3 : constraints.maxWidth;
							return Wrap(
								spacing: 12,
								runSpacing: 12,
								children: [
									SizedBox(width: tileWidth, child: const _MetricTile(label: 'Total Planned', value: 'Rs 1,25,000')),
									SizedBox(width: tileWidth, child: const _MetricTile(label: 'Est. Spend', value: 'Rs 1,18,400')),
									SizedBox(width: tileWidth, child: const _MetricTile(label: 'Remaining', value: 'Rs 6,600', emphasize: true)),
								],
							);
						},
					),
					const SizedBox(height: 12),
					_RiskPill(status: BudgetStatus.over),
					const SizedBox(height: 12),
					_DecisionLogPreview(
						text: 'Your Goa trip is over budget due to high activity costs on Day 3.',
					),
				],
			),
		);
	}

	Widget _buildQuickActions() {
		final actions = [
			_QuickAction(icon: Icons.location_city, label: 'Add City'),
			_QuickAction(icon: Icons.event_available, label: 'Edit Dates'),
			_QuickAction(icon: Icons.playlist_add_check, label: 'Add Activity'),
			_QuickAction(icon: Icons.copy_all_rounded, label: 'Copy Trip'),
		];

		return _SectionCard(
			title: 'Continue Planning',
			subtitle: 'Reduce friction — move your plan forward',
			child: Wrap(
				spacing: 12,
				runSpacing: 12,
				children: actions
						.map(
							(a) => ElevatedButton.icon(
								onPressed: () {},
								icon: Icon(a.icon),
								label: Text(a.label),
								style: ElevatedButton.styleFrom(
									backgroundColor: Colors.white,
									foregroundColor: kTextMuted,
									elevation: 0,
									side: BorderSide(color: Colors.grey.shade300),
									padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
									shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
								),
							),
						)
						.toList(),
			),
		);
	}

	Widget _buildInspiration() {
		return _SectionCard(
			title: 'Inspiration',
			subtitle: 'Budget-tuned destinations — lightweight add',
			child: SizedBox(
				height: 170,
				child: ListView.separated(
					scrollDirection: Axis.horizontal,
					itemCount: _suggestions.length,
					separatorBuilder: (_, __) => const SizedBox(width: 12),
					itemBuilder: (context, index) {
						final suggestion = _suggestions[index];
						return Container(
							width: 220,
							padding: const EdgeInsets.all(14),
							decoration: BoxDecoration(
								color: Colors.white,
								borderRadius: BorderRadius.circular(14),
								border: Border.all(color: Colors.grey.shade200),
							),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Row(
										children: [
											CircleAvatar(
												backgroundColor: kPrimaryColor.withOpacity(0.12),
												child: const Icon(Icons.location_on, color: kPrimaryColor),
											),
											const SizedBox(width: 10),
											Expanded(
												child: Text(
													suggestion.city,
													style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
													overflow: TextOverflow.ellipsis,
												),
											),
										],
									),
									const SizedBox(height: 12),
									Text(
										'Avg Rs ${suggestion.avgCostPerDay}/day',
										style: const TextStyle(fontSize: 14, color: kTextMuted),
									),
									const Spacer(),
									SizedBox(
										width: double.infinity,
										child: OutlinedButton(
											onPressed: () {},
											style: OutlinedButton.styleFrom(
												side: BorderSide(color: Colors.grey.shade300),
												shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
											),
											child: const Text('Add to Trip'),
										),
									),
								],
							),
						);
					},
				),
			),
		);
	}

	BottomNavigationBar _buildBottomNav() {
		return BottomNavigationBar(
			currentIndex: 0,
			selectedItemColor: kPrimaryColor,
			unselectedItemColor: kTextMuted,
			showUnselectedLabels: true,
			items: const [
				BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
				BottomNavigationBarItem(icon: Icon(Icons.card_travel), label: 'Trips'),
				BottomNavigationBarItem(icon: Icon(Icons.pie_chart_outline), label: 'Budget'),
				BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
			],
		);
	}
}

class _TripCard extends StatelessWidget {
	const _TripCard({required this.trip});

	final TripSummary trip;

	Color _statusColor(BudgetStatus status) {
		switch (status) {
			case BudgetStatus.safe:
				return Colors.green;
			case BudgetStatus.tight:
				return Colors.amber.shade700;
			case BudgetStatus.over:
				return Colors.red;
		}
	}

	String _statusLabel(BudgetStatus status) {
		switch (status) {
			case BudgetStatus.safe:
				return 'Safe';
			case BudgetStatus.tight:
				return 'Tight';
			case BudgetStatus.over:
				return 'Over';
		}
	}

	@override
	Widget build(BuildContext context) {
		final Color statusColor = _statusColor(trip.status);

		return Container(
			padding: const EdgeInsets.all(14),
			decoration: BoxDecoration(
				color: Colors.white,
				borderRadius: BorderRadius.circular(16),
				border: Border.all(color: Colors.grey.shade200),
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Row(
						children: [
							Expanded(
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(
											trip.name,
											style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
										),
										const SizedBox(height: 4),
										Text(
											trip.dateRange,
											style: const TextStyle(color: kTextMuted, fontSize: 13),
										),
									],
								),
							),
							Container(
								padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
								decoration: BoxDecoration(
									color: statusColor.withOpacity(0.12),
									borderRadius: BorderRadius.circular(12),
								),
								child: Row(
									children: [
										Icon(Icons.circle, size: 10, color: statusColor),
										const SizedBox(width: 6),
										Text(
											_statusLabel(trip.status),
											style: TextStyle(color: statusColor, fontWeight: FontWeight.w600, fontSize: 12),
										),
									],
								),
							),
						],
					),
					const SizedBox(height: 12),
					Row(
						children: [
							const Icon(Icons.location_city, size: 18, color: kTextMuted),
							const SizedBox(width: 6),
							Text('${trip.citiesCount} cities', style: const TextStyle(color: kTextMuted)),
						],
					),
					const SizedBox(height: 10),
					ClipRRect(
						borderRadius: BorderRadius.circular(8),
						child: LinearProgressIndicator(
							value: trip.budgetUsedRatio.clamp(0, 1),
							backgroundColor: Colors.grey.shade200,
							color: statusColor,
							minHeight: 8,
						),
					),
					const SizedBox(height: 6),
					Text(
						'${(trip.budgetUsedRatio * 100).round()}% of budget used',
						style: const TextStyle(color: kTextMuted, fontSize: 12),
					),
					const Spacer(),
					Wrap(
						spacing: 8,
						runSpacing: 8,
						children: [
							_GhostButton(label: 'Open Itinerary', icon: Icons.menu_book_outlined),
							_GhostButton(label: 'View Budget', icon: Icons.pie_chart_outline),
							_GhostButton(label: 'Share', icon: Icons.ios_share),
						],
					),
				],
			),
		);
	}
}

class _SectionCard extends StatelessWidget {
	const _SectionCard({required this.title, required this.subtitle, required this.child});

	final String title;
	final String subtitle;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return Container(
			padding: const EdgeInsets.all(16),
			decoration: BoxDecoration(
				color: Colors.white,
				borderRadius: BorderRadius.circular(16),
				boxShadow: [
					BoxShadow(
						color: Colors.black.withOpacity(0.02),
						blurRadius: 12,
						offset: const Offset(0, 8),
					),
				],
			),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					Row(
						children: [
							Expanded(
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
										const SizedBox(height: 4),
										Text(subtitle, style: const TextStyle(fontSize: 13, color: kTextMuted)),
									],
								),
							),
						],
					),
					const SizedBox(height: 12),
					child,
				],
			),
		);
	}
}

class _StatusBadge extends StatelessWidget {
	const _StatusBadge({required this.color, required this.icon, required this.label, required this.value});

	final Color color;
	final IconData icon;
	final String label;
	final int value;

	@override
	Widget build(BuildContext context) {
		return Container(
			padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
			decoration: BoxDecoration(
				color: color.withOpacity(0.1),
				borderRadius: BorderRadius.circular(12),
			),
			child: Row(
				mainAxisSize: MainAxisSize.min,
				children: [
					Icon(icon, size: 16, color: color),
					const SizedBox(width: 6),
					Text('$label: $value', style: TextStyle(color: color, fontWeight: FontWeight.w600)),
				],
			),
		);
	}
}

class _GhostButton extends StatelessWidget {
	const _GhostButton({required this.label, required this.icon});

	final String label;
	final IconData icon;

	@override
	Widget build(BuildContext context) {
		return OutlinedButton.icon(
			onPressed: () {},
			icon: Icon(icon, size: 18),
			label: Text(label),
			style: OutlinedButton.styleFrom(
				side: BorderSide(color: Colors.grey.shade300),
				shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
				padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
			),
		);
	}
}

class _MetricTile extends StatelessWidget {
	const _MetricTile({required this.label, required this.value, this.emphasize = false});

	final String label;
	final String value;
	final bool emphasize;

	@override
	Widget build(BuildContext context) {
		return Expanded(
			child: Container(
				padding: const EdgeInsets.all(12),
				decoration: BoxDecoration(
					color: emphasize ? kPrimaryColor.withOpacity(0.08) : Colors.white,
					borderRadius: BorderRadius.circular(12),
					border: Border.all(color: Colors.grey.shade200),
				),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text(label, style: const TextStyle(color: kTextMuted, fontSize: 13)),
						const SizedBox(height: 6),
						Text(
							value,
							style: TextStyle(
								fontSize: 18,
								fontWeight: FontWeight.w700,
								color: emphasize ? kPrimaryColor : Colors.black,
							),
						),
					],
				),
			),
		);
	}
}

class _RiskPill extends StatelessWidget {
	const _RiskPill({required this.status});

	final BudgetStatus status;

	@override
	Widget build(BuildContext context) {
		Color color;
		String text;
		switch (status) {
			case BudgetStatus.safe:
				color = Colors.green;
				text = 'Safe';
				break;
			case BudgetStatus.tight:
				color = Colors.amber.shade700;
				text = 'Tight';
				break;
			case BudgetStatus.over:
				color = Colors.red;
				text = 'Over';
				break;
		}

		return Container(
			padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
			decoration: BoxDecoration(
				color: color.withOpacity(0.12),
				borderRadius: BorderRadius.circular(12),
			),
			child: Row(
				mainAxisSize: MainAxisSize.min,
				children: [
					Icon(Icons.bolt, color: color, size: 18),
					const SizedBox(width: 8),
					Text('Risk: $text', style: TextStyle(color: color, fontWeight: FontWeight.w700)),
				],
			),
		);
	}
}

class _DecisionLogPreview extends StatelessWidget {
	const _DecisionLogPreview({required this.text});

	final String text;

	@override
	Widget build(BuildContext context) {
		return Container(
			width: double.infinity,
			padding: const EdgeInsets.all(12),
			decoration: BoxDecoration(
				color: Colors.grey.shade100,
				borderRadius: BorderRadius.circular(12),
				border: Border.all(color: Colors.grey.shade200),
			),
			child: Row(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					const Icon(Icons.notes, color: kPrimaryColor, size: 18),
					const SizedBox(width: 8),
					Expanded(
						child: Text(
							text,
							style: const TextStyle(fontSize: 13, color: kTextMuted),
						),
					),
				],
			),
		);
	}
}

class _QuickAction {
	const _QuickAction({required this.icon, required this.label});
	final IconData icon;
	final String label;
}

class _SkeletonGrid extends StatelessWidget {
	const _SkeletonGrid({required this.columns});
	final int columns;

	@override
	Widget build(BuildContext context) {
		return GridView.builder(
			shrinkWrap: true,
			physics: const NeverScrollableScrollPhysics(),
			gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
				crossAxisCount: columns,
				mainAxisSpacing: 12,
				crossAxisSpacing: 12,
				childAspectRatio: columns == 1 ? 1.5 : 1.3,
			),
			itemCount: columns * 2,
			itemBuilder: (context, _) {
				return _SkeletonCard();
			},
		);
	}
}

class _SkeletonCard extends StatefulWidget {
	@override
	State<_SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<_SkeletonCard> with SingleTickerProviderStateMixin {
	late final AnimationController _controller;

	@override
	void initState() {
		super.initState();
		_controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
			..repeat(reverse: true);
	}

	@override
	void dispose() {
		_controller.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return AnimatedBuilder(
			animation: _controller,
			builder: (context, _) {
				final double opacity = 0.2 + (_controller.value * 0.15);
				return Container(
					padding: const EdgeInsets.all(14),
					decoration: BoxDecoration(
						color: Colors.white,
						borderRadius: BorderRadius.circular(16),
						border: Border.all(color: Colors.grey.shade200),
					),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							_shimmerBlock(height: 16, width: 120, opacity: opacity),
							const SizedBox(height: 8),
							_shimmerBlock(height: 12, width: 90, opacity: opacity),
							const SizedBox(height: 16),
							_shimmerBlock(height: 12, width: 60, opacity: opacity),
							const SizedBox(height: 10),
							_shimmerBlock(height: 8, width: double.infinity, opacity: opacity),
							const SizedBox(height: 16),
							Row(
								children: [
									_shimmerBlock(height: 34, width: 90, opacity: opacity),
									const SizedBox(width: 8),
									_shimmerBlock(height: 34, width: 80, opacity: opacity),
								],
							),
						],
					),
				);
			},
		);
	}

	Widget _shimmerBlock({required double height, required double width, required double opacity}) {
		return Container(
			height: height,
			width: width,
			decoration: BoxDecoration(
				color: Colors.grey.withOpacity(opacity),
				borderRadius: BorderRadius.circular(8),
			),
		);
	}
}

class _OfflineBanner extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Positioned(
			top: 0,
			left: 0,
			right: 0,
			child: Container(
				padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
				color: Colors.orange.shade50,
				child: Row(
					children: const [
						Icon(Icons.wifi_off, color: Colors.orange),
						SizedBox(width: 8),
						Expanded(
							child: Text(
								"You're offline. Viewing saved trips only.",
								style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600),
							),
						),
					],
				),
			),
		);
	}
}
