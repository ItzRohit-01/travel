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
      'joined': '2023-08-15',
      'status': 'active',
      'avatar': 'S'
    },
    {
      'name': 'Mike Chen',
      'email': 'mike.chen@email.com',
      'trips': 8,
      'joined': '2023-09-20',
      'status': 'active',
      'avatar': 'M'
    },
    {
      'name': 'Emma Wilson',
      'email': 'emma.w@email.com',
      'trips': 15,
      'joined': '2023-07-10',
      'status': 'active',
      'avatar': 'E'
    },
    {
      'name': 'David Kim',
      'email': 'david.kim@email.com',
      'trips': 6,
      'joined': '2023-10-05',
      'status': 'active',
      'avatar': 'D'
    },
    {
      'name': 'Lisa Anderson',
      'email': 'lisa.a@email.com',
      'trips': 20,
      'joined': '2023-06-01',
      'status': 'premium',
      'avatar': 'L'
    },
    {
      'name': 'John Smith',
      'email': 'john.smith@email.com',
      'trips': 4,
      'joined': '2023-11-12',
      'status': 'active',
      'avatar': 'J'
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

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _chartController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
      backgroundColor: const Color(0xFFF8F9FF),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 100,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'GlobalTrotter',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF667EEA),
                      Color(0xFF764BA2),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('3 new notifications'),
                      backgroundColor: Color(0xFF667EEA),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.person_outline, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar and Controls
                  _buildSearchAndControls(),
                  const SizedBox(height: 20),

                  // Navigation Buttons
                  _buildNavigationButtons(),
                  const SizedBox(height: 24),

                  // Main Dashboard
                  _buildDashboardContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndControls() {
    return Column(
      children: [
        // Search Bar
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF667EEA).withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search bar ......',
                    hintStyle: const TextStyle(
                      color: Color(0xFFBCC3D0),
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF667EEA),
                      size: 24,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Color(0xFF95A3B3)),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),

        // Control Buttons
        Row(
          children: [
            Expanded(
              child: _buildControlButton(
                'Group by',
                _groupBy,
                ['category', 'date', 'popularity'],
                (value) => setState(() => _groupBy = value),
                Icons.group_work,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildControlButton(
                'Filter',
                _filterBy,
                ['all', 'active', 'premium', 'new'],
                (value) => setState(() => _filterBy = value),
                Icons.filter_list,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildControlButton(
                'Sort by...',
                _sortBy,
                ['activity', 'users', 'revenue'],
                (value) => setState(() => _sortBy = value),
                Icons.sort,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControlButton(
    String label,
    String value,
    List<String> options,
    Function(String) onChanged,
    IconData icon,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
      builder: (context, animValue, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - animValue)),
          child: Opacity(
            opacity: animValue,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF667EEA).withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667EEA).withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  Icon(icon, size: 16, color: const Color(0xFF667EEA)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: DropdownButton<String>(
                      value: value,
                      onChanged: (String? newValue) {
                        if (newValue != null) onChanged(newValue);
                      },
                      isExpanded: true,
                      underline: const SizedBox(),
                      isDense: true,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF2C3E50),
                        fontWeight: FontWeight.w600,
                      ),
                      items: options.map<DropdownMenuItem<String>>((String val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text(val[0].toUpperCase() + val.substring(1)),
                        );
                      }).toList(),
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

  Widget _buildNavigationButtons() {
    final buttons = [
      {'title': 'Manage Users', 'icon': Icons.people, 'view': 'users', 'color': const Color(0xFF667EEA)},
      {'title': 'Popular cities', 'icon': Icons.location_city, 'view': 'cities', 'color': const Color(0xFFFF6B6B)},
      {'title': 'Popular Activities', 'icon': Icons.local_activity, 'view': 'activities', 'color': const Color(0xFF4ECDC4)},
      {'title': 'User Trends and Analytics', 'icon': Icons.analytics, 'view': 'overview', 'color': const Color(0xFFFFD93D)},
    ];

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.5,
            ),
            itemCount: buttons.length,
            itemBuilder: (context, index) {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 800 + (index * 100)),
                curve: Curves.elasticOut,
                builder: (context, btnValue, child) {
                  return Transform.scale(
                    scale: btnValue,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _currentView = buttons[index]['view'] as String;
                        });
                        _chartController.reset();
                        _chartController.forward();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _currentView == buttons[index]['view']
                              ? (buttons[index]['color'] as Color)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: (buttons[index]['color'] as Color).withOpacity(0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (buttons[index]['color'] as Color).withOpacity(0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              buttons[index]['icon'] as IconData,
                              color: _currentView == buttons[index]['view']
                                  ? Colors.white
                                  : (buttons[index]['color'] as Color),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                buttons[index]['title'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _currentView == buttons[index]['view']
                                      ? Colors.white
                                      : const Color(0xFF2C3E50),
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDashboardContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      child: _getDashboardView(),
    );
  }

  Widget _getDashboardView() {
    switch (_currentView) {
      case 'users':
        return _buildUsersView();
      case 'cities':
        return _buildCitiesView();
      case 'activities':
        return _buildActivitiesView();
      case 'overview':
      default:
        return _buildOverviewDashboard();
    }
  }

  Widget _buildOverviewDashboard() {
    return Column(
      key: const ValueKey('overview'),
      children: [
        // Stats Cards
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Users',
                '12,845',
                Icons.people,
                const Color(0xFF667EEA),
                '+12.5%',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Active Trips',
                '3,240',
                Icons.flight_takeoff,
                const Color(0xFF4ECDC4),
                '+8.2%',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Revenue',
                '\$284K',
                Icons.attach_money,
                const Color(0xFFFFD93D),
                '+15.3%',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Bookings',
                '8,564',
                Icons.book_online,
                const Color(0xFFFF6B6B),
                '+10.8%',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Charts Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User List
            Expanded(
              flex: 2,
              child: _buildUserListCard(),
            ),
            const SizedBox(width: 16),
            // Pie Chart
            Expanded(
              flex: 1,
              child: _buildPieChartCard(),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Line Chart
        _buildLineChartCard(),
        const SizedBox(height: 24),

        // Bar Chart and Activity List
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: _buildBarChartCard(),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: _buildRecentActivityCard(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String change,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, animValue, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * animValue),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        change,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF95A3B3),
                  ),
                ),
                const SizedBox(height: 4),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1000),
                  builder: (context, countValue, child) {
                    return Text(
                      value,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserListCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Users',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),
          ...recentUsers.take(4).map((user) {
            final index = recentUsers.indexOf(user);
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 800 + (index * 100)),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(-50 * (1 - value), 0),
                  child: Opacity(
                    opacity: value,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xFF667EEA),
                            child: Text(
                              user['avatar'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2C3E50),
                                  ),
                                ),
                                Text(
                                  '${user['trips']} trips',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF95A3B3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: user['status'] == 'premium'
                                  ? const Color(0xFFFFD93D).withOpacity(0.2)
                                  : const Color(0xFF4ECDC4).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              user['status'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: user['status'] == 'premium'
                                    ? const Color(0xFFFFD93D)
                                    : const Color(0xFF4ECDC4),
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

  Widget _buildPieChartCard() {
    return AnimatedBuilder(
      animation: _chartAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667EEA).withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'User Types',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 150,
                child: CustomPaint(
                  painter: PieChartPainter(
                    progress: _chartAnimation.value,
                    data: [
                      {'value': 75.0, 'color': const Color(0xFF4ECDC4), 'label': 'Active'},
                      {'value': 25.0, 'color': const Color(0xFF66D97D), 'label': 'Premium'},
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLegendItem('Active', const Color(0xFF4ECDC4)),
                  _buildLegendItem('Premium', const Color(0xFF66D97D)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF95A3B3),
          ),
        ),
      ],
    );
  }

  Widget _buildLineChartCard() {
    return AnimatedBuilder(
      animation: _chartAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667EEA).withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User Growth Trend',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                child: CustomPaint(
                  painter: LineChartPainter(
                    progress: _chartAnimation.value,
                    data: monthlyGrowth,
                    labels: monthLabels,
                  ),
                  child: Container(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBarChartCard() {
    return AnimatedBuilder(
      animation: _chartAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667EEA).withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Monthly Bookings',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                child: CustomPaint(
                  painter: BarChartPainter(
                    progress: _chartAnimation.value,
                    data: [450, 620, 780],
                  ),
                  child: Container(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentActivityCard() {
    final activities = [
      {'action': 'New user registered', 'time': '2 mins ago', 'icon': Icons.person_add},
      {'action': 'Trip booked to Paris', 'time': '15 mins ago', 'icon': Icons.flight_takeoff},
      {'action': 'Premium upgrade', 'time': '1 hour ago', 'icon': Icons.star},
      {'action': 'Review submitted', 'time': '2 hours ago', 'icon': Icons.rate_review},
      {'action': 'Payment received', 'time': '3 hours ago', 'icon': Icons.payment},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),
          ...activities.map((activity) {
            final index = activities.indexOf(activity);
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 800 + (index * 100)),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF667EEA).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            activity['icon'] as IconData,
                            size: 16,
                            color: const Color(0xFF667EEA),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activity['action'] as String,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                              Text(
                                activity['time'] as String,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF95A3B3),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildUsersView() {
    return Container(
      key: const ValueKey('users'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
                'User Management',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Add user feature coming soon!'),
                      backgroundColor: Color(0xFF667EEA),
                    ),
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add User'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667EEA),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...recentUsers.map((user) {
            final index = recentUsers.indexOf(user);
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 600 + (index * 80)),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF667EEA).withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: const Color(0xFF667EEA),
                            child: Text(
                              user['avatar'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user['name'] as String,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C3E50),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user['email'] as String,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF95A3B3),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Joined: ${user['joined']}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF95A3B3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: user['status'] == 'premium'
                                      ? const Color(0xFFFFD93D).withOpacity(0.2)
                                      : const Color(0xFF4ECDC4).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  (user['status'] as String).toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: user['status'] == 'premium'
                                        ? const Color(0xFFFFD93D)
                                        : const Color(0xFF4ECDC4),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${user['trips']} trips',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF667EEA),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, color: Color(0xFF95A3B3)),
                            onSelected: (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('$value ${user['name']}'),
                                  backgroundColor: const Color(0xFF667EEA),
                                ),
                              );
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'Edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, size: 18),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'View',
                                child: Row(
                                  children: [
                                    Icon(Icons.visibility, size: 18),
                                    SizedBox(width: 8),
                                    Text('View Details'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'Delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, size: 18, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Delete', style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                            ],
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

  Widget _buildCitiesView() {
    return Container(
      key: const ValueKey('cities'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popular Cities',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 24),
          ...cityPopularity.entries.map((entry) {
            final index = cityPopularity.keys.toList().indexOf(entry.key);
            final maxValue = cityPopularity.values.reduce(math.max);
            final percentage = (entry.value / maxValue);

            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 800 + (index * 100)),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                            Text(
                              '${entry.value} bookings',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF95A3B3),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: percentage * value,
                            minHeight: 10,
                            backgroundColor: const Color(0xFFF8F9FF),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color.lerp(
                                const Color(0xFF667EEA),
                                const Color(0xFF4ECDC4),
                                index / cityPopularity.length,
                              )!,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildActivitiesView() {
    return Container(
      key: const ValueKey('activities'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popular Activities',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
            ),
            itemCount: activityPopularity.length,
            itemBuilder: (context, index) {
              final entry = activityPopularity.entries.elementAt(index);
              final colors = [
                const Color(0xFF667EEA),
                const Color(0xFF4ECDC4),
                const Color(0xFFFFD93D),
                const Color(0xFFFF6B6B),
                const Color(0xFFB565D8),
                const Color(0xFF26D0CE),
                const Color(0xFFFF8B94),
                const Color(0xFF66D97D),
              ];

              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 600 + (index * 80)),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colors[index % colors.length],
                            colors[index % colors.length].withOpacity(0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: colors[index % colors.length].withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${entry.value}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'bookings',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// Custom Painters
class PieChartPainter extends CustomPainter {
  final double progress;
  final List<Map<String, dynamic>> data;

  PieChartPainter({required this.progress, required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    double startAngle = -math.pi / 2;
    
    for (var item in data) {
      final sweepAngle = (item['value'] as double) / 100 * 2 * math.pi * progress;
      final paint = Paint()
        ..color = item['color'] as Color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    // Draw white circle in center for donut effect
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.5, centerPaint);
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class LineChartPainter extends CustomPainter {
  final double progress;
  final List<double> data;
  final List<String> labels;

  LineChartPainter({
    required this.progress,
    required this.data,
    required this.labels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF6B6B)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = const Color(0xFFFF6B6B)
      ..style = PaintingStyle.fill;

    final maxValue = data.reduce(math.max);
    final minValue = data.reduce(math.min);
    final range = maxValue - minValue;

    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = (size.width / (data.length - 1)) * i;
      final normalizedValue = (data[i] - minValue) / range;
      final y = size.height - (normalizedValue * (size.height * 0.8)) - 20;
      points.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Draw line
    final pathMetrics = path.computeMetrics().first;
    final extractPath = pathMetrics.extractPath(
      0,
      pathMetrics.length * progress,
    );
    canvas.drawPath(extractPath, paint);

    // Draw dots and labels
    for (int i = 0; i < points.length; i++) {
      if (i / (points.length - 1) <= progress) {
        canvas.drawCircle(points[i], 6, dotPaint);
        
        // Draw labels
        final textPainter = TextPainter(
          text: TextSpan(
            text: labels[i],
            style: const TextStyle(
              color: Color(0xFF95A3B3),
              fontSize: 11,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(points[i].dx - textPainter.width / 2, size.height - 15),
        );
      }
    }
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class BarChartPainter extends CustomPainter {
  final double progress;
  final List<double> data;

  BarChartPainter({required this.progress, required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final maxValue = data.reduce(math.max);
    final barWidth = size.width / (data.length * 2);
    final spacing = barWidth * 0.5;

    for (int i = 0; i < data.length; i++) {
      final normalizedValue = data[i] / maxValue;
      final barHeight = normalizedValue * size.height * progress;
      
      final paint = Paint()
        ..color = Color.lerp(
          const Color(0xFFFFD93D),
          const Color(0xFFFF8B94),
          i / data.length,
        )!
        ..style = PaintingStyle.fill;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          (barWidth + spacing) * i + spacing,
          size.height - barHeight,
          barWidth,
          barHeight,
        ),
        const Radius.circular(8),
      );

      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(BarChartPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

