import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Trip {
  final String id;
  final String name;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final double budget;
  final String status; // ongoing, upcoming, completed
  final String description;
  final String imageUrl;

  Trip({
    required this.id,
    required this.name,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.status,
    required this.description,
    this.imageUrl = '🌍',
  });
}

class UserTripListingPage extends StatefulWidget {
  const UserTripListingPage({Key? key}) : super(key: key);

  @override
  State<UserTripListingPage> createState() => _UserTripListingPageState();
}

class _UserTripListingPageState extends State<UserTripListingPage> {
  final TextEditingController _searchController = TextEditingController();
  
  String _sortBy = 'date'; // date, budget, name
  String _groupBy = 'status'; // status, destination
  String _filterStatus = 'all'; // all, ongoing, upcoming, completed

  late List<Trip> allTrips;
  late List<Trip> filteredTrips;

  @override
  void initState() {
    super.initState();
    _initializeTrips();
    filteredTrips = List.from(allTrips);
  }

  void _initializeTrips() {
    allTrips = [
      Trip(
        id: '1',
        name: 'Paris City Break',
        destination: 'Paris, France',
        startDate: DateTime(2026, 1, 5),
        endDate: DateTime(2026, 1, 12),
        budget: 1500,
        status: 'ongoing',
        description: 'A wonderful week exploring the City of Light',
      ),
      Trip(
        id: '2',
        name: 'Tokyo Adventure',
        destination: 'Tokyo, Japan',
        startDate: DateTime(2026, 3, 15),
        endDate: DateTime(2026, 3, 28),
        budget: 2500,
        status: 'upcoming',
        description: 'Experience the vibrant culture and modern Tokyo',
      ),
      Trip(
        id: '3',
        name: 'Barcelona Beach',
        destination: 'Barcelona, Spain',
        startDate: DateTime(2026, 2, 10),
        endDate: DateTime(2026, 2, 18),
        budget: 1200,
        status: 'upcoming',
        description: 'Enjoy the beaches and architecture of Barcelona',
      ),
      Trip(
        id: '4',
        name: 'New York Business',
        destination: 'New York, USA',
        startDate: DateTime(2025, 11, 1),
        endDate: DateTime(2025, 11, 8),
        budget: 1800,
        status: 'completed',
        description: 'A successful business trip to the Big Apple',
      ),
      Trip(
        id: '5',
        name: 'Bali Relaxation',
        destination: 'Bali, Indonesia',
        startDate: DateTime(2025, 10, 5),
        endDate: DateTime(2025, 10, 15),
        budget: 900,
        status: 'completed',
        description: 'Perfect getaway for relaxation and rejuvenation',
      ),
      Trip(
        id: '6',
        name: 'Dubai Luxury',
        destination: 'Dubai, UAE',
        startDate: DateTime(2026, 2, 20),
        endDate: DateTime(2026, 2, 27),
        budget: 3000,
        status: 'upcoming',
        description: 'Experience luxury shopping and world-class hotels',
      ),
    ];
  }

