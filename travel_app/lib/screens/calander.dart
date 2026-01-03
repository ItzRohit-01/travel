import 'package:flutter/material.dart';
import 'dart:math' as math;

class TripEvent {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final Color color;
  final String destination;
  final String type;
  final String imageUrl;
  final double price;
  final String accommodation;
  final String transportation;
  final List<String> activities;
  final List<String> participants;
  final String bookingStatus;
  final String description;

  TripEvent({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.color,
    required this.destination,
    required this.type,
    this.imageUrl = '',
    this.price = 0.0,
    this.accommodation = '',
    this.transportation = '',
    this.activities = const [],
    this.participants = const [],
    this.bookingStatus = 'Confirmed',
    this.description = '',
  });

  bool isOnDate(DateTime date) {
    return date.isAfter(startDate.subtract(const Duration(days: 1))) &&
        date.isBefore(endDate.add(const Duration(days: 1)));
  }

  bool isStartDate(DateTime date) {
    return date.year == startDate.year &&
        date.month == startDate.month &&
        date.day == startDate.day;
  }

  bool isEndDate(DateTime date) {
    return date.year == endDate.year &&
        date.month == endDate.month &&
        date.day == endDate.day;
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;

  DateTime _currentMonth = DateTime(2024, 1, 1);
  String _sortBy = 'date';
  String _groupBy = 'month';
  String _filterBy = 'all';

  List<TripEvent> allEvents = [];
  List<TripEvent> filteredEvents = [];

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

    _initializeEvents();
    filteredEvents = List.from(allEvents);
  }

