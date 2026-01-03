import 'package:flutter/material.dart';
import 'dart:math' as math;

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({Key? key}) : super(key: key);

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _fadeController;
  late AnimationController _chartController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _chartAnimation;

  String _currentView = 'overview';
  String _sortBy = 'activity';
  String _groupBy = 'category';
  String _filterBy = 'all';

  // Analytics Data
  final Map<String, int> cityPopularity = {
    'Paris': 2840,
    'New York': 2650,
    'Tokyo': 2100,
    'London': 1950,
    'Dubai': 1820,
    'Rome': 1640,
    'Barcelona': 1580,
    'Singapore': 1420,
  };

  final Map<String, int> activityPopularity = {
    'City Tours': 3200,
    'Museums': 2850,
    'Food & Dining': 2640,
    'Adventure Sports': 2320,
    'Shopping': 2150,
    'Beach Activities': 1980,
    'Nightlife': 1760,
    'Cultural Events': 1520,
  };

  final List<Map<String, dynamic>> recentUsers = [
    {
      'name': 'Sarah Johnson',
      'email': 'sarah.j@email.com',
      'trips': 12,
      'spending': 3840,
      'joined': '2023-08-15',
      'status': 'active',
      'avatar': 'SJ'
    },
    {
      'name': 'Mike Chen',
      'email': 'mike.chen@email.com',
      'trips': 8,
      'spending': 2560,
      'joined': '2023-09-20',
      'status': 'active',
      'avatar': 'MC'
    },
    {
      'name': 'Emma Wilson',
      'email': 'emma.w@email.com',
      'trips': 15,
      'spending': 4800,
      'joined': '2023-07-10',
      'status': 'premium',
      'avatar': 'EW'
    },
    {
      'name': 'David Kim',
      'email': 'david.kim@email.com',
      'trips': 6,
      'spending': 1920,
      'joined': '2023-10-05',
      'status': 'active',
      'avatar': 'DK'
    },
    {
      'name': 'Lisa Anderson',
      'email': 'lisa.a@email.com',
      'trips': 20,
      'spending': 6400,
      'joined': '2023-06-01',
      'status': 'premium',
      'avatar': 'LA'
    },
    {
      'name': 'John Smith',
      'email': 'john.smith@email.com',
      'trips': 4,
      'spending': 1280,
      'joined': '2023-11-12',
      'status': 'active',
      'avatar': 'JS'
    },
  ];

  final List<double> monthlyGrowth = [
    450,
    520,
    480,
    680,
    850,
    920,
  ];

  final List<String> monthLabels = ['Aug', 'Sep', 'Oct', 'Nov', 'Dec', 'Jan'];

  // Dashboard Stats
  final Map<String, dynamic> dashboardStats = {
    'totalUsers': 12800,
    'activeTrips': 3240,
    'revenue': 284000,
    'bookings': 8500,
    'conversionRate': 12.5,
    'avgRating': 4.8,
  };

  final List<double> monthlyRevenue = [
    32000,
    38000,
    35000,
    48000,
    62000,
    71000,
  ];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _chartController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _chartAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _chartController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _chartController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    _chartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: CustomScrollView(
        slivers: [
          // Premium Animated Header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF667EEA),
                      const Color(0xFF667EEA).withOpacity(0.8),
                      const Color(0xFF764BA2),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
                child: Stack(
                  children: [
                    // Animated background decorative elements
                    Positioned(
                      right: -80,
                      top: -80,
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -50,
                      bottom: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28.0,
                          vertical: 16.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.elasticOut,
                                  builder: (context, value, child) {
                                    return Transform.scale(
                                      scale: value,
                                      child: Container(
                                        padding: const EdgeInsets.all(14),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(18),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.4),
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              blurRadius: 16,
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.dashboard_rounded,
                                          color: Colors.white,
                                          size: 32,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 18),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'GlobalTrotter',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Admin Dashboard',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white.withOpacity(0.85),
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: _buildHeaderButton(
                  icon: Icons.notifications_outlined,
                  onTap: () => _showNotification('3 new alerts'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: _buildHeaderButton(
                  icon: Icons.settings_rounded,
                  onTap: _showMoreMenu,
                ),
              ),
            ],
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    // Quick Stats Row with enhanced cards
                    _buildEnhancedStatsRow(),
                    const SizedBox(height: 36),

                    // Navigation Cards
                    _buildNavigationCards(),
                    const SizedBox(height: 36),

                    // Charts and Analytics
                    _buildChartCard(),
                    const SizedBox(height: 28),

                    // Top Destinations
                    _buildCitiesCard(),
                    const SizedBox(height: 28),

                    // Recent Users
                    _buildUsersTableCard(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedStatsRow() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 18,
      mainAxisSpacing: 18,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.35,
      children: [
        _buildPremiumStatCard(
          title: 'Total Users',
          value: '12.8K',
          change: '+12.5%',
          icon: Icons.people_alt_rounded,
          gradient: [const Color(0xFF667EEA), const Color(0xFF5568D3)],
        ),
        _buildPremiumStatCard(
          title: 'Active Trips',
          value: '3.2K',
          change: '+8.2%',
          icon: Icons.flight_takeoff_rounded,
          gradient: [const Color(0xFF00D4FF), const Color(0xFF0099CC)],
        ),
        _buildPremiumStatCard(
          title: 'Revenue',
          value: '\$284K',
          change: '+15.3%',
          icon: Icons.trending_up_rounded,
          gradient: [const Color(0xFFFF6B6B), const Color(0xFFEE5A52)],
        ),
        _buildPremiumStatCard(
          title: 'Bookings',
          value: '8.5K',
          change: '+10.8%',
          icon: Icons.check_circle_rounded,
          gradient: [const Color(0xFF4ECDC4), const Color(0xFF37B5AA)],
        ),
      ],
    );
  }

  Widget _buildPremiumStatCard({
    required String title,
    required String value,
    required String change,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, animValue, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - animValue)),
          child: Opacity(
            opacity: animValue,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withOpacity(0.35),
                    blurRadius: 28,
                    offset: const Offset(0, 12),
                  ),
                  BoxShadow(
                    color: gradient[1].withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(-6, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -40,
                    bottom: -40,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.12),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -30,
                    top: -30,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(icon,
                                  color: Colors.white, size: 28),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.35),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                change,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.85),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              value,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavigationCards() {
    final cards = [
      {
        'title': 'Users',
        'icon': Icons.people_rounded,
        'color': const Color(0xFF667EEA),
        'count': '12,845',
      },
      {
        'title': 'Cities',
        'icon': Icons.location_city_rounded,
        'color': const Color(0xFFFF6B6B),
        'count': '8 Trending',
      },
      {
        'title': 'Activities',
        'icon': Icons.local_activity_rounded,
        'color': const Color(0xFF4ECDC4),
        'count': '150+',
      },
      {
        'title': 'Analytics',
        'icon': Icons.analytics_rounded,
        'color': const Color(0xFFFFB347),
        'count': 'Real-time',
      },
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.05,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 700 + (index * 120)),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          (cards[index]['color'] as Color).withOpacity(0.85),
                          (cards[index]['color'] as Color).withOpacity(0.65),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: (cards[index]['color'] as Color)
                              .withOpacity(0.25),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          cards[index]['icon'] as IconData,
                          color: Colors.white,
                          size: 36,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          cards[index]['title'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cards[index]['count'] as String,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChartCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Revenue Trend',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A202C),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Last 6 months analytics',
                    style: TextStyle(
                      fontSize: 13,
                      color: const Color(0xFF718096).withOpacity(0.75),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF667EEA).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF667EEA).withOpacity(0.2),
                  ),
                ),
                child: const Text(
                  '↑ 28%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF667EEA),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 280,
            child: AnimatedBuilder(
              animation: _chartAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: EnhancedChartPainter(
                    data: monthlyGrowth,
                    labels: monthLabels,
                    progress: _chartAnimation.value,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCitiesCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Destinations',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1A202C),
            ),
          ),
          const SizedBox(height: 28),
          ...cityPopularity.entries.toList().asMap().entries.map((entry) {
            int index = entry.key;
            var data = entry.value;
            final maxValue = cityPopularity.values.reduce(math.max);
            final colors = [
              const Color(0xFF667EEA),
              const Color(0xFF764BA2),
              const Color(0xFFFF6B6B),
              const Color(0xFF4ECDC4),
              const Color(0xFFFFB347),
              const Color(0xFF00D4FF),
              const Color(0xFF26D0CE),
              const Color(0xFFFF8B94),
            ];

            return Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colors[index % colors.length]
                                      .withOpacity(0.85),
                                  colors[index % colors.length]
                                      .withOpacity(0.65),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            data.key,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A202C),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${data.value}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF667EEA),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (data.value / maxValue) * 0.95,
                      minHeight: 10,
                      backgroundColor: const Color(0xFFF0F4F8),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colors[index % colors.length],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildUsersTableCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Users',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A202C),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF667EEA).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF667EEA).withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.add_rounded,
                        size: 18, color: Color(0xFF667EEA)),
                    SizedBox(width: 4),
                    Text(
                      'Add User',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF667EEA),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          ...recentUsers.take(4).map((user) {
            final index = recentUsers.indexOf(user);
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 700 + (index * 100)),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(-50 * (1 - value), 0),
                  child: Opacity(
                    opacity: value,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4F8),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF667EEA),
                                  const Color(0xFF764BA2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF667EEA).withOpacity(0.3),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                user['avatar'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user['name'],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1A202C),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  user['email'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF718096),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: user['status'] == 'premium'
                                  ? const Color(0xFFFFD93D).withOpacity(0.2)
                                  : const Color(0xFF4ECDC4).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: user['status'] == 'premium'
                                    ? const Color(0xFFFFD93D).withOpacity(0.4)
                                    : const Color(0xFF4ECDC4).withOpacity(0.4),
                              ),
                            ),
                            child: Text(
                              '${user['trips']} trips',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: user['status'] == 'premium'
                                    ? const Color(0xFFC4860B)
                                    : const Color(0xFF1F8B7D),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF667EEA),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showMoreMenu() {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        const PopupMenuItem(child: Text('Export Data')),
        const PopupMenuItem(child: Text('Settings')),
        const PopupMenuItem(child: Text('Help')),
      ],
    );
  }
}