  void _applyFilters() {
    List<Trip> temp = List.from(allTrips);

    // Search filter
    if (_searchController.text.isNotEmpty) {
      temp = temp
          .where((trip) =>
              trip.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
              trip.destination.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    }

    // Status filter
    if (_filterStatus != 'all') {
      temp = temp.where((trip) => trip.status == _filterStatus).toList();
    }

    // Sort
    if (_sortBy == 'date') {
      temp.sort((a, b) => a.startDate.compareTo(b.startDate));
    } else if (_sortBy == 'budget') {
      temp.sort((a, b) => b.budget.compareTo(a.budget));
    } else if (_sortBy == 'name') {
      temp.sort((a, b) => a.name.compareTo(b.name));
    }

    setState(() {
      filteredTrips = temp;
    });
  }

  String _getStatusEmoji(String status) {
    switch (status) {
      case 'ongoing':
        return '🏃';
      case 'upcoming':
        return '⏰';
      case 'completed':
        return '✅';
      default:
        return '📍';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ongoing':
        return const Color(0xFF667EEA);
      case 'upcoming':
        return const Color(0xFFFFD93D);
      case 'completed':
        return const Color(0xFF6BCB77);
      default:
        return const Color(0xFF95A3B3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 120,
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

                  // Trips by Status
                  if (_groupBy == 'status') ..._buildTripsByStatus(),
                  if (_groupBy == 'destination') ..._buildTripsByDestination(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => _applyFilters(),
        decoration: InputDecoration(
          hintText: 'Search trip...',
          prefixIcon: const Icon(Icons.search, color: Color(0xFF667EEA)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildDropdownButton(
            'Group by',
            _groupBy,
            ['status', 'destination'],
            (value) {
              setState(() => _groupBy = value);
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDropdownButton(
            'Filter',
            _filterStatus,
            ['all', 'ongoing', 'upcoming', 'completed'],
            (value) {
              setState(() => _filterStatus = value);
              _applyFilters();
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDropdownButton(
            'Sort by',
            _sortBy,
            ['date', 'budget', 'name'],
            (value) {
              setState(() => _sortBy = value);
              _applyFilters();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownButton(
    String label,
    String value,
    List<String> options,
    Function(String) onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFE0E7FF),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        value: value,
        onChanged: (String? newValue) {
          if (newValue != null) onChanged(newValue);
        },
        isExpanded: true,
        underline: const SizedBox(),
        items: options.map<DropdownMenuItem<String>>((String val) {
          return DropdownMenuItem<String>(
            value: val,
            child: Text(
              val[0].toUpperCase() + val.substring(1),
              style: const TextStyle(fontSize: 12),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Widget> _buildTripsByStatus() {
    final statusList = ['ongoing', 'upcoming', 'completed'];
    final statusLabels = {
      'ongoing': 'Ongoing',
      'upcoming': 'Up-coming',
      'completed': 'Completed',
    };

    return statusList.map((status) {
      final trips = filteredTrips.where((trip) => trip.status == status).toList();
      if (trips.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            statusLabels[status] ?? status,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 12),
          ...trips.map((trip) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildTripCard(trip),
              )),
          const SizedBox(height: 24),
        ],
      );
    }).toList();
  }

  List<Widget> _buildTripsByDestination() {
    final destinations = <String>{};
    for (var trip in filteredTrips) {
      destinations.add(trip.destination);
    }

    return destinations.toList().asMap().entries.map((entry) {
      final destination = entry.value;
      final trips = filteredTrips.where((trip) => trip.destination == destination).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            destination,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 12),
          ...trips.map((trip) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildTripCard(trip),
              )),
          const SizedBox(height: 24),
        ],
      );
    }).toList();
  }

  Widget _buildTripCard(Trip trip) {
    final statusColor = _getStatusColor(trip.status);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showTripDetails(trip),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 14, color: Color(0xFF95A3B3)),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  trip.destination,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF95A3B3),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_getStatusEmoji(trip.status)} ${trip.status[0].toUpperCase() + trip.status.substring(1)}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  trip.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5A6C7D),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 12, color: Color(0xFF95A3B3)),
                        const SizedBox(width: 4),
                        Text(
                          '${DateFormat('dd MMM').format(trip.startDate)} - ${DateFormat('dd MMM').format(trip.endDate)}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF95A3B3),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '\$${trip.budget.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTripDetails(Trip trip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                trip.name,
                style: const TextStyle(
                  color: Color(0xFF667EEA),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _getStatusColor(trip.status).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                trip.status[0].toUpperCase() + trip.status.substring(1),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _getStatusColor(trip.status),
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(Icons.location_on, 'Destination', trip.destination),
              const SizedBox(height: 12),
              _buildDetailRow(
                Icons.calendar_today,
                'Dates',
                '${DateFormat('dd MMM yyyy').format(trip.startDate)} - ${DateFormat('dd MMM yyyy').format(trip.endDate)}',
              ),
              const SizedBox(height: 12),
              _buildDetailRow(
                Icons.attach_money,
                'Budget',
                '\$${trip.budget.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.description, 'Description', trip.description),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opening ${trip.name} itinerary...'),
                  backgroundColor: const Color(0xFF667EEA),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667EEA),
            ),
            child: const Text(
              'View Itinerary',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF667EEA)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF95A3B3),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF2C3E50),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
