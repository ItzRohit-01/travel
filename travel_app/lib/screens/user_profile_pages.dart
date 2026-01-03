import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String bio;
  final String profileImage;
  final int totalTrips;
  final double totalBudget;
  final List<String> favoriteDestinations;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.bio,
    this.profileImage = '👤',
    this.totalTrips = 0,
    this.totalBudget = 0,
    this.favoriteDestinations = const [],
  });
}

class TripCard {
  final String id;
  final String name;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final double budget;
  final String status;
  final String emoji;
  final String imageUrl;

  TripCard({
    required this.id,
    required this.name,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.status,
    this.emoji = '✈️',
    this.imageUrl = '',
  });
}

class UserProfilePage extends StatefulWidget {
  final UserProfile? userProfile;

  const UserProfilePage({
    Key? key,
    this.userProfile,
  }) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late UserProfile user;
  late List<TripCard> preplanedTrips;
  late List<TripCard> previousTrips;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    user = widget.userProfile ??
        UserProfile(
          id: '1',
          name: 'Sarah Anderson',
          email: 'sarah.anderson@email.com',
          phone: '+1 (555) 123-4567',
          bio: 'Adventure seeker | Travel enthusiast | Photographer | Always exploring new cultures and destinations',
          totalTrips: 18,
          totalBudget: 68500,
          favoriteDestinations: ['Paris', 'Tokyo', 'Barcelona', 'Rome', 'Sydney', 'Iceland'],
        );

    preplanedTrips = [
      TripCard(
        id: '1',
        name: 'Paris City Break',
        destination: 'Paris, France',
        startDate: DateTime(2026, 3, 15),
        endDate: DateTime(2026, 3, 22),
        budget: 1500,
        status: 'upcoming',
        emoji: '🗼',
        imageUrl: 'https://images.unsplash.com/photo-1511739001486-6bfe10ce785f?w=400',
      ),
      TripCard(
        id: '2',
        name: 'Tokyo Adventure',
        destination: 'Tokyo, Japan',
        startDate: DateTime(2026, 4, 10),
        endDate: DateTime(2026, 4, 25),
        budget: 2500,
        status: 'upcoming',
        emoji: '🗾',
        imageUrl: 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=400',
      ),
      TripCard(
        id: '3',
        name: 'Dubai Luxury',
        destination: 'Dubai, UAE',
        startDate: DateTime(2026, 5, 1),
        endDate: DateTime(2026, 5, 8),
        budget: 3000,
        status: 'upcoming',
        emoji: '🏙️',
        imageUrl: 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?w=400',
      ),
      TripCard(
        id: '7',
        name: 'Rome History Tour',
        destination: 'Rome, Italy',
        startDate: DateTime(2026, 6, 5),
        endDate: DateTime(2026, 6, 14),
        budget: 1800,
        status: 'upcoming',
        emoji: '🏛️',
        imageUrl: 'https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400',
      ),
      TripCard(
        id: '8',
        name: 'Iceland Adventure',
        destination: 'Reykjavik, Iceland',
        startDate: DateTime(2026, 7, 1),
        endDate: DateTime(2026, 7, 10),
        budget: 2200,
        status: 'upcoming',
        emoji: '🏔️',
        imageUrl: 'https://images.unsplash.com/photo-1504893524553-b855bce32c67?w=400',
      ),
      TripCard(
        id: '9',
        name: 'Sydney Coastal',
        destination: 'Sydney, Australia',
        startDate: DateTime(2026, 8, 15),
        endDate: DateTime(2026, 8, 28),
        budget: 3500,
        status: 'upcoming',
        emoji: '🦘',
        imageUrl: 'https://images.unsplash.com/photo-1506973035872-a4ec16b8e8d9?w=400',
      ),
      TripCard(
        id: '10',
        name: 'Amsterdam Culture',
        destination: 'Amsterdam, Netherlands',
        startDate: DateTime(2026, 9, 5),
        endDate: DateTime(2026, 9, 12),
        budget: 1400,
        status: 'upcoming',
        emoji: '🚲',
        imageUrl: 'https://images.unsplash.com/photo-1534351590666-13e3e96b5017?w=400',
      ),
      TripCard(
        id: '11',
        name: 'Cairo Pyramids',
        destination: 'Cairo, Egypt',
        startDate: DateTime(2026, 10, 1),
        endDate: DateTime(2026, 10, 9),
        budget: 1600,
        status: 'upcoming',
        emoji: '🐪',
        imageUrl: 'https://images.unsplash.com/photo-1572252009286-268acec5ca0a?w=400',
      ),
    ];

