import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTripScreen extends StatefulWidget {
  const NewTripScreen({super.key});

  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen>
    with SingleTickerProviderStateMixin {
  DateTime? startDate;
  DateTime? endDate;
  String? selectedPlace;
  late AnimationController _animationController;

  final List<String> popularPlaces = [
    'Paris',
    'Tokyo',
    'New York',
    'Barcelona',
    'Dubai',
    'Rome',
    'London',
    'Amsterdam',
    'Bangkok',
    'Sydney'
  ];

  final List<Map<String, String>> suggestedActivities = [
    {
      'title': 'Museum Visit',
      'icon': '🏛️',
      'color': '#FF6B6B'
    },
    {
      'title': 'Beach Day',
      'icon': '🏖️',
      'color': '#4ECDC4'
    },
    {
      'title': 'Mountain Trek',
      'icon': '⛰️',
      'color': '#95E1D3'
    },
    {
      'title': 'Food Tour',
      'icon': '🍽️',
      'color': '#FFD93D'
    },
    {
      'title': 'Water Sports',
      'icon': '🏄',
      'color': '#6BCB77'
    },
    {
      'title': 'Night Life',
      'icon': '🎉',
      'color': '#A8E6CF'
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF667EEA),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  Future<void> _selectPlace(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Select a Destination',
          style: TextStyle(
            color: Color(0xFF667EEA),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: popularPlaces.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(popularPlaces[index]),
              onTap: () {
                setState(() {
                  selectedPlace = popularPlaces[index];
                });
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: CustomScrollView(
        slivers: [
          // Header with Gradient
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
          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plan a new trip section
                  _buildSectionHeader('Plan a new trip'),
                  const SizedBox(height: 16),
                  _buildInputCard(),
                  const SizedBox(height: 40),

                  // Suggestions section
                  _buildSectionHeader('Suggestions for Places to Visit'),
                  const SizedBox(height: 16),
                  _buildSuggestionsGrid(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2C3E50),
      ),
    );
  }

  Widget _buildInputCard() {
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
      child: Column(
        children: [
          // Start Date
          _buildInputField(
            label: 'Start Date',
            value: startDate != null ? DateFormat('dd MMM yyyy').format(startDate!) : 'Select date',
            icon: Icons.calendar_today,
            onTap: () => _selectDate(context, true),
            isDate: true,
          ),
          const SizedBox(height: 20),

          // Place Selection
          _buildInputField(
            label: 'Select a Place',
            value: selectedPlace ?? 'Choose destination',
            icon: Icons.location_on,
            onTap: () => _selectPlace(context),
            isDate: false,
          ),
          const SizedBox(height: 20),

          // End Date
          _buildInputField(
            label: 'End Date',
            value: endDate != null ? DateFormat('dd MMM yyyy').format(endDate!) : 'Select date',
            icon: Icons.calendar_today,
            onTap: () => _selectDate(context, false),
            isDate: true,
          ),
          const SizedBox(height: 24),

          // Create Trip Button
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed: _validateAndCreateTrip,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Create Trip',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
    required bool isDate,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE0E7FF),
            width: 2,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF667EEA),
              size: 22,
            ),
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
                    style: TextStyle(
                      fontSize: 16,
                      color: value.contains('Select') || value.contains('Choose')
                          ? const Color(0xFFBCC3D0)
                          : const Color(0xFF2C3E50),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xFFBCC3D0),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: suggestedActivities.length,
      itemBuilder: (context, index) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(
                index * 0.1,
                0.8 + (index * 0.1),
                curve: Curves.elasticOut,
              ),
            ),
          ),
          child: _buildActivityCard(suggestedActivities[index]),
        );
      },
    );
  }

  Widget _buildActivityCard(Map<String, String> activity) {
    final color = Color(
      int.parse(activity['color']!.replaceFirst('#', '0xff')),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _addActivityToTrip(activity['title']),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.8),
                color.withOpacity(0.6),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                activity['icon']!,
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 12),
              Text(
                activity['title']!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateAndCreateTrip() {
    if (startDate == null || endDate == null || selectedPlace == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Color(0xFFFF6B6B),
        ),
      );
      return;
    }

    if (endDate!.isBefore(startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End date must be after start date'),
          backgroundColor: Color(0xFFFF6B6B),
        ),
      );
      return;
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Trip to $selectedPlace created! (${DateFormat('dd MMM').format(startDate!)} - ${DateFormat('dd MMM yyyy').format(endDate!)})',
        ),
        backgroundColor: const Color(0xFF6BCB77),
      ),
    );

    // Reset form
    setState(() {
      startDate = null;
      endDate = null;
      selectedPlace = null;
    });
  }

  void _addActivityToTrip(String? activity) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $activity to your trip!'),
        backgroundColor: const Color(0xFF667EEA),
      ),
    );
  }
}