// Enhanced Chart Painter with better visuals
class EnhancedChartPainter extends CustomPainter {
  final List<double> data;
  final List<String> labels;
  final double progress;

  EnhancedChartPainter({
    required this.data,
    required this.labels,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF667EEA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = const Color(0xFF667EEA).withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final maxValue = data.reduce(math.max);
    final width = size.width / (data.length - 1);
    final height = size.height * 0.85;

    // Draw grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFFF0F4F8)
      ..strokeWidth = 1;

    for (int i = 0; i < 5; i++) {
      final y = (height / 4) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Draw chart bars with animation
    for (int i = 0; i < data.length; i++) {
      final x = i * width;
      final value = data[i] / maxValue;
      final barHeight = height * value * progress;
      final barY = size.height - barHeight - 30;

      // Bar gradient
      final barPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF667EEA),
            const Color(0xFF5568D3),
          ],
        ).createShader(
          Rect.fromLTWH(x + 12, barY, 24, barHeight),
        );

      // Draw bar
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(x + 10, barY, 28, barHeight),
          topLeft: const Radius.circular(6),
          topRight: const Radius.circular(6),
        ),
        barPaint,
      );

      // Draw label
      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: const TextStyle(
            color: Color(0xFF718096),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x + 8 - textPainter.width / 2, size.height - 20),
      );
    }
  }

  @override
  bool shouldRepaint(EnhancedChartPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
