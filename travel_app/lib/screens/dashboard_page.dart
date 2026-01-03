import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/trip_model.dart';
import 'plan_trip_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _authService = AuthService();
  final _searchController = TextEditingController();
  int _selectedIndex = 0;

  // Sample data for previous trips
  final List<Trip> previousTrips = [
    Trip(
      id: '1',
      title: 'Paris Adventure',
      destination: 'Paris, France',
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now().subtract  (const Duration(days: 23)),
      image: '🗼',
      status: 'Completed',
    ),
    Trip(
      id: '2',
      title: 'Tokyo Exploration',
      destination: 'Tokyo, Japan',
      startDate: DateTime.now().subtract(const Duration(days: 60)),
      endDate: DateTime.now().subtract(const Duration(days: 45)),
      image: '🗾',
      status: 'Completed',
    ),
    Trip(
      id: '3',
      title: 'Barcelona Beach',
      destination: 'Barcelona, Spain',
      startDate: DateTime.now().subtract(const Duration(days: 90)),
      endDate: DateTime.now().subtract(const Duration(days: 80)),
      image: '🏖️',
      status: 'Completed',
    ),
  ];

  // Sample data for top regional selections
  final List<PopularCity> topRegionalSelections = [
    PopularCity(
      name: 'Paris',
      country: 'France',
      image: '🗼',
      rating: 4.8,
      reviews: 2548,
    ),
    PopularCity(
      name: 'Tokyo',
      country: 'Japan',
      image: '🗾',
      rating: 4.7,
      reviews: 1893,
    ),
    PopularCity(
      name: 'Barcelona',
      country: 'Spain',
      image: '🏖️',
      rating: 4.6,
      reviews: 1642,
    ),
    PopularCity(
      name: 'Rome',
      country: 'Italy',
      image: '🏛️',
      rating: 4.9,
      reviews: 3124,
    ),
    PopularCity(
      name: 'Dubai',
      country: 'UAE',
      image: '🌆',
      rating: 4.5,
      reviews: 2800,
    ),
  ];

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
        title: const Text('YATRA',
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
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
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
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.08),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Stack(
      fit: StackFit.expand,
      children: [
        // 🖼️ Background Image
        Image.asset(
          'assets/images/banner.jpg',
          fit: BoxFit.cover,
        ),
 
        // 🌟 Content (unchanged)
        Stack(
          children: [
            Center(
              child: Text(
                'Plan your next journey',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      shadows: const [
                        Shadow(
                          color: Colors.black45,
                          blurRadius: 8,
                        ),
                      ],
                    ),
              ),
            ),
            // const Positioned(
            //   top: 10,
            //   right: 20,
            //   child: Text(
            //     '✈️',
            //     style: TextStyle(fontSize: 32),
            //   ),
            // ),
            // const Positioned(
            //   bottom: 10,
            //   left: 20,
            //   child: Text(
            //     '🌍',
            //     style: TextStyle(fontSize: 32),
            //   ),
            // ),
          ],
        ),
      ],
    ),
  ),
),


            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
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
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: topRegionalSelections.length,
                      itemBuilder: (context, index) {
                        final city = topRegionalSelections[index];
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
                       fontSize: 18,
    fontWeight: FontWeight.w700,
                          
                        ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: previousTrips.length,
                      itemBuilder: (context, index) {
                        final trip = previousTrips[index];
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PlanTripPage(),
                        ),
                      );
                    },
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
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
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildRegionalSelectionCard(PopularCity city) {
    return Container(
      width: 90,
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${city.name} selected')),
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                city.image,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 4),
              Text(
                city.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviousTripCard(Trip trip) {
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${trip.title} trip selected')),
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  trip.image,
                  style: const TextStyle(fontSize: 28),
                ),
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