  void _initializeEvents() {
    allEvents = [
      TripEvent(
        id: '1',
        title: 'PARIS TRIP',
        startDate: DateTime(2024, 1, 4),
        endDate: DateTime(2024, 1, 5),
        color: const Color(0xFF667EEA),
        destination: 'Paris, France',
        type: 'City Break',
        imageUrl: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800',
        price: 1250.00,
        accommodation: 'Le Meurice Paris - 5 Star Hotel',
        transportation: 'Air France Flight + Metro Pass',
        activities: ['Eiffel Tower Visit', 'Louvre Museum Tour', 'Seine River Cruise', 'Montmartre Walking Tour'],
        participants: ['You', 'Sarah Johnson', 'Mike Chen'],
        bookingStatus: 'Confirmed',
        description: 'Experience the magic of Paris with visits to iconic landmarks, world-class museums, and charming neighborhoods. Enjoy authentic French cuisine and immerse yourself in the city\'s rich culture.',
      ),
      TripEvent(
        id: '2',
        title: 'PARIS',
        startDate: DateTime(2024, 1, 9),
        endDate: DateTime(2024, 1, 11),
        color: const Color(0xFFFF6B6B),
        destination: 'Paris, France',
        type: 'City Break',
        imageUrl: 'https://images.unsplash.com/photo-1511739001486-6bfe10ce785f?w=800',
        price: 890.00,
        accommodation: 'Hotel Plaza Athénée',
        transportation: 'Train + Taxi',
        activities: ['Versailles Palace', 'Notre-Dame Cathedral', 'Champs-Élysées Shopping', 'French Cooking Class'],
        participants: ['You', 'Emma Wilson'],
        bookingStatus: 'Confirmed',
        description: 'A romantic Parisian getaway featuring palace tours, gourmet dining, and shopping along the famous Champs-Élysées.',
      ),
      TripEvent(
        id: '3',
        title: 'NYC - GETAWAY',
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 1, 22),
        color: const Color(0xFFFFD93D),
        destination: 'New York, USA',
        type: 'City Break',
        imageUrl: 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=800',
        price: 2100.00,
        accommodation: 'The Plaza Hotel Manhattan',
        transportation: 'Delta Airlines + NYC Subway Pass',
        activities: ['Statue of Liberty Tour', 'Broadway Show', 'Central Park Bike Tour', 'Times Square Experience', 'Brooklyn Bridge Walk', 'MoMA Visit', 'Top of the Rock'],
        participants: ['You', 'John Smith', 'Lisa Anderson', 'David Kim'],
        bookingStatus: 'Confirmed',
        description: 'The ultimate New York experience! Explore Manhattan\'s iconic landmarks, catch a Broadway show, and discover the city that never sleeps.',
      ),
      TripEvent(
        id: '4',
        title: 'JAPAN ADVENTURE',
        startDate: DateTime(2024, 1, 16),
        endDate: DateTime(2024, 1, 17),
        color: const Color(0xFF4ECDC4),
        destination: 'Tokyo, Japan',
        type: 'Adventure',
        imageUrl: 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=800',
        price: 1800.00,
        accommodation: 'Park Hyatt Tokyo',
        transportation: 'JAL Flight + JR Pass',
        activities: ['Mount Fuji Day Trip', 'Senso-ji Temple', 'Shibuya Crossing', 'Sushi Making Class', 'Akihabara Tech Tour'],
        participants: ['You', 'Amy Tanaka'],
        bookingStatus: 'Pending',
        description: 'Discover the perfect blend of ancient traditions and modern innovation in Tokyo. From temples to tech districts, experience the heart of Japan.',
      ),
      TripEvent(
        id: '5',
        title: 'NYC GETAWAY',
        startDate: DateTime(2024, 1, 23),
        endDate: DateTime(2024, 1, 23),
        color: const Color(0xFFB565D8),
        destination: 'New York, USA',
        type: 'City Break',
        imageUrl: 'https://images.unsplash.com/photo-1485871981521-5b1fd3805eee?w=800',
        price: 450.00,
        accommodation: 'Marriott Marquis',
        transportation: 'Amtrak Train',
        activities: ['Empire State Building', '9/11 Memorial', 'High Line Walk'],
        participants: ['You'],
        bookingStatus: 'Confirmed',
        description: 'A quick day trip to experience New York\'s most famous landmarks and memorials.',
      ),
    ];
  }

  void _performSearch() {
    setState(() {
      if (_searchController.text.isEmpty) {
        filteredEvents = List.from(allEvents);
      } else {
        final searchTerm = _searchController.text.toLowerCase();
        filteredEvents = allEvents.where((event) {
          return event.title.toLowerCase().contains(searchTerm) ||
              event.destination.toLowerCase().contains(searchTerm) ||
              event.type.toLowerCase().contains(searchTerm);
        }).toList();
      }
      _applyFiltersAndSort();
    });
  }

  void _applyFiltersAndSort() {
    List<TripEvent> tempEvents = List.from(filteredEvents);

    // Apply filter by type
    if (_filterBy != 'all') {
      tempEvents = tempEvents.where((event) {
        return event.type.toLowerCase() == _filterBy.toLowerCase();
      }).toList();
    }

    // Apply sort
    if (_sortBy == 'date') {
      tempEvents.sort((a, b) => a.startDate.compareTo(b.startDate));
    } else if (_sortBy == 'duration') {
      tempEvents.sort((a, b) {
        final aDuration = a.endDate.difference(a.startDate).inDays;
        final bDuration = b.endDate.difference(b.startDate).inDays;
        return bDuration.compareTo(aDuration);
      });
    } else if (_sortBy == 'destination') {
      tempEvents.sort((a, b) => a.destination.compareTo(b.destination));
    }

    setState(() {
      filteredEvents = tempEvents;
    });
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  List<DateTime> _getDaysInMonth() {
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0);

    // Get the first day to display (might be from previous month)
    int firstWeekday = firstDayOfMonth.weekday % 7; // Convert to 0-6 (Sun-Sat)
    final startDate = firstDayOfMonth.subtract(Duration(days: firstWeekday));

    // Get all days to display
    List<DateTime> days = [];
    DateTime currentDate = startDate;

    // We need 6 weeks to accommodate all months
    for (int i = 0; i < 42; i++) {
      days.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }

    return days;
  }

  List<TripEvent> _getEventsForDate(DateTime date) {
    return filteredEvents.where((event) => event.isOnDate(date)).toList();
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBookingDialog(),
        backgroundColor: const Color(0xFF667EEA),
        icon: const Icon(Icons.add_location_alt, color: Colors.white),
        label: const Text(
          'Book Trip',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
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
                icon: const Icon(Icons.person_outline, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile feature coming soon!'),
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
                  const SizedBox(height: 24),

                  // Title
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Center(
                      child: Text(
                        'Calendar View',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Calendar
                  _buildCalendar(),
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
                    ['month', 'week', 'year'],
                    (value) {
                      setState(() {
                        _groupBy = value;
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
                    ['all', 'city break', 'adventure', 'beach', 'culture'],
                    (value) {
                      setState(() {
                        _filterBy = value;
                        _performSearch();
                      });
                    },
                    Icons.filter_list,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildControlButton(
                    'Sort by...',
                    _sortBy,
                    ['date', 'duration', 'destination'],
                    (value) {
                      setState(() {
                        _sortBy = value;
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

  Widget _buildCalendar() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * value),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667EEA).withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Month Navigation
                  _buildMonthNavigation(),
                  const SizedBox(height: 24),

                  // Weekday Headers
                  _buildWeekdayHeaders(),
                  const SizedBox(height: 16),

                  // Calendar Grid
                  _buildCalendarGrid(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMonthNavigation() {
    final monthName = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ][_currentMonth.month - 1];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: _previousMonth,
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color(0xFF667EEA),
          iconSize: 20,
        ),
        TweenAnimationBuilder<double>(
          key: ValueKey(_currentMonth),
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.scale(
                scale: 0.8 + (0.2 * value),
                child: Text(
                  '$monthName ${_currentMonth.year}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ),
            );
          },
        ),
        IconButton(
          onPressed: _nextMonth,
          icon: const Icon(Icons.arrow_forward_ios),
          color: const Color(0xFF667EEA),
          iconSize: 20,
        ),
      ],
    );
  }

  Widget _buildWeekdayHeaders() {
    const weekdays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];

    return Row(
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF667EEA).withOpacity(0.7),
                letterSpacing: 0.5,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final days = _getDaysInMonth();

    return Column(
      children: List.generate(6, (weekIndex) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: List.generate(7, (dayIndex) {
              final index = weekIndex * 7 + dayIndex;
              if (index >= days.length) return const Expanded(child: SizedBox());
              
              final date = days[index];
              final events = _getEventsForDate(date);
              final isCurrentMonth = date.month == _currentMonth.month;
              final isToday = date.year == DateTime.now().year &&
                  date.month == DateTime.now().month &&
                  date.day == DateTime.now().day;

              return Expanded(
                child: _buildDayCell(
                  date,
                  events,
                  isCurrentMonth,
                  isToday,
                  index,
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildDayCell(
    DateTime date,
    List<TripEvent> events,
    bool isCurrentMonth,
    bool isToday,
    int index,
  ) {
    final hasEvents = events.isNotEmpty;
    final primaryEvent = hasEvents ? events.first : null;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 20)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: isCurrentMonth ? value : value * 0.3,
          child: InkWell(
            onTap: hasEvents
                ? () => _showEventDetails(date, events)
                : null,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 70,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: hasEvents
                    ? primaryEvent!.color.withOpacity(0.15)
                    : (isToday
                        ? const Color(0xFF667EEA).withOpacity(0.1)
                        : Colors.transparent),
                borderRadius: BorderRadius.circular(8),
                border: isToday
                    ? Border.all(
                        color: const Color(0xFF667EEA),
                        width: 2,
                      )
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                      color: isCurrentMonth
                          ? (isToday
                              ? const Color(0xFF667EEA)
                              : const Color(0xFF2C3E50))
                          : const Color(0xFFBCC3D0),
                    ),
                  ),
                  if (hasEvents) ...[
                    const SizedBox(height: 4),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: primaryEvent!.color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          primaryEvent.title,
                          style: const TextStyle(
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  if (events.length > 1)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFF667EEA),
                        shape: BoxShape.circle,
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

  void _showEventDetails(DateTime date, List<TripEvent> events) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Events on ${date.day} ${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][date.month - 1]} ${date.year}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...events.map((event) {
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _showDetailedEventView(event);
                        },
                        child: _buildEventCard(event),
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventCard(TripEvent event) {
    final duration = event.endDate.difference(event.startDate).inDays + 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: event.color.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [event.color, event.color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.flight_takeoff,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Color(0xFFFF6B6B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          event.destination,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF95A3B3),
                          ),
                        ),
                      ],
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
                  color: event.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  event.type,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: event.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoChip(
                Icons.calendar_today,
                '${event.startDate.day}/${event.startDate.month}/${event.startDate.year}',
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 16, color: Color(0xFF95A3B3)),
              const SizedBox(width: 8),
              _buildInfoChip(
                Icons.calendar_today,
                '${event.endDate.day}/${event.endDate.month}/${event.endDate.year}',
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoChip(
            Icons.access_time,
            '$duration ${duration == 1 ? 'day' : 'days'}',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF667EEA).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF667EEA)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF667EEA),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailedEventView(TripEvent event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.95,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          final duration = event.endDate.difference(event.startDate).inDays + 1;
          
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                // Header Image
                Stack(
                  children: [
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        image: event.imageUrl.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(event.imageUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.3),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                event.destination,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: event.bookingStatus == 'Confirmed'
                              ? Colors.green
                              : Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          event.bookingStatus,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Quick Info Cards
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                Icons.calendar_today,
                                'Duration',
                                '$duration ${duration == 1 ? 'Day' : 'Days'}',
                                event.color,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInfoCard(
                                Icons.attach_money,
                                'Total Cost',
                                '\$${event.price.toStringAsFixed(0)}',
                                const Color(0xFF4ECDC4),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                Icons.people,
                                'Travelers',
                                '${event.participants.length} ${event.participants.length == 1 ? 'Person' : 'People'}',
                                const Color(0xFFFF6B6B),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildInfoCard(
                                Icons.category,
                                'Type',
                                event.type,
                                const Color(0xFFFFD93D),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Description
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          event.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF95A3B3),
                            height: 1.6,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Travel Dates
                        _buildDetailSection(
                          'Travel Dates',
                          Icons.date_range,
                          event.color,
                          [
                            _buildDetailRow('Check-in', '${event.startDate.day}/${event.startDate.month}/${event.startDate.year}'),
                            _buildDetailRow('Check-out', '${event.endDate.day}/${event.endDate.month}/${event.endDate.year}'),
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Accommodation
                        if (event.accommodation.isNotEmpty)
                          _buildDetailSection(
                            'Accommodation',
                            Icons.hotel,
                            const Color(0xFF4ECDC4),
                            [_buildDetailRow('Hotel', event.accommodation)],
                          ),
                        
                        const SizedBox(height: 20),
                        
                        // Transportation
                        if (event.transportation.isNotEmpty)
                          _buildDetailSection(
                            'Transportation',
                            Icons.flight,
                            const Color(0xFFFF6B6B),
                            [_buildDetailRow('Details', event.transportation)],
                          ),
                        
                        const SizedBox(height: 20),
                        
                        // Activities
                        if (event.activities.isNotEmpty)
                          _buildDetailSection(
                            'Planned Activities (${event.activities.length})',
                            Icons.local_activity,
                            const Color(0xFFFFD93D),
                            event.activities.map((activity) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFFD93D),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        activity,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF2C3E50),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        
                        const SizedBox(height: 20),
                        
                        // Participants
                        if (event.participants.isNotEmpty)
                          _buildDetailSection(
                            'Travelers',
                            Icons.people,
                            const Color(0xFFB565D8),
                            [
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: event.participants.map((participant) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFB565D8).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: const Color(0xFFB565D8).withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(
                                          radius: 12,
                                          backgroundColor: const Color(0xFFB565D8),
                                          child: Text(
                                            participant[0],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          participant,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF2C3E50),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        
                        const SizedBox(height: 32),
                        
                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Edit feature coming soon!'),
                                      backgroundColor: Color(0xFF667EEA),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.edit, color: Colors.white),
                                label: const Text('Edit Trip'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF667EEA),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Cancel Booking'),
                                      content: const Text(
                                        'Are you sure you want to cancel this trip?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              allEvents.removeWhere((e) => e.id == event.id);
                                              filteredEvents = List.from(allEvents);
                                            });
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Trip cancelled successfully'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'Yes, Cancel',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.cancel, color: Colors.red),
                                label: const Text('Cancel'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF95A3B3),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(
    String title,
    IconData icon,
    Color color,
    List<Widget> children,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF95A3B3),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingDialog() {
    final titleController = TextEditingController();
    final destinationController = TextEditingController();
    final priceController = TextEditingController();
    final accommodationController = TextEditingController();
    final transportationController = TextEditingController();
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now().add(const Duration(days: 1));
    String selectedType = 'City Break';
    Color selectedColor = const Color(0xFF667EEA);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add_location_alt, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Text('Book New Trip'),
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Trip Title',
                      prefixIcon: const Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: destinationController,
                    decoration: InputDecoration(
                      labelText: 'Destination',
                      prefixIcon: const Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedType,
                    decoration: InputDecoration(
                      labelText: 'Trip Type',
                      prefixIcon: const Icon(Icons.category),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: ['City Break', 'Adventure', 'Beach', 'Culture', 'Nature']
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          selectedType = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: startDate,
                              firstDate: DateTime(2024),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              setDialogState(() {
                                startDate = picked;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Start Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${startDate.day}/${startDate.month}/${startDate.year}'),
                                const Icon(Icons.calendar_today, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: endDate,
                              firstDate: startDate,
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              setDialogState(() {
                                endDate = picked;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'End Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${endDate.day}/${endDate.month}/${endDate.year}'),
                                const Icon(Icons.calendar_today, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Total Price (USD)',
                      prefixIcon: const Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: accommodationController,
                    decoration: InputDecoration(
                      labelText: 'Accommodation (Optional)',
                      prefixIcon: const Icon(Icons.hotel),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: transportationController,
                    decoration: InputDecoration(
                      labelText: 'Transportation (Optional)',
                      prefixIcon: const Icon(Icons.flight),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Choose Color:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    children: [
                      const Color(0xFF667EEA),
                      const Color(0xFFFF6B6B),
                      const Color(0xFFFFD93D),
                      const Color(0xFF4ECDC4),
                      const Color(0xFFB565D8),
                      const Color(0xFF26D0CE),
                      const Color(0xFFFF8B94),
                    ].map((color) {
                      return InkWell(
                        onTap: () {
                          setDialogState(() {
                            selectedColor = color;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedColor == color
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty ||
                    destinationController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in required fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final newEvent = TripEvent(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text.toUpperCase(),
                  startDate: startDate,
                  endDate: endDate,
                  color: selectedColor,
                  destination: destinationController.text,
                  type: selectedType,
                  imageUrl: 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800',
                  price: double.tryParse(priceController.text) ?? 0.0,
                  accommodation: accommodationController.text,
                  transportation: transportationController.text,
                  activities: [],
                  participants: ['You'],
                  bookingStatus: 'Confirmed',
                  description: 'A wonderful trip to ${destinationController.text}. Explore, discover, and create unforgettable memories!',
                );

                setState(() {
                  allEvents.add(newEvent);
                  filteredEvents = List.from(allEvents);
                  _applyFiltersAndSort();
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Trip booked successfully! 🎉'),
                    backgroundColor: selectedColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                // Navigate to the booked month
                setState(() {
                  _currentMonth = DateTime(startDate.year, startDate.month, 1);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF667EEA),
                foregroundColor: Colors.white,
              ),
              child: const Text('Book Trip'),
            ),
          ],
        ),
      ),
    );
  }
}

