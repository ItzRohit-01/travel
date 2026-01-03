import 'package:flutter/material.dart';

class ItineraryActivity {
  String id;
  String activity;
  double expense;
  String category;
  TimeOfDay time;
  bool isCompleted;

  ItineraryActivity({
    required this.id,
    required this.activity,
    required this.expense,
    required this.category,
    required this.time,
    this.isCompleted = false,
  });

  ItineraryActivity copyWith({
    String? id,
    String? activity,
    double? expense,
    String? category,
    TimeOfDay? time,
    bool? isCompleted,
  }) {
    return ItineraryActivity(
      id: id ?? this.id,
      activity: activity ?? this.activity,
      expense: expense ?? this.expense,
      category: category ?? this.category,
      time: time ?? this.time,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class DayItinerary {
  int dayNumber;
  String date;
  List<ItineraryActivity> activities;
  String notes;

  DayItinerary({
    required this.dayNumber,
    required this.date,
    required this.activities,
    this.notes = '',
  });

  double get totalExpense {
    return activities.fold(0.0, (sum, activity) => sum + activity.expense);
  }
}

class ItineraryViewScreen extends StatefulWidget {
  final String destination;
  final String startDate;
  final String endDate;

  const ItineraryViewScreen({
    super.key,
    this.destination = 'Paris, France',
    this.startDate = 'Jan 15, 2026',
    this.endDate = 'Jan 20, 2026',
  });

  @override
  State<ItineraryViewScreen> createState() => _ItineraryViewScreenState();
}

class _ItineraryViewScreenState extends State<ItineraryViewScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;

  String _groupBy = 'day';
  String _filterBy = 'all';
  String _sortBy = 'time';

  List<DayItinerary> allDays = [];
  List<DayItinerary> filteredDays = [];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _fadeController.forward();
    _slideController.forward();

    _initializeItinerary();
    filteredDays = List.from(allDays);
    _applyFiltersAndSort();
  }

  void _initializeItinerary() {
    allDays = [
      DayItinerary(
        dayNumber: 1,
        date: 'Jan 15, 2026',
        notes: 'Arrival day - Take it easy',
        activities: [
          ItineraryActivity(
            id: '1-1',
            activity: 'Airport Pickup and Hotel Check-in',
            expense: 50.0,
            category: 'Transport',
            time: const TimeOfDay(hour: 10, minute: 0),
          ),
          ItineraryActivity(
            id: '1-2',
            activity: 'Lunch at Le Café de Paris',
            expense: 45.0,
            category: 'Food',
            time: const TimeOfDay(hour: 13, minute: 0),
          ),
          ItineraryActivity(
            id: '1-3',
            activity: 'Eiffel Tower Visit',
            expense: 28.0,
            category: 'Sightseeing',
            time: const TimeOfDay(hour: 15, minute: 30),
          ),
          ItineraryActivity(
            id: '1-4',
            activity: 'Seine River Cruise',
            expense: 35.0,
            category: 'Sightseeing',
            time: const TimeOfDay(hour: 18, minute: 0),
          ),
          ItineraryActivity(
            id: '1-5',
            activity: 'Dinner at Bistro Parisien',
            expense: 65.0,
            category: 'Food',
            time: const TimeOfDay(hour: 20, minute: 0),
          ),
        ],
      ),
      DayItinerary(
        dayNumber: 2,
        date: 'Jan 16, 2026',
        notes: 'Museum day',
        activities: [
          ItineraryActivity(
            id: '2-1',
            activity: 'Breakfast at Hotel',
            expense: 20.0,
            category: 'Food',
            time: const TimeOfDay(hour: 8, minute: 0),
          ),
          ItineraryActivity(
            id: '2-2',
            activity: 'Louvre Museum Tour',
            expense: 85.0,
            category: 'Culture',
            time: const TimeOfDay(hour: 9, minute: 30),
          ),
          ItineraryActivity(
            id: '2-3',
            activity: 'Lunch at Museum Café',
            expense: 35.0,
            category: 'Food',
            time: const TimeOfDay(hour: 13, minute: 0),
          ),
          ItineraryActivity(
            id: '2-4',
            activity: 'Musée d\'Orsay Visit',
            expense: 28.0,
            category: 'Culture',
            time: const TimeOfDay(hour: 15, minute: 0),
          ),
          ItineraryActivity(
            id: '2-5',
            activity: 'Dinner at Latin Quarter',
            expense: 55.0,
            category: 'Food',
            time: const TimeOfDay(hour: 19, minute: 30),
          ),
        ],
      ),
      DayItinerary(
        dayNumber: 3,
        date: 'Jan 17, 2026',
        notes: 'Shopping and culture',
        activities: [
          ItineraryActivity(
            id: '3-1',
            activity: 'Breakfast at Café',
            expense: 18.0,
            category: 'Food',
            time: const TimeOfDay(hour: 8, minute: 30),
          ),
          ItineraryActivity(
            id: '3-2',
            activity: 'Champs-Élysées Shopping',
            expense: 150.0,
            category: 'Shopping',
            time: const TimeOfDay(hour: 10, minute: 0),
          ),
          ItineraryActivity(
            id: '3-3',
            activity: 'Arc de Triomphe',
            expense: 15.0,
            category: 'Sightseeing',
            time: const TimeOfDay(hour: 14, minute: 0),
          ),
          ItineraryActivity(
            id: '3-4',
            activity: 'Montmartre Walking Tour',
            expense: 25.0,
            category: 'Culture',
            time: const TimeOfDay(hour: 16, minute: 0),
          ),
          ItineraryActivity(
            id: '3-5',
            activity: 'Dinner with Moulin Rouge Show',
            expense: 120.0,
            category: 'Entertainment',
            time: const TimeOfDay(hour: 19, minute: 0),
          ),
        ],
      ),
      DayItinerary(
        dayNumber: 4,
        date: 'Jan 18, 2026',
        notes: 'Day trip to Versailles',
        activities: [
          ItineraryActivity(
            id: '4-1',
            activity: 'Early Breakfast',
            expense: 15.0,
            category: 'Food',
            time: const TimeOfDay(hour: 7, minute: 0),
          ),
          ItineraryActivity(
            id: '4-2',
            activity: 'Train to Versailles',
            expense: 20.0,
            category: 'Transport',
            time: const TimeOfDay(hour: 8, minute: 30),
          ),
          ItineraryActivity(
            id: '4-3',
            activity: 'Palace of Versailles Tour',
            expense: 95.0,
            category: 'Sightseeing',
            time: const TimeOfDay(hour: 10, minute: 0),
          ),
          ItineraryActivity(
            id: '4-4',
            activity: 'Gardens Exploration',
            expense: 0.0,
            category: 'Sightseeing',
            time: const TimeOfDay(hour: 14, minute: 0),
          ),
          ItineraryActivity(
            id: '4-5',
            activity: 'Return and Dinner in Paris',
            expense: 50.0,
            category: 'Food',
            time: const TimeOfDay(hour: 19, minute: 0),
          ),
        ],
      ),
      DayItinerary(
        dayNumber: 5,
        date: 'Jan 19, 2026',
        notes: 'Relaxation and final shopping',
        activities: [
          ItineraryActivity(
            id: '5-1',
            activity: 'Late Breakfast',
            expense: 22.0,
            category: 'Food',
            time: const TimeOfDay(hour: 9, minute: 30),
          ),
          ItineraryActivity(
            id: '5-2',
            activity: 'Notre-Dame Area Walk',
            expense: 0.0,
            category: 'Sightseeing',
            time: const TimeOfDay(hour: 11, minute: 0),
          ),
          ItineraryActivity(
            id: '5-3',
            activity: 'Lunch at Le Marais',
            expense: 40.0,
            category: 'Food',
            time: const TimeOfDay(hour: 13, minute: 30),
          ),
          ItineraryActivity(
            id: '5-4',
            activity: 'Souvenir Shopping',
            expense: 80.0,
            category: 'Shopping',
            time: const TimeOfDay(hour: 15, minute: 0),
          ),
          ItineraryActivity(
            id: '5-5',
            activity: 'Farewell Dinner at Rooftop Restaurant',
            expense: 95.0,
            category: 'Food',
            time: const TimeOfDay(hour: 20, minute: 0),
          ),
        ],
      ),
    ];
  }

  void _performSearch() {
    setState(() {
      if (_searchController.text.isEmpty) {
        filteredDays = List.from(allDays);
      } else {
        final searchTerm = _searchController.text.toLowerCase();
        filteredDays = allDays.map((day) {
          final matchingActivities = day.activities.where((activity) {
            return activity.activity.toLowerCase().contains(searchTerm) ||
                activity.category.toLowerCase().contains(searchTerm);
          }).toList();

          if (matchingActivities.isNotEmpty) {
            return DayItinerary(
              dayNumber: day.dayNumber,
              date: day.date,
              notes: day.notes,
              activities: matchingActivities,
            );
          }
          return null;
        }).whereType<DayItinerary>().toList();
      }
      _applyFiltersAndSort();
    });
  }

  void _applyFiltersAndSort() {
    List<DayItinerary> tempDays = List.from(filteredDays);

    // Apply filter by category
    if (_filterBy != 'all') {
      tempDays = tempDays.map((day) {
        final filteredActivities = day.activities.where((activity) {
          return activity.category.toLowerCase() == _filterBy.toLowerCase();
        }).toList();

        if (filteredActivities.isNotEmpty) {
          return DayItinerary(
            dayNumber: day.dayNumber,
            date: day.date,
            notes: day.notes,
            activities: filteredActivities,
          );
        }
        return null;
      }).whereType<DayItinerary>().toList();
    }

    // Apply sort
    for (var day in tempDays) {
      if (_sortBy == 'time') {
        day.activities.sort((a, b) {
          final aMinutes = a.time.hour * 60 + a.time.minute;
          final bMinutes = b.time.hour * 60 + b.time.minute;
          return aMinutes.compareTo(bMinutes);
        });
      } else if (_sortBy == 'expense') {
        day.activities.sort((a, b) => b.expense.compareTo(a.expense));
      } else if (_sortBy == 'category') {
        day.activities.sort((a, b) => a.category.compareTo(b.category));
      }
    }

    // Apply grouping
    if (_groupBy == 'category') {
      // Group activities by category across all days
      Map<String, List<ItineraryActivity>> categoryGroups = {};
      for (var day in tempDays) {
        for (var activity in day.activities) {
          categoryGroups.putIfAbsent(activity.category, () => []);
          categoryGroups[activity.category]!.add(activity);
        }
      }
    } else if (_groupBy == 'expense') {
      // Sort days by total expense
      tempDays.sort((a, b) => b.totalExpense.compareTo(a.totalExpense));
    }

    setState(() {
      filteredDays = tempDays;
    });
  }

  void _addActivity(int dayIndex) {
    setState(() {
      final day = filteredDays[dayIndex];
      final newActivity = ItineraryActivity(
        id: '${day.dayNumber}-${day.activities.length + 1}',
        activity: 'New Activity',
        expense: 0.0,
        category: 'Other',
        time: const TimeOfDay(hour: 12, minute: 0),
      );
      day.activities.add(newActivity);
    });
  }

  void _removeActivity(int dayIndex, int activityIndex) {
    setState(() {
      filteredDays[dayIndex].activities.removeAt(activityIndex);
    });
  }

  void _editActivity(int dayIndex, int activityIndex) {
    final activity = filteredDays[dayIndex].activities[activityIndex];
    final activityController = TextEditingController(text: activity.activity);
    final expenseController =
        TextEditingController(text: activity.expense.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF8F9FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Edit Activity',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: activityController,
              decoration: InputDecoration(
                labelText: 'Activity Name',
                labelStyle: const TextStyle(color: Color(0xFF667EEA)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF667EEA)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF667EEA), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: expenseController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Expense (\$)',
                labelStyle: const TextStyle(color: Color(0xFF667EEA)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF667EEA)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF667EEA), width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF95A3B3)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                filteredDays[dayIndex].activities[activityIndex] =
                    activity.copyWith(
                  activity: activityController.text,
                  expense: double.tryParse(expenseController.text) ?? 0.0,
                );
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667EEA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalBudget = filteredDays.fold(
      0.0,
      (sum, day) => sum + day.totalExpense,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: CustomScrollView(
        slivers: [
          // Header with gradient
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'GlobalTrotter',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.destination,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
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
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Add new day feature coming soon!'),
                      backgroundColor: Color(0xFF667EEA),
                    ),
                  );
                },
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
                  // Search Bar
                  _buildSearchBar(),
                  const SizedBox(height: 16),

                  // Control Buttons
                  _buildControlButtons(),
                  const SizedBox(height: 16),

                  // Budget Summary Card
                  _buildBudgetSummary(totalBudget),
                  const SizedBox(height: 24),

                  // Title
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Text(
                      'Itinerary for Selected Place',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Days List
                  ...filteredDays.asMap().entries.map((entry) {
                    int dayIndex = entry.key;
                    DayItinerary day = entry.value;
                    return _buildDaySection(day, dayIndex);
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TweenAnimationBuilder<double>(
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
              onChanged: (_) => _performSearch(),
              decoration: InputDecoration(
                hintText: 'Search activities...',
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
                          _searchController.clear();
                          _performSearch();
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlButtons() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Row(
              children: [
                Expanded(
                  child: _buildControlButton(
                    'Group by',
                    _groupBy,
                    ['day', 'category', 'expense'],
                    (val) {
                      setState(() {
                        _groupBy = val;
                        _performSearch();
                      });
                    },
                    Icons.group_work,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildControlButton(
                    'Filter',
                    _filterBy,
                    ['all', 'food', 'transport', 'sightseeing', 'culture', 'shopping'],
                    (val) {
                      setState(() {
                        _filterBy = val;
                        _performSearch();
                      });
                    },
                    Icons.filter_list,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildControlButton(
                    'Sort by',
                    _sortBy,
                    ['time', 'expense', 'category'],
                    (val) {
                      setState(() {
                        _sortBy = val;
                        _performSearch();
                      });
                    },
                    Icons.sort,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlButton(
    String label,
    String value,
    List<String> options,
    Function(String) onChanged,
    IconData icon,
  ) {
    return Container(
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
                  child: Text(
                    val[0].toUpperCase() + val.substring(1),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetSummary(double totalBudget) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667EEA).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Budget',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Trip Expenses',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '\$${totalBudget.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBudgetStat(
                      'Days',
                      filteredDays.length.toString(),
                      Icons.calendar_today,
                    ),
                    _buildBudgetStat(
                      'Activities',
                      filteredDays
                          .fold(0, (sum, day) => sum + day.activities.length)
                          .toString(),
                      Icons.local_activity,
                    ),
                    _buildBudgetStat(
                      'Avg/Day',
                      '\$${(totalBudget / (filteredDays.isEmpty ? 1 : filteredDays.length)).toStringAsFixed(0)}',
                      Icons.attach_money,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBudgetStat(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDaySection(DayItinerary day, int dayIndex) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 800 + (dayIndex * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(50 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Day Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF667EEA).withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          'Day ${day.dayNumber}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              day.date,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                            if (day.notes.isNotEmpty)
                              Text(
                                day.notes,
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
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6BCB77).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF6BCB77),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          '\$${day.totalExpense.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6BCB77),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Color(0xFF667EEA)),
                        onPressed: () => _addActivity(dayIndex),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Activity Cards with Connectors
                  ...day.activities.asMap().entries.map((entry) {
                    int activityIndex = entry.key;
                    ItineraryActivity activity = entry.value;
                    bool isLast = activityIndex == day.activities.length - 1;

                    return Column(
                      children: [
                        _buildActivityCard(
                          activity,
                          dayIndex,
                          activityIndex,
                        ),
                        if (!isLast) _buildConnector(),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActivityCard(
    ItineraryActivity activity,
    int dayIndex,
    int activityIndex,
  ) {
    final categoryColors = {
      'Food': const Color(0xFFFF6B6B),
      'Transport': const Color(0xFF4ECDC4),
      'Sightseeing': const Color(0xFFFFD93D),
      'Culture': const Color(0xFF667EEA),
      'Shopping': const Color(0xFFFF8C94),
      'Entertainment': const Color(0xFFB565D8),
      'Other': const Color(0xFF95A3B3),
    };

    final categoryColor =
        categoryColors[activity.category] ?? const Color(0xFF95A3B3);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (activityIndex * 80)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * value),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: categoryColor.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Time
                  Container(
                    width: 60,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: categoryColor,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${activity.time.hour.toString().padLeft(2, '0')}:${activity.time.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: categoryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Activity Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                activity.activity,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2C3E50),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: categoryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                activity.category,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: categoryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.attach_money,
                              size: 16,
                              color: const Color(0xFF6BCB77),
                            ),
                            Text(
                              '\$${activity.expense.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6BCB77),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Actions
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        color: const Color(0xFF667EEA),
                        onPressed: () => _editActivity(dayIndex, activityIndex),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(height: 8),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        color: const Color(0xFFFF6B6B),
                        onPressed: () => _removeActivity(dayIndex, activityIndex),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
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
  }

  Widget _buildConnector() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            children: [
              const SizedBox(width: 30),
              Container(
                width: 2,
                height: 30 * value,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF667EEA).withOpacity(0.3),
                      const Color(0xFF764BA2).withOpacity(0.3),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_downward,
                size: 16,
                color: const Color(0xFF667EEA).withOpacity(0.5 * value),
              ),
            ],
          ),
        );
      },
    );
  }
}
