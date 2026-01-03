import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:travel_app/models/trip_model.dart';
import 'package:travel_app/services/auth_service.dart';
import 'package:travel_app/services/trip_service.dart';
import 'itenary_view_screen.dart';
import 'itenary_page.dart';

class UserTripListingPage extends StatefulWidget {
  const UserTripListingPage({super.key});

  @override
  State<UserTripListingPage> createState() => _UserTripListingPageState();
}

class _UserTripListingPageState extends State<UserTripListingPage> {
  final _authService = AuthService();
  final _tripService = TripService();
  final TextEditingController _searchController = TextEditingController();
  
  String _sortBy = 'date'; // date, budget, name
  String _groupBy = 'status'; // status, destination
  String _filterStatus = 'all'; // all, ongoing, upcoming, completed

  List<Trip> allTrips = [];
  List<Trip> filteredTrips = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) {
      setState(() => _error = 'User not authenticated. Please log in.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final trips = await _tripService.fetchTrips(userId);

      // Normalize statuses to align with UI buckets
      List<Trip> normalized = trips
          .map(
            (t) => Trip(
              id: t.id,
              userId: t.userId,
              title: t.title,
              destination: t.destination,
              startDate: t.startDate,
              endDate: t.endDate,
              imageUrl: t.imageUrl,
              status: (t.status.isNotEmpty ? t.status.toLowerCase() : 'planned'),
            ),
          )
          .toList();

      setState(() {
        allTrips = normalized;
        filteredTrips = List.from(normalized);
      });
      _applyFilters();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _applyFilters() {
    List<Trip> temp = List.from(allTrips);

    // Search filter
    if (_searchController.text.isNotEmpty) {
      temp = temp
          .where((trip) =>
              trip.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
              trip.destination.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    }

    // Status filter
    if (_filterStatus != 'all') {
      temp = temp.where((trip) => trip.status.toLowerCase() == _filterStatus).toList();
    }

    // Sort
    if (_sortBy == 'date') {
      temp.sort((a, b) => a.startDate.compareTo(b.startDate));
    } else if (_sortBy == 'budget') {
      // No budget from API; keep stable order
    } else if (_sortBy == 'name') {
      temp.sort((a, b) => a.title.compareTo(b.title));
    }

    setState(() {
      filteredTrips = temp;
    });
  }

  String _getStatusEmoji(String status) {
    switch (status.toLowerCase()) {
      case 'ongoing':
        return '🏃';
      case 'upcoming':
        return '⏰';
      case 'completed':
        return '✅';
      case 'planned':
        return '🗺️';
      default:
        return '📍';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'ongoing':
        return const Color(0xFF667EEA);
      case 'upcoming':
        return const Color(0xFFFFD93D);
      case 'completed':
        return const Color(0xFF6BCB77);
      case 'planned':
        return const Color(0xFF95A3B3);
      default:
        return const Color(0xFF95A3B3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorState()
              : CustomScrollView(
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
            ['all', 'planned', 'ongoing', 'upcoming', 'completed'],
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
    final statusList = ['planned', 'ongoing', 'upcoming', 'completed'];
    final statusLabels = {
      'planned': 'Planned',
      'ongoing': 'Ongoing',
      'upcoming': 'Up-coming',
      'completed': 'Completed',
    };

    return statusList.map((status) {
      final trips = filteredTrips.where((trip) => trip.status.toLowerCase() == status).toList();
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItineraryViewScreen(
                  destination: trip.destination,
                  startDate: DateFormat('MMM dd, yyyy').format(trip.startDate),
                  endDate: DateFormat('MMM dd, yyyy').format(trip.endDate),
                ),
              ),
            );
          },
          onLongPress: () => _showTripDetails(trip),
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
                            trip.title,
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
                        '${_getStatusEmoji(trip.status)} ${trip.status.isNotEmpty ? trip.status[0].toUpperCase() + trip.status.substring(1) : 'Planned'}',
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

                // Description (fallback to destination since API lacks description)
                Text(
                  trip.destination,
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
                        '—',
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
                trip.title,
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
                trip.status.isNotEmpty
                    ? trip.status[0].toUpperCase() + trip.status.substring(1)
                    : 'Planned',
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
                'Not provided',
              ),
              const SizedBox(height: 12),
                _buildDetailRow(Icons.description, 'Title', trip.title),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItineraryViewScreen(
                    destination: trip.destination,
                    startDate: DateFormat('MMM dd, yyyy').format(trip.startDate),
                    endDate: DateFormat('MMM dd, yyyy').format(trip.endDate),
                  ),
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
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItineraryPage(
                    tripName: trip.title,
                    tripStartDate: trip.startDate,
                    tripEndDate: trip.endDate,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF764BA2),
            ),
            icon: const Icon(Icons.edit, color: Colors.white, size: 16),
            label: const Text(
              'Edit',
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

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error ?? 'Something went wrong',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadTrips,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
