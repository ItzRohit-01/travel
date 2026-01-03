import 'package:flutter/material.dart';
import 'dart:math' as math;

class CommunityPost {
  final String id;
  final String userName;
  final String userAvatar;
  final String location;
  final String title;
  final String content;
  final String category;
  final int likes;
  final int comments;
  final int shares;
  final String timeAgo;
  final List<String> images;
  final bool isPopular;

  CommunityPost({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.location,
    required this.title,
    required this.content,
    required this.category,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.timeAgo,
    required this.images,
    this.isPopular = false,
  });
}

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;

  String _sortBy = 'popular';
  String _groupBy = 'recent';
  String _filterBy = 'all';

  List<CommunityPost> allPosts = [];
  List<CommunityPost> filteredPosts = [];
  bool _isSearching = false;
  Set<String> likedPosts = {};

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

    _initializePosts();
    filteredPosts = List.from(allPosts);
    _applyFiltersAndSort();
  }

  void _initializePosts() {
    allPosts = [
      CommunityPost(
        id: '1',
        userName: 'Emma Wilson',
        userAvatar: 'EW',
        location: 'Paris, France',
        title: 'Best Hidden Cafes in Montmartre',
        content:
            'Just discovered the most amazing hidden cafes in Montmartre! The view from Café des Deux Moulins is absolutely breathtaking. Perfect spot for morning coffee and croissants. Highly recommend visiting early morning to avoid crowds.',
        category: 'tips',
        likes: 342,
        comments: 45,
        shares: 23,
        timeAgo: '2 hours ago',
        images: [
          'https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=400'
        ],
        isPopular: true,
      ),
      CommunityPost(
        id: '2',
        userName: 'James Chen',
        userAvatar: 'JC',
        location: 'Tokyo, Japan',
        title: 'Ultimate Guide to Tokyo Street Food',
        content:
            'Spent the last week exploring Tokyo\'s street food scene. From takoyaki to yakitori, every corner has something delicious. My top pick: the ramen shops in Shinjuku. Don\'t miss the golden gai area for authentic local experience!',
        category: 'food',
        likes: 567,
        comments: 89,
        shares: 112,
        timeAgo: '5 hours ago',
        images: [
          'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=400'
        ],
        isPopular: true,
      ),
      CommunityPost(
        id: '3',
        userName: 'Sofia Rodriguez',
        userAvatar: 'SR',
        location: 'Barcelona, Spain',
        title: 'Sagrada Familia - Worth the Hype?',
        content:
            'After visiting 20+ countries, I can confidently say Sagrada Familia is one of the most impressive structures I\'ve seen. Book tickets online to skip the 2-hour queue. The sunset view from the towers is magical! Architecture lovers, this is your paradise.',
        category: 'culture',
        likes: 423,
        comments: 67,
        shares: 45,
        timeAgo: '8 hours ago',
        images: [
          'https://images.unsplash.com/photo-1583422409516-2895a77efded?w=400'
        ],
        isPopular: true,
      ),
      CommunityPost(
        id: '4',
        userName: 'Michael Park',
        userAvatar: 'MP',
        location: 'Bali, Indonesia',
        title: 'Budget Travel Tips for Bali',
        content:
            'Managed to spend just \$30/day in Bali including accommodation! Stay in Ubud for authentic experience, eat at warungs (local eateries), and rent a scooter for \$5/day. The rice terraces are free to explore. Sharing my complete itinerary in comments!',
        category: 'tips',
        likes: 789,
        comments: 134,
        shares: 234,
        timeAgo: '1 day ago',
        images: [
          'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=400'
        ],
        isPopular: true,
      ),
      CommunityPost(
        id: '5',
        userName: 'Anna Kowalski',
        userAvatar: 'AK',
        location: 'Santorini, Greece',
        title: 'Sunrise vs Sunset in Santorini',
        content:
            'Hot take: Sunrise in Oia is more magical than sunset! Way fewer crowds and the colors are just as stunning. Plus, you get the whole village to yourself. Wake up at 5:30 AM, grab coffee, and watch the world wake up. Trust me on this one!',
        category: 'photography',
        likes: 234,
        comments: 42,
        shares: 18,
        timeAgo: '1 day ago',
        images: [
          'https://images.unsplash.com/photo-1613395877344-13d4a8e0d49e?w=400'
        ],
        isPopular: false,
      ),
      CommunityPost(
        id: '6',
        userName: 'David Thompson',
        userAvatar: 'DT',
        location: 'New York, USA',
        title: 'NYC on a Budget - Yes, It\'s Possible!',
        content:
            'NYC doesn\'t have to break the bank! Free walking tours, Staten Island ferry (free with amazing views), and countless free museums. Got pizza slices for \$1 and bagels for \$2. The city is what you make of it. Best free activity: Brooklyn Bridge walk at sunset.',
        category: 'tips',
        likes: 456,
        comments: 78,
        shares: 56,
        timeAgo: '2 days ago',
        images: [
          'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=400'
        ],
        isPopular: false,
      ),
      CommunityPost(
        id: '7',
        userName: 'Yuki Tanaka',
        userAvatar: 'YT',
        location: 'Kyoto, Japan',
        title: 'Cherry Blossom Season Guide',
        content:
            'Visited 15 temples during cherry blossom season. Philosopher\'s Path is gorgeous but crowded. My secret spot: Kamigamo Shrine - equally beautiful, zero tourists! Peak season is late March to early April. Book accommodations 6 months in advance!',
        category: 'culture',
        likes: 678,
        comments: 92,
        shares: 145,
        timeAgo: '2 days ago',
        images: [
          'https://images.unsplash.com/photo-1522383225653-ed111181a951?w=400'
        ],
        isPopular: true,
      ),
      CommunityPost(
        id: '8',
        userName: 'Lucas Silva',
        userAvatar: 'LS',
        location: 'Rio de Janeiro, Brazil',
        title: 'Hiking Sugarloaf Mountain',
        content:
            'Did the Sugarloaf hike instead of taking the cable car - saved money and got an amazing workout! The trail is moderate difficulty, takes about 2 hours. Views are identical to the cable car but you feel so accomplished. Bring water and snacks!',
        category: 'adventure',
        likes: 234,
        comments: 34,
        shares: 21,
        timeAgo: '3 days ago',
        images: [
          'https://images.unsplash.com/photo-1483729558449-99ef09a8c325?w=400'
        ],
        isPopular: false,
      ),
      CommunityPost(
        id: '9',
        userName: 'Isabella Martinez',
        userAvatar: 'IM',
        location: 'Rome, Italy',
        title: 'Best Gelato Spots in Rome',
        content:
            'Tried 12 gelaterias in 5 days (no regrets!). Winner: Gelateria del Teatro near Piazza Navona. Skip the touristy spots near Trevi Fountain. Look for places where prices are hidden (sign of quality). My favorite flavors: pistachio and stracciatella!',
        category: 'food',
        likes: 445,
        comments: 67,
        shares: 43,
        timeAgo: '3 days ago',
        images: [
          'https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?w=400'
        ],
        isPopular: false,
      ),
      CommunityPost(
        id: '10',
        userName: 'Oliver Schmidt',
        userAvatar: 'OS',
        location: 'Swiss Alps',
        title: 'Paragliding in Interlaken - Life Changing',
        content:
            'Just did tandem paragliding over the Swiss Alps and I\'m still speechless! 360° views of Eiger, Mönch, and Jungfrau. Cost €180 but worth every penny. Photos and videos included. Not scary at all, just pure joy. Book with Outdoor Interlaken!',
        category: 'adventure',
        likes: 892,
        comments: 123,
        shares: 178,
        timeAgo: '4 days ago',
        images: [
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400'
        ],
        isPopular: true,
      ),
      CommunityPost(
        id: '11',
        userName: 'Priya Sharma',
        userAvatar: 'PS',
        location: 'Jaipur, India',
        title: 'Exploring the Pink City',
        content:
            'Jaipur is a photographer\'s dream! Hawa Mahal looks even better in person. Best time to visit: October-March. Try the local dal baati churma and lassi. Auto rickshaw rides are an adventure themselves. Stay in the old city for authentic vibes!',
        category: 'culture',
        likes: 356,
        comments: 54,
        shares: 32,
        timeAgo: '5 days ago',
        images: [
          'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?w=400'
        ],
        isPopular: false,
      ),
      CommunityPost(
        id: '12',
        userName: 'Thomas Anderson',
        userAvatar: 'TA',
        location: 'Iceland',
        title: 'Northern Lights Photography Tips',
        content:
            'Finally caught the Northern Lights after 4 nights! Camera settings: ISO 1600, 15-sec exposure, f/2.8. Best spots away from Reykjavik: Thingvellir National Park. September-March is prime time. Be patient and dress VERY warm. Worth every freezing minute!',
        category: 'photography',
        likes: 567,
        comments: 87,
        shares: 96,
        timeAgo: '5 days ago',
        images: [
          'https://images.unsplash.com/photo-1483347756197-71ef80e95f73?w=400'
        ],
        isPopular: true,
      ),
      CommunityPost(
        id: '13',
        userName: 'Maria Garcia',
        userAvatar: 'MG',
        location: 'Machu Picchu, Peru',
        title: 'Alternative Routes to Machu Picchu',
        content:
            'Skip the crowded Inca Trail! Took the Salkantay Trek - more scenic, fewer people, and no permit lottery. 5-day trek through mountains, jungle, and hot springs. Challenging but absolutely worth it. Saw condors and alpacas. Book with local operators!',
        category: 'adventure',
        likes: 723,
        comments: 98,
        shares: 134,
        timeAgo: '6 days ago',
        images: [
          'https://images.unsplash.com/photo-1587595431973-160d0d94add1?w=400'
        ],
        isPopular: true,
      ),
      CommunityPost(
        id: '14',
        userName: 'Alex Kim',
        userAvatar: 'AK',
        location: 'Seoul, South Korea',
        title: 'Korean BBQ Restaurant Guide',
        content:
            'Tried 8 different Korean BBQ spots in Gangnam. Best value: Maple Tree House. For premium: Maple Tree House Prime. Don\'t fill up on banchan (side dishes)! Order the pork belly and beef short ribs. Locals go after 8 PM. Soju is mandatory!',
        category: 'food',
        likes: 489,
        comments: 72,
        shares: 54,
        timeAgo: '1 week ago',
        images: [
          'https://images.unsplash.com/photo-1590301157890-4810ed352733?w=400'
        ],
        isPopular: false,
      ),
      CommunityPost(
        id: '15',
        userName: 'Sophie Laurent',
        userAvatar: 'SL',
        location: 'French Riviera',
        title: 'Monaco on a Budget (Sort Of)',
        content:
            'Monaco is expensive but you CAN do it cheaper! Watch the sunset from the Prince\'s Palace gardens (free). Eat at local French cafes just outside Monaco. The casino is free to enter if you dress well. Walk everywhere - it\'s tiny! Beach clubs are pricey but worth one splurge.',
        category: 'tips',
        likes: 378,
        comments: 56,
        shares: 41,
        timeAgo: '1 week ago',
        images: [
          'https://images.unsplash.com/photo-1506784983877-45594efa4cbe?w=400'
        ],
        isPopular: false,
      ),
    ];
  }

  void _performSearch() {
    setState(() {
      _isSearching = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        if (_searchController.text.isEmpty) {
          filteredPosts = List.from(allPosts);
        } else {
          final searchTerm = _searchController.text.toLowerCase();
          filteredPosts = allPosts.where((post) {
            return post.title.toLowerCase().contains(searchTerm) ||
                post.content.toLowerCase().contains(searchTerm) ||
                post.userName.toLowerCase().contains(searchTerm) ||
                post.location.toLowerCase().contains(searchTerm) ||
                post.category.toLowerCase().contains(searchTerm);
          }).toList();
        }

        _applyFiltersAndSort();
        _isSearching = false;
      });
    });
  }

  void _applyFiltersAndSort() {
    List<CommunityPost> tempPosts = List.from(filteredPosts);

    // Apply filter by category
    if (_filterBy != 'all') {
      tempPosts = tempPosts.where((post) {
        return post.category.toLowerCase() == _filterBy.toLowerCase();
      }).toList();
    }

    // Apply sort
    if (_sortBy == 'popular') {
      tempPosts.sort((a, b) => b.likes.compareTo(a.likes));
    } else if (_sortBy == 'recent') {
      // Already in recent order from initialization
    } else if (_sortBy == 'comments') {
      tempPosts.sort((a, b) => b.comments.compareTo(a.comments));
    } else if (_sortBy == 'trending') {
      tempPosts.sort((a, b) {
        final aScore = a.likes + (a.comments * 2) + (a.shares * 3);
        final bScore = b.likes + (b.comments * 2) + (b.shares * 3);
        return bScore.compareTo(aScore);
      });
    }

    // Apply grouping
    if (_groupBy == 'category') {
      tempPosts.sort((a, b) => a.category.compareTo(b.category));
    } else if (_groupBy == 'location') {
      tempPosts.sort((a, b) => a.location.compareTo(b.location));
    }

    setState(() {
      filteredPosts = tempPosts;
    });
  }

  void _toggleLike(String postId) {
    setState(() {
      if (likedPosts.contains(postId)) {
        likedPosts.remove(postId);
      } else {
        likedPosts.add(postId);
      }
    });
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
                      content: Text('No new notifications'),
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
                  // Info banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF667EEA).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF667EEA).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Color(0xFF667EEA),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Sample community posts shown for preview',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Search Bar
                  _buildSearchBar(),
                  const SizedBox(height: 16),

                  // Control Buttons
                  _buildControlButtons(),
                  const SizedBox(height: 24),

                  // Title
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Community Tab',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        Text(
                          '${filteredPosts.length} posts',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF95A3B3),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Posts List
                  _isSearching
                      ? _buildLoadingIndicator()
                      : _buildPostsList(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 1200),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: FloatingActionButton.extended(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Create post feature coming soon!'),
                    backgroundColor: Color(0xFF667EEA),
                  ),
                );
              },
              backgroundColor: const Color(0xFF667EEA),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'New Post',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
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
                hintText: 'Search posts, users, locations...',
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
                    ['recent', 'category', 'location'],
                    (value) {
                      setState(() {
                        _groupBy = value;
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
                    ['all', 'tips', 'food', 'culture', 'adventure', 'photography'],
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
                    'Sort by',
                    _sortBy,
                    ['popular', 'recent', 'comments', 'trending'],
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

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1000),
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value * 2 * math.pi,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.people,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Loading community posts...',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF667EEA),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsList() {
    if (filteredPosts.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: filteredPosts.asMap().entries.map((entry) {
        int index = entry.key;
        CommunityPost post = entry.value;
        return _buildPostCard(post, index);
      }).toList(),
    );
  }

  Widget _buildEmptyState() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF667EEA).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.forum_outlined,
                    size: 60,
                    color: Color(0xFF667EEA),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'No Posts Found',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Try adjusting your search or filters',
                  style: TextStyle(
                    fontSize: 14,
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

  Widget _buildPostCard(CommunityPost post, int index) {
    final isLiked = likedPosts.contains(post.id);
    final categoryColors = {
      'tips': const Color(0xFF4ECDC4),
      'food': const Color(0xFFFF6B6B),
      'culture': const Color(0xFF667EEA),
      'adventure': const Color(0xFFFFD93D),
      'photography': const Color(0xFFB565D8),
    };

    final categoryColor =
        categoryColors[post.category] ?? const Color(0xFF95A3B3);

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
              margin: const EdgeInsets.only(bottom: 20),
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
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showPostDetail(post),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: Duration(milliseconds: 800 + (index * 50)),
                          curve: Curves.elasticOut,
                          builder: (context, val, child) {
                            return Transform.scale(
                              scale: val,
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      categoryColor,
                                      categoryColor.withOpacity(0.7),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: categoryColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    post.userAvatar,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 16),

                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // User Info
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          post.userName,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2C3E50),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              size: 12,
                                              color: Color(0xFFFF6B6B),
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                post.location,
                                                style: const TextStyle(
                                                  fontSize: 11,
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
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: categoryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      post.category,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: categoryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Title
                              Text(
                                post.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C3E50),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),

                              // Content Preview
                              Text(
                                post.content,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF5A6C7D),
                                  height: 1.4,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),

                              // Image Preview
                              if (post.images.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    post.images[0],
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: double.infinity,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              categoryColor.withOpacity(0.2),
                                              categoryColor.withOpacity(0.1),
                                            ],
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.image,
                                          size: 40,
                                          color: categoryColor.withOpacity(0.5),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              const SizedBox(height: 12),

                              // Actions
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      _buildActionButton(
                                        isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        (post.likes + (isLiked ? 1 : 0)).toString(),
                                        isLiked
                                            ? const Color(0xFFFF6B6B)
                                            : const Color(0xFF95A3B3),
                                        () => _toggleLike(post.id),
                                      ),
                                      const SizedBox(width: 16),
                                      _buildActionButton(
                                        Icons.comment_outlined,
                                        post.comments.toString(),
                                        const Color(0xFF95A3B3),
                                        () {},
                                      ),
                                      const SizedBox(width: 16),
                                      _buildActionButton(
                                        Icons.share_outlined,
                                        post.shares.toString(),
                                        const Color(0xFF95A3B3),
                                        () {},
                                      ),
                                    ],
                                  ),
                                  Text(
                                    post.timeAgo,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF95A3B3),
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
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String count,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 4),
            Text(
              count,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPostDetail(CommunityPost post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
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
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              post.userAvatar,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
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
                                post.userName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                              Text(
                                post.location,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF95A3B3),
                                ),
                              ),
                              Text(
                                post.timeAgo,
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
                    const SizedBox(height: 24),
                    Text(
                      post.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      post.content,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF5A6C7D),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (post.images.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          post.images[0],
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildDetailAction(
                          Icons.favorite,
                          post.likes.toString(),
                          'Likes',
                        ),
                        _buildDetailAction(
                          Icons.comment,
                          post.comments.toString(),
                          'Comments',
                        ),
                        _buildDetailAction(
                          Icons.share,
                          post.shares.toString(),
                          'Shares',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailAction(IconData icon, String count, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF667EEA), size: 28),
        const SizedBox(height: 8),
        Text(
          count,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF95A3B3),
          ),
        ),
      ],
    );
  }
}
