import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/trip_service.dart';
import 'itenary_page.dart';

class PlanTripPage extends StatefulWidget {
  const PlanTripPage({super.key});

  @override
  State<PlanTripPage> createState() => _PlanTripPageState();
}

class _PlanTripPageState extends State<PlanTripPage> {
  final _formKey = GlobalKey<FormState>();
  final _tripNameController = TextEditingController();
  final _destinationController = TextEditingController();
  final _tripService = TripService();
  final _authService = AuthService();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isSubmitting = false;

  int _currentIndex = 1;

Widget _buildBottomNav() {
  return BottomNavigationBar(
    currentIndex: _currentIndex,
     backgroundColor: const Color.fromARGB(255, 0, 0, 0),          // 👈 force background
  selectedItemColor: Colors.blue,          // 👈 active icon
  unselectedItemColor: Colors.grey[600],   // 👈 inactive icons
  type: BottomNavigationBarType.fixed, 
    onTap: (index) {
      setState(() {
        _currentIndex = index;
      });

      // Example navigation logic
      if (index == 0) {
        Navigator.pop(context); // Home
      } else if (index == 2) {
        // Profile page later
      }
    },
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add_location_alt),
        
        label: 'Plan',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ],
  );
}


  // Popular destinations
  final List<String> destinations = [
    'Paris, France',
    'Tokyo, Japan',
    'Barcelona, Spain',
    'Rome, Italy',
    'Dubai, UAE',
    'New York, USA',
    'London, UK',
    'Amsterdam, Netherlands',
  ];

  // Activity suggestions
  final List<ActivitySuggestion> activitySuggestions = [
    ActivitySuggestion(name: 'Fancy Turkey', icon: '🦃'),
    ActivitySuggestion(name: 'Total Ostrich', icon: '🐦'),
    ActivitySuggestion(name: 'Careful Frog', icon: '🐸'),
    ActivitySuggestion(name: 'Conscious Emu', icon: '🪶'),
    ActivitySuggestion(name: 'Cultivated Sheep', icon: '🐑'),
    ActivitySuggestion(name: 'Passionate Horse', icon: '🐴'),
    ActivitySuggestion(name: 'Majestic Jaguar', icon: '🐆'),
    ActivitySuggestion(name: 'Nihal H.', icon: '✨'),
  ];

  List<ActivitySuggestion> selectedActivities = [];

  @override
  void dispose() {
    _tripNameController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate() async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start date first')),
      );
      return;
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate!.add(const Duration(days: 1)),
      firstDate: _startDate!.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _toggleActivitySelection(ActivitySuggestion activity) {
    setState(() {
      if (selectedActivities.contains(activity)) {
        selectedActivities.remove(activity);
      } else {
        selectedActivities.add(activity);
      }
    });
  }

  Future<void> _createTrip() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start and end dates')),
      );
      return;
    }

    final userId = _authService.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need to log in again.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _tripService.createTrip(
        userId: userId,
        title: _tripNameController.text,
        destination: _destinationController.text,
        startDate: _startDate!,
        endDate: _endDate!,
        status: 'Planned',
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trip created successfully'),
          duration: Duration(seconds: 2),
        ),
      );
      
      // Navigate to itinerary builder
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ItineraryPage(
            tripName: _tripNameController.text,
            tripStartDate: _startDate!,
            tripEndDate: _endDate!,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create trip: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan a new trip'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trip Name Field
                Text(
                  'Trip Name',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _tripNameController,
                  decoration: InputDecoration(
                    hintText: 'e.g., Summer Vacation',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter trip name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Destination Field
                Text(
                  'Select Destination',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: 'Choose a destination',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: destinations.map((destination) {
                    return DropdownMenuItem(
                      value: destination,
                      child: Text(destination),
                    );
                  }).toList(),
                  onChanged: (value) {
                    _destinationController.text = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a destination';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Start Date Field
                Text(
                  'Start Date',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _selectStartDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _startDate == null
                              ? 'Select start date'
                              : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                          style: TextStyle(
                            fontSize: 16,
                            color: _startDate == null
                                ? Colors.grey[600]
                                : Colors.black,
                          ),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.blue),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // End Date Field
                Text(
                  'End Date',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _selectEndDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _endDate == null
                              ? 'Select end date'
                              : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                          style: TextStyle(
                            fontSize: 16,
                            color: _endDate == null ? Colors.grey[600] : Colors.black,
                          ),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.blue),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Activities Suggestions
                Text(
                  'Suggestions for Places to Visit/Activities to perform',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: activitySuggestions.length,
                  itemBuilder: (context, index) {
                    final activity = activitySuggestions[index];
                    final isSelected = selectedActivities.contains(activity);

                    return GestureDetector(
                      onTap: () => _toggleActivitySelection(activity),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? Colors.blue
                                : Colors.grey[300]!,
                            width: isSelected ? 2 : 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: isSelected
                              ? Colors.blue.withValues(alpha:0.1)
                              : Colors.transparent,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _toggleActivitySelection(activity),
                            borderRadius: BorderRadius.circular(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  activity.icon,
                                  style: const TextStyle(fontSize: 40),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  activity.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Create Trip Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _createTrip,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Create Trip',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }
}

class ActivitySuggestion {
  final String name;
  final String icon;

  ActivitySuggestion({required this.name, required this.icon});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ActivitySuggestion &&
        other.name == name &&
        other.icon == icon;
  }

  @override
  int get hashCode => name.hashCode ^ icon.hashCode;
}
