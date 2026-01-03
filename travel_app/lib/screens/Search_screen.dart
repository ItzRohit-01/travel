import 'package:flutter/material.dart';
import 'dart:math' as math;

class ActivitySearchResult {
  final String id;
  final String title;
  final String location;
  final String category;
  final double rating;
  final int reviews;
  final double price;
  final String duration;
  final String imageUrl;
  final String description;
  final List<String> highlights;
  final bool isPopular;

  ActivitySearchResult({
    required this.id,
    required this.title,
    required this.location,
    required this.category,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.duration,
    required this.imageUrl,
    required this.description,
    required this.highlights,
    this.isPopular = false,
  });
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  
  String _sortBy = 'rating'; // rating, price, popular
  String _groupBy = 'category'; // category, location, price
  String _filterBy = 'all'; // all, adventure, culture, food, nature
  
  List<ActivitySearchResult> allResults = [];
  List<ActivitySearchResult> filteredResults = [];
  bool _isSearching = false;

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
    
    _initializeResults();
    filteredResults = List.from(allResults);
    _applyFiltersAndSort();
  }

  void _initializeResults() {
    allResults = [
      // ADVENTURE Activities
      ActivitySearchResult(
        id: '1',
        title: 'Paragliding Adventure in Swiss Alps',
        location: 'Interlaken, Switzerland',
        category: 'adventure',
        rating: 4.9,
        reviews: 1247,
        price: 180,
        duration: '2-3 hours',
        imageUrl: 'https://images.unsplash.com/photo-1519904981063-b0cf448d479e?w=400',
        description: 'Experience the thrill of flying over the stunning Swiss Alps',
        highlights: ['Professional guides', 'Equipment included', 'Photos included'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '2',
        title: 'Bungee Jumping Experience',
        location: 'Queenstown, New Zealand',
        category: 'adventure',
        rating: 5.0,
        reviews: 2341,
        price: 220,
        duration: '1 hour',
        imageUrl: 'https://images.unsplash.com/photo-1564769610768-f09b8e58e8e8?w=400',
        description: 'Take the ultimate leap from the world\'s highest bungee jump',
        highlights: ['Safety certified', 'Video recording', 'Certificate included'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '3',
        title: 'Scuba Diving Great Barrier Reef',
        location: 'Cairns, Australia',
        category: 'adventure',
        rating: 4.9,
        reviews: 3456,
        price: 250,
        duration: '4-5 hours',
        imageUrl: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400',
        description: 'Explore the world\'s largest coral reef system',
        highlights: ['All equipment', 'Marine life', 'Certified instructors'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '4',
        title: 'White Water Rafting',
        location: 'Colorado River, USA',
        category: 'adventure',
        rating: 4.8,
        reviews: 1876,
        price: 140,
        duration: '3-4 hours',
        imageUrl: 'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=400',
        description: 'Navigate thrilling rapids through stunning canyon scenery',
        highlights: ['Safety gear', 'Expert guides', 'Lunch included'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '5',
        title: 'Rock Climbing Course',
        location: 'Yosemite, USA',
        category: 'adventure',
        rating: 4.7,
        reviews: 987,
        price: 195,
        duration: '6 hours',
        imageUrl: 'https://images.unsplash.com/photo-1522163182402-834f871fd851?w=400',
        description: 'Scale iconic granite cliffs with experienced climbers',
        highlights: ['Beginner friendly', 'All gear', 'Small groups'],
        isPopular: false,
      ),
      ActivitySearchResult(
        id: '6',
        title: 'Skydiving Tandem Jump',
        location: 'Dubai, UAE',
        category: 'adventure',
        rating: 5.0,
        reviews: 4521,
        price: 450,
        duration: '2 hours',
        imageUrl: 'https://images.unsplash.com/photo-1538378204460-02a89e40a7fc?w=400',
        description: 'Freefall over the Palm Jumeirah and Dubai skyline',
        highlights: ['15000 ft jump', 'HD video', 'Professional instructor'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '7',
        title: 'Zip Lining Through Rainforest',
        location: 'Monteverde, Costa Rica',
        category: 'adventure',
        rating: 4.8,
        reviews: 2134,
        price: 85,
        duration: '2.5 hours',
        imageUrl: 'https://images.unsplash.com/photo-1527004013197-933c4bb611b3?w=400',
        description: 'Soar through the canopy on 12 thrilling zip lines',
        highlights: ['Canopy views', 'Safety equipment', 'Wildlife spotting'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '8',
        title: 'Surfing Lessons',
        location: 'Bali, Indonesia',
        category: 'adventure',
        rating: 4.6,
        reviews: 1543,
        price: 60,
        duration: '2 hours',
        imageUrl: 'https://images.unsplash.com/photo-1502680390469-be75c86b636f?w=400',
        description: 'Learn to ride the waves at world-famous surf beaches',
        highlights: ['Surfboard rental', 'Professional coach', 'Beach access'],
        isPopular: false,
      ),
      ActivitySearchResult(
        id: '9',
        title: 'Glacier Hiking Tour',
        location: 'Vatnajökull, Iceland',
        category: 'adventure',
        rating: 4.9,
        reviews: 1234,
        price: 175,
        duration: '4 hours',
        imageUrl: 'https://images.unsplash.com/photo-1519904981063-b0cf448d479e?w=400',
        description: 'Trek across Europe\'s largest glacier with crampons',
        highlights: ['Ice climbing', 'Glacier equipment', 'Expert guides'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '10',
        title: 'Sandboarding Adventure',
        location: 'Dubai Desert, UAE',
        category: 'adventure',
        rating: 4.5,
        reviews: 876,
        price: 95,
        duration: '3 hours',
        imageUrl: 'https://images.unsplash.com/photo-1473448912268-2022ce9509d8?w=400',
        description: 'Ride down massive sand dunes on a board',
        highlights: ['Desert safari', 'Sunset views', 'BBQ dinner'],
        isPopular: false,
      ),

      // CULTURE Activities
      ActivitySearchResult(
        id: '11',
        title: 'Cooking Class Traditional Thai Cuisine',
        location: 'Bangkok, Thailand',
        category: 'culture',
        rating: 4.9,
        reviews: 2987,
        price: 45,
        duration: '3 hours',
        imageUrl: 'https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=400',
        description: 'Master authentic Thai recipes with a local chef',
        highlights: ['Market tour', 'Recipe book', 'Meal included'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '12',
        title: 'Flamenco Show with Dinner',
        location: 'Seville, Spain',
        category: 'culture',
        rating: 4.8,
        reviews: 3214,
        price: 75,
        duration: '2.5 hours',
        imageUrl: 'https://images.unsplash.com/photo-1504609813442-a8924e83f76e?w=400',
        description: 'Experience passionate flamenco performance with tapas',
        highlights: ['Live music', 'Traditional dancers', '3-course dinner'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '13',
        title: 'Geisha District Walking Tour',
        location: 'Kyoto, Japan',
        category: 'culture',
        rating: 4.9,
        reviews: 1876,
        price: 55,
        duration: '2 hours',
        imageUrl: 'https://images.unsplash.com/photo-1528360983277-13d401cdc186?w=400',
        description: 'Explore historic Gion district and learn about geisha culture',
        highlights: ['Expert guide', 'Temple visits', 'Tea ceremony'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '14',
        title: 'Italian Pasta Making Workshop',
        location: 'Rome, Italy',
        category: 'culture',
        rating: 4.8,
        reviews: 2543,
        price: 65,
        duration: '3 hours',
        imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400',
        description: 'Learn to make fresh pasta from scratch with a Roman chef',
        highlights: ['Wine pairing', 'Recipe cards', 'Dining experience'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '15',
        title: 'Tango Dance Lesson',
        location: 'Buenos Aires, Argentina',
        category: 'culture',
        rating: 4.7,
        reviews: 1234,
        price: 40,
        duration: '1.5 hours',
        imageUrl: 'https://images.unsplash.com/photo-1508807526345-15e9b5f4eaff?w=400',
        description: 'Learn the passionate dance of Argentina',
        highlights: ['Professional dancers', 'Beginner friendly', 'Live music'],
        isPopular: false,
      ),
      ActivitySearchResult(
        id: '16',
        title: 'Moroccan Pottery Workshop',
        location: 'Marrakech, Morocco',
        category: 'culture',
        rating: 4.6,
        reviews: 876,
        price: 50,
        duration: '2 hours',
        imageUrl: 'https://images.unsplash.com/photo-1493836512294-502baa1986e2?w=400',
        description: 'Create traditional ceramics in a local workshop',
        highlights: ['Take home pottery', 'Local artisan', 'Mint tea'],
        isPopular: false,
      ),
      ActivitySearchResult(
        id: '17',
        title: 'Ancient Ruins Archaeological Tour',
        location: 'Athens, Greece',
        category: 'culture',
        rating: 4.9,
        reviews: 4321,
        price: 80,
        duration: '4 hours',
        imageUrl: 'https://images.unsplash.com/photo-1555993539-1732b0258235?w=400',
        description: 'Explore the Acropolis and Parthenon with historian guide',
        highlights: ['Skip the line', 'Expert historian', 'Photo opportunities'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '18',
        title: 'Traditional Balinese Dance Performance',
        location: 'Ubud, Bali',
        category: 'culture',
        rating: 4.7,
        reviews: 1654,
        price: 25,
        duration: '1.5 hours',
        imageUrl: 'https://images.unsplash.com/photo-1547036967-23d11aacaee0?w=400',
        description: 'Watch mesmerizing Kecak fire dance at sunset',
        highlights: ['Fire dance', 'Temple setting', 'Traditional costumes'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '19',
        title: 'Museum Guided Tour',
        location: 'Paris, France',
        category: 'culture',
        rating: 4.8,
        reviews: 5678,
        price: 90,
        duration: '3 hours',
        imageUrl: 'https://images.unsplash.com/photo-1499856871958-5b9627545d1a?w=400',
        description: 'Louvre Museum highlights with art historian',
        highlights: ['Skip the line', 'Mona Lisa viewing', 'Expert commentary'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '20',
        title: 'Street Art Walking Tour',
        location: 'Berlin, Germany',
        category: 'culture',
        rating: 4.6,
        reviews: 987,
        price: 30,
        duration: '2 hours',
        imageUrl: 'https://images.unsplash.com/photo-1499781350541-7783f6c6a0c8?w=400',
        description: 'Discover vibrant street art and graffiti culture',
        highlights: ['Local artists', 'Berlin Wall', 'Photography'],
        isPopular: false,
      ),

      // FOOD Activities
      ActivitySearchResult(
        id: '21',
        title: 'Street Food Night Market Tour',
        location: 'Taipei, Taiwan',
        category: 'food',
        rating: 4.9,
        reviews: 3456,
        price: 55,
        duration: '3 hours',
        imageUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=400',
        description: 'Taste 10+ local dishes at famous night markets',
        highlights: ['10+ tastings', 'Local guide', 'Market access'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '22',
        title: 'Wine Tasting Tour',
        location: 'Tuscany, Italy',
        category: 'food',
        rating: 4.9,
        reviews: 2876,
        price: 120,
        duration: '4 hours',
        imageUrl: 'https://images.unsplash.com/photo-1506377247377-2a5b3b417ebb?w=400',
        description: 'Visit 3 wineries and taste premium Tuscan wines',
        highlights: ['5+ wines', 'Cheese pairing', 'Vineyard tours'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '23',
        title: 'Sushi Making Class',
        location: 'Tokyo, Japan',
        category: 'food',
        rating: 4.8,
        reviews: 2134,
        price: 85,
        duration: '2.5 hours',
        imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
        description: 'Learn to make authentic sushi with master chef',
        highlights: ['Fresh fish', 'Sake tasting', 'Certificate'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '24',
        title: 'Chocolate Making Workshop',
        location: 'Brussels, Belgium',
        category: 'food',
        rating: 4.7,
        reviews: 1543,
        price: 70,
        duration: '2 hours',
        imageUrl: 'https://images.unsplash.com/photo-1511381939415-e44015466834?w=400',
        description: 'Create Belgian chocolates with chocolatier',
        highlights: ['Take home chocolates', 'Tasting session', 'Recipe book'],
        isPopular: false,
      ),
      ActivitySearchResult(
        id: '25',
        title: 'Farm to Table Dinner Experience',
        location: 'Napa Valley, USA',
        category: 'food',
        rating: 5.0,
        reviews: 876,
        price: 180,
        duration: '3 hours',
        imageUrl: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400',
        description: 'Multi-course meal with ingredients from local farm',
        highlights: ['5-course meal', 'Wine pairing', 'Farm tour'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '26',
        title: 'Tapas and Wine Evening',
        location: 'Barcelona, Spain',
        category: 'food',
        rating: 4.8,
        reviews: 2987,
        price: 65,
        duration: '2.5 hours',
        imageUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=400',
        description: 'Sample authentic tapas at 4 local bars',
        highlights: ['4 venues', '8+ tapas', 'Drinks included'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '27',
        title: 'Coffee Plantation Tour',
        location: 'Medellin, Colombia',
        category: 'food',
        rating: 4.7,
        reviews: 1234,
        price: 45,
        duration: '3 hours',
        imageUrl: 'https://images.unsplash.com/photo-1511537190424-bbbab87ac5eb?w=400',
        description: 'Learn about coffee production from bean to cup',
        highlights: ['Coffee tasting', 'Plantation tour', 'Fresh beans'],
        isPopular: false,
      ),
      ActivitySearchResult(
        id: '28',
        title: 'Michelin Star Dining Experience',
        location: 'Singapore',
        category: 'food',
        rating: 5.0,
        reviews: 654,
        price: 300,
        duration: '2.5 hours',
        imageUrl: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400',
        description: 'Exclusive tasting menu at award-winning restaurant',
        highlights: ['8-course meal', 'Wine pairing', 'Chef meet & greet'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '29',
        title: 'Brewery Tour and Tasting',
        location: 'Munich, Germany',
        category: 'food',
        rating: 4.6,
        reviews: 1876,
        price: 40,
        duration: '2 hours',
        imageUrl: 'https://images.unsplash.com/photo-1532634922-8fe0b757fb13?w=400',
        description: 'Tour historic brewery and taste traditional beers',
        highlights: ['5 beer styles', 'Pretzel pairing', 'History tour'],
        isPopular: false,
      ),
      ActivitySearchResult(
        id: '30',
        title: 'Dim Sum Cooking Class',
        location: 'Hong Kong',
        category: 'food',
        rating: 4.7,
        reviews: 1543,
        price: 60,
        duration: '2.5 hours',
        imageUrl: 'https://images.unsplash.com/photo-1563245372-f21724e3856d?w=400',
        description: 'Master the art of making dumplings and dim sum',
        highlights: ['Dumpling making', 'Tea ceremony', 'Lunch included'],
        isPopular: false,
      ),

      // NATURE Activities
      ActivitySearchResult(
        id: '31',
        title: 'Wildlife Safari Game Drive',
        location: 'Serengeti, Tanzania',
        category: 'nature',
        rating: 5.0,
        reviews: 4567,
        price: 350,
        duration: 'Full day',
        imageUrl: 'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=400',
        description: 'See the Big Five in their natural habitat',
        highlights: ['Big Five', 'Expert guide', 'Lunch included'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '32',
        title: 'Whale Watching Cruise',
        location: 'Reykjavik, Iceland',
        category: 'nature',
        rating: 4.8,
        reviews: 2876,
        price: 110,
        duration: '3 hours',
        imageUrl: 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=400',
        description: 'Spot humpback whales and dolphins in Faxaflói Bay',
        highlights: ['Whale guarantee', 'Hot drinks', 'Expert commentary'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '33',
        title: 'Amazon Rainforest Trek',
        location: 'Manaus, Brazil',
        category: 'nature',
        rating: 4.9,
        reviews: 1987,
        price: 280,
        duration: '2 days',
        imageUrl: 'https://images.unsplash.com/photo-1511497584788-876760111969?w=400',
        description: 'Explore the world\'s largest rainforest',
        highlights: ['Wildlife spotting', 'Camping', 'Local guide'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '34',
        title: 'Northern Lights Photography Tour',
        location: 'Tromsø, Norway',
        category: 'nature',
        rating: 4.9,
        reviews: 3214,
        price: 150,
        duration: '4-6 hours',
        imageUrl: 'https://images.unsplash.com/photo-1483347756197-71ef80e95f73?w=400',
        description: 'Chase the Aurora Borealis with pro photographer',
        highlights: ['Photos included', 'Hot drinks', 'Small group'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '35',
        title: 'Bird Watching Tour',
        location: 'Costa Rica Rainforest',
        category: 'nature',
        rating: 4.6,
        reviews: 876,
        price: 75,
        duration: '3 hours',
        imageUrl: 'https://images.unsplash.com/photo-1444464666168-49d633b86797?w=400',
        description: 'Spot exotic birds including toucans and parrots',
        highlights: ['Binoculars provided', 'Expert ornithologist', 'Small group'],
        isPopular: false,
      ),
      ActivitySearchResult(
        id: '36',
        title: 'Dolphin Swimming Experience',
        location: 'Azores, Portugal',
        category: 'nature',
        rating: 4.9,
        reviews: 2543,
        price: 95,
        duration: '2.5 hours',
        imageUrl: 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=400',
        description: 'Swim with wild dolphins in crystal clear waters',
        highlights: ['Wetsuit provided', 'Marine biologist', 'Photos included'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '37',
        title: 'Volcano Hiking Adventure',
        location: 'Big Island, Hawaii',
        category: 'nature',
        rating: 4.8,
        reviews: 1654,
        price: 125,
        duration: '5 hours',
        imageUrl: 'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?w=400',
        description: 'Hike to active lava flows at Kilauea',
        highlights: ['Lava viewing', 'Expert guide', 'Safety gear'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '38',
        title: 'Canyon Exploration Tour',
        location: 'Grand Canyon, USA',
        category: 'nature',
        rating: 4.9,
        reviews: 4321,
        price: 200,
        duration: 'Full day',
        imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
        description: 'Explore the majestic Grand Canyon with guide',
        highlights: ['Sunrise viewing', 'Hiking trails', 'Lunch included'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '39',
        title: 'Jungle Canopy Walk',
        location: 'Borneo, Malaysia',
        category: 'nature',
        rating: 4.7,
        reviews: 1234,
        price: 65,
        duration: '2 hours',
        imageUrl: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400',
        description: 'Walk among the treetops on suspended bridges',
        highlights: ['Canopy bridges', 'Wildlife spotting', 'Orangutans'],
        isPopular: false,
      ),
      ActivitySearchResult(
        id: '40',
        title: 'Desert Camel Safari',
        location: 'Jaisalmer, India',
        category: 'nature',
        rating: 4.6,
        reviews: 1876,
        price: 80,
        duration: '4 hours',
        imageUrl: 'https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=400',
        description: 'Ride camels through the Thar Desert at sunset',
        highlights: ['Sunset views', 'Cultural show', 'Dinner included'],
        isPopular: false,
      ),

      // More ADVENTURE
      ActivitySearchResult(
        id: '41',
        title: 'Mountain Biking Trail',
        location: 'Whistler, Canada',
        category: 'adventure',
        rating: 4.7,
        reviews: 1543,
        price: 105,
        duration: '3 hours',
        imageUrl: 'https://images.unsplash.com/photo-1544191696-102dbdaeeaa0?w=400',
        description: 'Tackle world-famous mountain bike trails',
        highlights: ['Bike rental', 'Safety gear', 'Trail guide'],
        isPopular: false,
      ),
      ActivitySearchResult(
        id: '42',
        title: 'Hot Air Balloon Ride',
        location: 'Cappadocia, Turkey',
        category: 'adventure',
        rating: 5.0,
        reviews: 5678,
        price: 200,
        duration: '1.5 hours',
        imageUrl: 'https://images.unsplash.com/photo-1507608869274-d3177c8bb4c7?w=400',
        description: 'Float over fairy chimneys at sunrise',
        highlights: ['Sunrise flight', 'Champagne toast', 'Certificate'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '43',
        title: 'Canyoning Adventure',
        location: 'Swiss Alps',
        category: 'adventure',
        rating: 4.8,
        reviews: 987,
        price: 130,
        duration: '4 hours',
        imageUrl: 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=400',
        description: 'Jump, slide, and rappel down mountain canyons',
        highlights: ['All equipment', 'Expert guides', 'Photos included'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '44',
        title: 'Horseback Riding Mountain Trail',
        location: 'Patagonia, Chile',
        category: 'adventure',
        rating: 4.6,
        reviews: 876,
        price: 95,
        duration: '3 hours',
        imageUrl: 'https://images.unsplash.com/photo-1553284965-83fd3e82fa5a?w=400',
        description: 'Ride through stunning Patagonian landscapes',
        highlights: ['Horse rental', 'Scenic views', 'Snacks included'],
        isPopular: false,
      ),
      ActivitySearchResult(
        id: '45',
        title: 'Snowboarding Lessons',
        location: 'Aspen, USA',
        category: 'adventure',
        rating: 4.7,
        reviews: 1234,
        price: 150,
        duration: '4 hours',
        imageUrl: 'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400',
        description: 'Learn to shred with professional instructors',
        highlights: ['Equipment rental', 'Lift pass', 'Small groups'],
        isPopular: false,
      ),

      // More CULTURE
      ActivitySearchResult(
        id: '46',
        title: 'Calligraphy Workshop',
        location: 'Seoul, South Korea',
        category: 'culture',
        rating: 4.6,
        reviews: 654,
        price: 35,
        duration: '2 hours',
        imageUrl: 'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=400',
        description: 'Learn traditional Korean brush painting',
        highlights: ['Materials included', 'Take home art', 'Tea ceremony'],
        isPopular: false,
      ),
      ActivitySearchResult(
        id: '47',
        title: 'Pyramid and Sphinx Tour',
        location: 'Giza, Egypt',
        category: 'culture',
        rating: 4.9,
        reviews: 6789,
        price: 70,
        duration: '4 hours',
        imageUrl: 'https://images.unsplash.com/photo-1568322445389-f64ac2515020?w=400',
        description: 'Explore ancient wonders with Egyptologist',
        highlights: ['Expert guide', 'Skip lines', 'Camel ride'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '48',
        title: 'Traditional Tea Ceremony',
        location: 'Kyoto, Japan',
        category: 'culture',
        rating: 4.8,
        reviews: 2134,
        price: 45,
        duration: '1.5 hours',
        imageUrl: 'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=400',
        description: 'Experience authentic Japanese tea ritual',
        highlights: ['Kimono wearing', 'Traditional sweets', 'Historic tea house'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '49',
        title: 'Opera Night at La Scala',
        location: 'Milan, Italy',
        category: 'culture',
        rating: 5.0,
        reviews: 1543,
        price: 180,
        duration: '3 hours',
        imageUrl: 'https://images.unsplash.com/photo-1507924538820-ede94a04019d?w=400',
        description: 'World-class opera performance at legendary venue',
        highlights: ['Premium seats', 'Program included', 'Champagne interval'],
        isPopular: true,
      ),
      ActivitySearchResult(
        id: '50',
        title: 'Indigenous Cultural Experience',
        location: 'Uluru, Australia',
        category: 'culture',
        rating: 4.9,
        reviews: 987,
        price: 120,
        duration: '4 hours',
        imageUrl: 'https://images.unsplash.com/photo-1523805009345-7448845a9e53?w=400',
        description: 'Learn about Aboriginal culture and traditions',
        highlights: ['Storytelling', 'Bush tucker', 'Didgeridoo performance'],
        isPopular: true,
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
          filteredResults = List.from(allResults);
        } else {
          final searchTerm = _searchController.text.toLowerCase();
          filteredResults = allResults.where((result) {
            return result.title.toLowerCase().contains(searchTerm) ||
                   result.location.toLowerCase().contains(searchTerm) ||
                   result.category.toLowerCase().contains(searchTerm) ||
                   result.description.toLowerCase().contains(searchTerm) ||
                   result.highlights.any((h) => h.toLowerCase().contains(searchTerm));
          }).toList();
        }
        
        _applyFiltersAndSort();
        _isSearching = false;
      });
    });
  }

  void _applyFiltersAndSort() {
    // Start with all filtered results from search
    List<ActivitySearchResult> tempResults = List.from(filteredResults);
    
    // Apply filter by category
    if (_filterBy != 'all') {
      tempResults = tempResults.where((result) {
        return result.category.toLowerCase() == _filterBy.toLowerCase();
      }).toList();
    }

    // Apply sort
    if (_sortBy == 'rating') {
      tempResults.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sortBy == 'price') {
      tempResults.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'popular') {
      tempResults.sort((a, b) {
        if (a.isPopular && !b.isPopular) return -1;
        if (!a.isPopular && b.isPopular) return 1;
        return b.reviews.compareTo(a.reviews);
      });
    } else if (_sortBy == 'reviews') {
      tempResults.sort((a, b) => b.reviews.compareTo(a.reviews));
    }
    
    // Apply grouping logic if needed (visual grouping can be added later)
    // For now, groupBy just affects the display order
    if (_groupBy == 'category') {
      tempResults.sort((a, b) => a.category.compareTo(b.category));
    } else if (_groupBy == 'location') {
      tempResults.sort((a, b) => a.location.compareTo(b.location));
    } else if (_groupBy == 'price') {
      tempResults.sort((a, b) => a.price.compareTo(b.price));
    }
    
    filteredResults = tempResults;
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

                  // Results Header
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Results (${filteredResults.length})',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Results List
                  _isSearching
                      ? _buildLoadingIndicator()
                      : _buildResultsList(),
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
                hintText: 'Search activities, cities, experiences...',
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
                    ['category', 'location', 'price'],
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
                    ['all', 'adventure', 'culture', 'food', 'nature'],
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
                    ['rating', 'price', 'popular', 'reviews'],
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
                    Icons.search,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'Searching...',
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

  Widget _buildResultsList() {
    if (filteredResults.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: filteredResults.asMap().entries.map((entry) {
        int index = entry.key;
        ActivitySearchResult result = entry.value;
        return _buildResultCard(result, index);
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
                    Icons.search_off,
                    size: 60,
                    color: Color(0xFF667EEA),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'No Results Found',
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

  Widget _buildResultCard(ActivitySearchResult result, int index) {
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
                  onTap: () => _showActivityDetail(result),
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Section
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            child: result.imageUrl.isNotEmpty
                                ? Image.network(
                                    result.imageUrl,
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: double.infinity,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              const Color(0xFF667EEA).withOpacity(0.3),
                                              const Color(0xFF764BA2).withOpacity(0.3),
                                            ],
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.image,
                                            size: 60,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    width: double.infinity,
                                    height: 180,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFF667EEA).withOpacity(0.3),
                                          const Color(0xFF764BA2).withOpacity(0.3),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                          if (result.isPopular)
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFFD93D),
                                      Color(0xFFFFAB00),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Popular',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      // Content Section
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title and Category
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    result.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2C3E50),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF667EEA).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    result.category,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF667EEA),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Location
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: Color(0xFFFF6B6B),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    result.location,
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
                            const SizedBox(height: 8),
                            // Description
                            Text(
                              result.description,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF5A6C7D),
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            // Rating, Duration, Price
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 14,
                                      color: Color(0xFFFFAB00),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${result.rating} (${result.reviews})',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2C3E50),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: 14,
                                      color: Color(0xFF667EEA),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      result.duration,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF95A3B3),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF6BCB77),
                                        Color(0xFF4CAF50),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '\$${result.price.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
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
        );
      },
    );
  }

  void _showActivityDetail(ActivitySearchResult result) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ActivityDetailPage(activity: result),
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
}

// Activity Detail Page
class ActivityDetailPage extends StatefulWidget {
  final ActivitySearchResult activity;

  const ActivityDetailPage({super.key, required this.activity});

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _scaleController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Hero Image
          FadeTransition(
            opacity: _fadeAnimation,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              child: widget.activity.imageUrl.isNotEmpty
                  ? Image.network(
                      widget.activity.imageUrl,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        ),
                      ),
                    ),
            ),
          ),
          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                    const Color(0xFFF8F9FF),
                  ],
                  stops: const [0.0, 0.4, 0.7],
                ),
              ),
            ),
          ),
          // Content
          DraggableScrollableSheet(
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
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.activity.title,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Color(0xFFFF6B6B), size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.activity.location,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF5A6C7D),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Text(
                                widget.activity.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF5A6C7D),
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Highlights',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...widget.activity.highlights.map((highlight) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: Color(0xFF6BCB77),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        highlight,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF5A6C7D),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                              const SizedBox(height: 32),
                              SizedBox(
                                width: double.infinity,
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
                                  child: Text(
                                    'Book for \$${widget.activity.price.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
          ),
          // Close Button
          Positioned(
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
          ),
        ],
      ),
    );
  }
}