    previousTrips = [
      TripCard(
        id: '4',
        name: 'New York Adventure',
        destination: 'New York, USA',
        startDate: DateTime(2025, 11, 1),
        endDate: DateTime(2025, 11, 8),
        budget: 1800,
        status: 'completed',
        emoji: '🗽',
        imageUrl: 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400',
      ),
      TripCard(
        id: '5',
        name: 'Bali Relaxation',
        destination: 'Bali, Indonesia',
        startDate: DateTime(2025, 10, 5),
        endDate: DateTime(2025, 10, 15),
        budget: 900,
        status: 'completed',
        emoji: '🏝️',
        imageUrl: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=400',
      ),
      TripCard(
        id: '6',
        name: 'Barcelona Beach',
        destination: 'Barcelona, Spain',
        startDate: DateTime(2025, 9, 10),
        endDate: DateTime(2025, 9, 18),
        budget: 1200,
        status: 'completed',
        emoji: '🏖️',
        imageUrl: 'https://images.unsplash.com/photo-1583422409516-2895a77efded?w=400',
      ),
      TripCard(
        id: '12',
        name: 'London Cultural',
        destination: 'London, UK',
        startDate: DateTime(2025, 8, 5),
        endDate: DateTime(2025, 8, 12),
        budget: 1700,
        status: 'completed',
        emoji: '🇬🇧',
        imageUrl: 'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?w=400',
      ),
      TripCard(
        id: '13',
        name: 'Bangkok Street Food',
        destination: 'Bangkok, Thailand',
        startDate: DateTime(2025, 7, 1),
        endDate: DateTime(2025, 7, 10),
        budget: 800,
        status: 'completed',
        emoji: '🍜',
        imageUrl: 'https://images.unsplash.com/photo-1508009603885-50cf7c579365?w=400',
      ),
      TripCard(
        id: '14',
        name: 'Singapore Modern',
        destination: 'Singapore',
        startDate: DateTime(2025, 6, 10),
        endDate: DateTime(2025, 6, 17),
        budget: 2000,
        status: 'completed',
        emoji: '🏙️',
        imageUrl: 'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?w=400',
      ),
      TripCard(
        id: '15',
        name: 'Santorini Sunset',
        destination: 'Santorini, Greece',
        startDate: DateTime(2025, 5, 15),
        endDate: DateTime(2025, 5, 23),
        budget: 1900,
        status: 'completed',
        emoji: '🇬🇷',
        imageUrl: 'https://images.unsplash.com/photo-1613395877344-13d4a8e0d49e?w=400',
      ),
      TripCard(
        id: '16',
        name: 'Swiss Alps',
        destination: 'Zurich, Switzerland',
        startDate: DateTime(2025, 4, 5),
        endDate: DateTime(2025, 4, 14),
        budget: 2800,
        status: 'completed',
        emoji: '⛷️',
        imageUrl: 'https://images.unsplash.com/photo-1531366936337-7c912a4589a7?w=400',
      ),
      TripCard(
        id: '17',
        name: 'Maldives Honeymoon',
        destination: 'Maldives',
        startDate: DateTime(2025, 3, 1),
        endDate: DateTime(2025, 3, 12),
        budget: 4500,
        status: 'completed',
        emoji: '🌺',
        imageUrl: 'https://images.unsplash.com/photo-1514282401047-d79a71a590e8?w=400',
      ),
      TripCard(
        id: '18',
        name: 'Morocco Desert',
        destination: 'Marrakech, Morocco',
        startDate: DateTime(2025, 2, 10),
        endDate: DateTime(2025, 2, 18),
        budget: 1300,
        status: 'completed',
        emoji: '🕌',
        imageUrl: 'https://images.unsplash.com/photo-1597212618440-806262de4f6b?w=400',
      ),
    ];
  }

  void _editProfile() {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phone);
    final bioController = TextEditingController(text: user.bio);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Color(0xFF667EEA),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditTextField('Name', nameController),
              const SizedBox(height: 12),
              _buildEditTextField('Email', emailController),
              const SizedBox(height: 12),
              _buildEditTextField('Phone', phoneController),
              const SizedBox(height: 12),
              _buildEditTextField('Bio', bioController, maxLines: 3),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                user = UserProfile(
                  id: user.id,
                  name: nameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  bio: bioController.text,
                  totalTrips: user.totalTrips,
                  totalBudget: user.totalBudget,
                  favoriteDestinations: user.favoriteDestinations,
                );
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully!'),
                  backgroundColor: Color(0xFF6BCB77),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667EEA),
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

  Widget _buildEditTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: const Icon(Icons.edit),
      ),
    );
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
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Section
                  _buildProfileSection(),
                  const SizedBox(height: 32),

                  // Stats Section
                  _buildStatsSection(),
                  const SizedBox(height: 32),

                  // Preplanned Trips
                  _buildTripsSection(
                    'Preplanned Trips',
                    preplanedTrips,
                  ),
                  const SizedBox(height: 32),

                  // Previous Trips
                  _buildTripsSection(
                    'Previous Trips',
                    previousTrips,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    // Get initials from name
    String getInitials(String name) {
      List<String> names = name.split(' ');
      if (names.length >= 2) {
        return '${names[0][0]}${names[1][0]}'.toUpperCase();
      }
      return name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Profile Image with Initials
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF667EEA).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    getInitials(user.name),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Change profile photo feature coming soon!'),
                        backgroundColor: Color(0xFF667EEA),
                      ),
                    );
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Color(0xFF667EEA),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          // User Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.email, size: 12, color: Color(0xFF95A3B3)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF95A3B3),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.phone, size: 12, color: Color(0xFF95A3B3)),
                    const SizedBox(width: 4),
                    Text(
                      user.phone,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF95A3B3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  user.bio,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF5A6C7D),
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _editProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF667EEA),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            '${user.totalTrips}',
            'Total Trips',
            Icons.flight_takeoff,
            const Color(0xFF667EEA),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            '\$${(user.totalBudget / 1000).toStringAsFixed(1)}K',
            'Total Budget',
            Icons.attach_money,
            const Color(0xFF6BCB77),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            '${user.favoriteDestinations.length}',
            'Favorites',
            Icons.favorite,
            const Color(0xFFFF6B6B),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF95A3B3),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTripsSection(String title, List<TripCard> trips) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: trips.map((trip) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: _buildTripCardWidget(trip),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTripCardWidget(TripCard trip) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trip Header with Real Image
          Container(
            width: double.infinity,
            height: 120,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: trip.imageUrl.isNotEmpty
                  ? Image.network(
                      trip.imageUrl,
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF667EEA).withOpacity(0.3),
                                const Color(0xFF764BA2).withOpacity(0.3),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              trip.emoji,
                              style: const TextStyle(fontSize: 48),
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF667EEA).withOpacity(0.1),
                                const Color(0xFF764BA2).withOpacity(0.1),
                              ],
                            ),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF667EEA),
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF667EEA).withOpacity(0.1),
                            const Color(0xFF764BA2).withOpacity(0.1),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          trip.emoji,
                          style: const TextStyle(fontSize: 48),
                        ),
                      ),
                    ),
            ),
          ),
          // Trip Details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip.name,
                  style: const TextStyle(
                    fontSize: 13,
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
                        size: 12, color: Color(0xFF95A3B3)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        trip.destination,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF95A3B3),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${DateFormat('dd MMM').format(trip.startDate)} - ${DateFormat('dd MMM').format(trip.endDate)}',
                  style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFFBCC3D0),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _viewTrip(trip),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF667EEA),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'View',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _viewTrip(TripCard trip) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            TripDetailPage(trip: trip),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
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
}

