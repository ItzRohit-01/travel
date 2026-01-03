import 'package:flutter/material.dart';
import 'package:travel_app/services/auth_service.dart';
import 'package:travel_app/models/trip_model.dart';
import 'package:travel_app/services/trip_service.dart';
import 'plan_trip_page.dart';
import 'user_profile_pages.dart';
import 'search_page.dart';
import 'user_tripping_list_page.dart' show UserTripListingPage;
import 'itenary_page.dart';
import 'calander.dart';
import 'community.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _authService = AuthService();
  final _tripService = TripService();
  final _searchController = TextEditingController();
  int _selectedIndex = 0;
  List<Trip> _previousTrips = [];
  List<PopularCity> _topRegionalSelections = [];
  bool _isLoading = true;
  String? _errorMessage;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final userId = _authService.currentUser?.uid;
    if (userId == null) {
      setState(() {
        _errorMessage = 'User not authenticated. Please log in again.';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final trips = await _tripService.fetchTrips(userId);
      final cities = await _tripService.fetchPopularCities();
      if (!mounted) return;
      setState(() {
        _previousTrips = trips;
        _topRegionalSelections = cities;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onPlanTrip() async {
    final created = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PlanTripPage(),
      ),
    );

    if (created == true && mounted) {
      _loadData();
    }
  }

  void _logout() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GlobalTrotter',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          fontStyle: FontStyle.italic,
          letterSpacing: 2,
          color: Color.fromARGB(255, 0, 88, 159)),
        ),
        centerTitle: false,
        
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            tooltip: 'Calendar View',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CalendarScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: 'Community',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CommunityScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorState()
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Banner Image Section
                        Container(
                          width: double.infinity,
                          height: 180,
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.withValues(alpha: .8),
                                Colors.purple.withValues(alpha: 0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Text(
                                  'Banner Image',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              // Decorative elements
                              const Positioned(
                                top: 10,
                                right: 20,
                                child: Text(
                                  '✈️',
                                  style: TextStyle(fontSize: 32),
                                ),
                              ),
                              const Positioned(
                                bottom: 10,
                                left: 20,
                                child: Text(
                                  '🌍',
                                  style: TextStyle(fontSize: 32),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Search Bar
                        // Search Bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: _searchController,
                            readOnly: true,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SearchPage(),
                                ),
                              );
                            },
                            decoration: InputDecoration(
                              hintText: 'Search bar......',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Filter, Group, Sort buttons
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Group by clicked')),
                                    );
                                  },
                                  icon: const Icon(Icons.category, size: 18),
                                  label: const Text('Group by'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Filter clicked')),
                                    );
                                  },
                                  icon: const Icon(Icons.tune, size: 18),
                                  label: const Text('Filter'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Sort by clicked')),
                                    );
                                  },
                                  icon: const Icon(Icons.sort, size: 18),
                                  label: const Text('Sort by...'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Top Regional Selections
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Top Regional Selections',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 100,
                                child: _topRegionalSelections.isEmpty
                                    ? Center(
                                        child: Text(
                                          'No cities yet. Add some via the API.',
                                          style: TextStyle(color: Colors.grey[600]),
                                        ),
                                      )
                                    : ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _topRegionalSelections.length,
                                        itemBuilder: (context, index) {
                                          final city = _topRegionalSelections[index];
                                          return _buildRegionalSelectionCard(city);
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Previous Trips
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Previous Trips',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 180,
                                child: _previousTrips.isEmpty
                                    ? Center(
                                        child: Text(
                                          'No trips yet. Create one to see it here.',
                                          style: TextStyle(color: Colors.grey[600]),
                                        ),
                                      )
                                    : ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _previousTrips.length,
                                        itemBuilder: (context, index) {
                                          final trip = _previousTrips[index];
                                          return _buildPreviousTripCard(trip);
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Plan a Trip Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton.icon(
                                onPressed: _onPlanTrip,
                                icon: const Icon(Icons.add),
                                label: const Text('Plan a trip'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchPage(),
              ),
            );
            return;
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserTripListingPage(),
              ),
            );
            return;
          }
          if (index == 3) {
            final authUser = _authService.currentUser;
            final profileUser = authUser != null
                ? UserProfile(
                    id: authUser.uid,
                    name: authUser.displayName ?? '',
                    email: authUser.email ?? '',
                    phone: authUser.phoneNumber ?? '',
                    bio: '',
                  )
                : null;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfilePage(userProfile: profileUser),
              ),
            );
            return;
          }
          setState(() {
            _selectedIndex = index;
          });
        },
          backgroundColor: Colors.white,
  selectedItemColor: Colors.blue,        // active icon color
  unselectedItemColor: Colors.grey,      // inactive icon color
  type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'My Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
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
              _errorMessage ?? 'Something went wrong',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegionalSelectionCard(PopularCity city) {
    return SizedBox(
      width: 110,
      height: 96,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1.2,
          ),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${city.name} selected')),
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (city.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: SizedBox(
                      height: 54,
                      child: Image.network(
                        city.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.location_city, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          city.name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          city.country,
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviousTripCard(Trip trip) {
    final dateRange = '${trip.startDate.month}/${trip.startDate.day} - ${trip.endDate.month}/${trip.endDate.day}';
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
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
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (trip.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        trip.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.photo, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      trip.destination,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateRange,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
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
}