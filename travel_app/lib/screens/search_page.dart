import 'package:flutter/material.dart';

<<<<<<< HEAD
class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: const Center(child: Text('Search placeholder')),
=======
import 'package:travel_app/models/trip_model.dart';
import 'package:travel_app/services/auth_service.dart';
import 'package:travel_app/services/trip_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _authService = AuthService();
  final _tripService = TripService();
  final _searchController = TextEditingController();

  List<Trip> _trips = [];
  List<PopularCity> _cities = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        _trips = trips;
        _cities = cities;
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

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final filteredTrips = _trips.where((trip) {
      final titleMatch = trip.title.toLowerCase().contains(query);
      final destinationMatch = trip.destination.toLowerCase().contains(query);
      return query.isEmpty || titleMatch || destinationMatch;
    }).toList();

    final filteredCities = _cities.where((city) {
      final nameMatch = city.name.toLowerCase().contains(query);
      final countryMatch = city.country.toLowerCase().contains(query);
      return query.isEmpty || nameMatch || countryMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorState()
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Search trips or popular cities...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchController.text.isEmpty
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildSectionHeader('Trips', filteredTrips.length),
                      if (filteredTrips.isEmpty)
                        _buildEmptyState('No trips match this search.')
                      else
                        ...filteredTrips.map(_buildTripResult),
                      const SizedBox(height: 24),
                      _buildSectionHeader('Popular Cities', filteredCities.length),
                      if (filteredCities.isEmpty)
                        _buildEmptyState('No cities match this search.')
                      else
                        ...filteredCities.map(_buildCityResult),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          Text('$count found', style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildTripResult(Trip trip) {
    final dateRange = '${trip.startDate.month}/${trip.startDate.day} - ${trip.endDate.month}/${trip.endDate.day}';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: _buildImageThumbnail(trip.imageUrl, Icons.photo),
        title: Text(trip.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${trip.destination}\n$dateRange'),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildCityResult(PopularCity city) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: _buildImageThumbnail(city.imageUrl, Icons.location_city),
        title: Text(city.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(city.country),
      ),
    );
  }

  Widget _buildImageThumbnail(String url, IconData fallbackIcon) {
    if (url.isEmpty) {
      return CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Icon(fallbackIcon, color: Colors.grey[600]),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        url,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Icon(fallbackIcon, color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        message,
        style: TextStyle(color: Colors.grey[600]),
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
>>>>>>> a0ab94ee9a1738991159e92e8b03bf7dd86ad500
    );
  }
}