// Spectacular Trip Detail Page with Animations
class TripDetailPage extends StatefulWidget {
  final TripCard trip;

  const TripDetailPage({Key? key, required this.trip}) : super(key: key);

  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  final List<Map<String, dynamic>> itineraryItems = [];

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
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Start animations
    _fadeController.forward();
    _slideController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _scaleController.forward();
    });

    _generateItinerary();
  }

  void _generateItinerary() {
    itineraryItems.addAll([
      {
        'time': '09:00 AM',
        'title': 'Morning Exploration',
        'description': 'Start your day with a guided tour of the main attractions',
        'icon': Icons.wb_sunny,
        'color': const Color(0xFFFFD93D),
      },
      {
        'time': '12:30 PM',
        'title': 'Local Cuisine Experience',
        'description': 'Enjoy authentic local dishes at recommended restaurants',
        'icon': Icons.restaurant,
        'color': const Color(0xFFFF6B6B),
      },
      {
        'time': '03:00 PM',
        'title': 'Cultural Activities',
        'description': 'Visit museums and cultural landmarks',
        'icon': Icons.museum,
        'color': const Color(0xFF667EEA),
      },
      {
        'time': '06:00 PM',
        'title': 'Sunset Views',
        'description': 'Capture stunning sunset photos at scenic spots',
        'icon': Icons.camera_alt,
        'color': const Color(0xFFFF6B6B),
      },
      {
        'time': '08:00 PM',
        'title': 'Evening Entertainment',
        'description': 'Experience nightlife and evening attractions',
        'icon': Icons.nightlife,
        'color': const Color(0xFF764BA2),
      },
    ]);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Hero Image with Parallax Effect
          _buildHeroImage(),
          
          // Gradient Overlay
          _buildGradientOverlay(),
          
          // Content
          _buildContent(),
          
          // Close Button
          _buildCloseButton(),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        width: double.infinity,
        child: widget.trip.imageUrl.isNotEmpty
            ? Image.network(
                widget.trip.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF667EEA),
                          const Color(0xFF764BA2),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.trip.emoji,
                        style: const TextStyle(fontSize: 80),
                      ),
                    ),
                  );
                },
              )
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF667EEA),
                      const Color(0xFF764BA2),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.trip.emoji,
                    style: const TextStyle(fontSize: 80),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.3),
              Colors.black.withOpacity(0.8),
              const Color(0xFFF8F9FF),
            ],
            stops: const [0.0, 0.3, 0.5, 0.7],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.6,
          maxChildSize: 0.95,
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
                      // Drag Handle
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
                      
                      // Trip Title
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Text(
                          widget.trip.name,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Destination
                      Row(
                        children: [
                          const Icon(Icons.location_on, 
                              color: Color(0xFFFF6B6B), size: 20),
                          const SizedBox(width: 8),
                          Text(
                            widget.trip.destination,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF5A6C7D),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Info Cards
                      _buildInfoCards(),
                      const SizedBox(height: 32),
                      
                      // Itinerary Section
                      _buildItinerarySection(),
                      const SizedBox(height: 24),
                      
                      // Action Buttons
                      _buildActionButtons(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoCards() {
    final days = widget.trip.endDate.difference(widget.trip.startDate).inDays;
    
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            Icons.calendar_today,
            '$days Days',
            '${DateFormat('dd MMM').format(widget.trip.startDate)} - ${DateFormat('dd MMM').format(widget.trip.endDate)}',
            const Color(0xFF667EEA),
            0,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            Icons.attach_money,
            '\$${widget.trip.budget.toStringAsFixed(0)}',
            'Total Budget',
            const Color(0xFF6BCB77),
            100,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    int delay,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 800 + delay),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.all(16),
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
                Icon(icon, color: color, size: 28),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF95A3B3),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildItinerarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily Itinerary',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 16),
        ...itineraryItems.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> item = entry.value;
          return _buildItineraryItem(item, index);
        }).toList(),
      ],
    );
  }

  Widget _buildItineraryItem(Map<String, dynamic> item, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(50 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (item['color'] as Color).withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: item['color'] as Color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['time'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: item['color'] as Color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['title'] as String,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['description'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF95A3B3),
                          ),
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

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking feature coming soon!'),
                  backgroundColor: Color(0xFF667EEA),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667EEA),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Book Now',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667EEA).withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Added to favorites!'),
                  backgroundColor: Color(0xFFFF6B6B),
                ),
              );
            },
            icon: const Icon(Icons.favorite_border, color: Color(0xFFFF6B6B)),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667EEA).withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share feature coming soon!'),
                  backgroundColor: Color(0xFF667EEA),
                ),
              );
            },
            icon: const Icon(Icons.share, color: Color(0xFF667EEA)),
          ),
        ),
      ],
    );
  }

  Widget _buildCloseButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      right: 16,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF2C3E50)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }
}
