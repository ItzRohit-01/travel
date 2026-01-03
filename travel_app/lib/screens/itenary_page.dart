import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ItinerarySection {
  final String id;
  String title;
  String description;
  DateTime? startDate;
  DateTime? endDate;
  double? budget;

  ItinerarySection({
    required this.id,
    required this.title,
    this.description = '',
    this.startDate,
    this.endDate,
    this.budget,
  });
}

class ItineraryPage extends StatefulWidget {
  final String tripName;
  final DateTime tripStartDate;
  final DateTime tripEndDate;

  const ItineraryPage({
    Key? key,
    this.tripName = 'My Trip',
    required this.tripStartDate,
    required this.tripEndDate,
  }) : super(key: key);

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage>
    with SingleTickerProviderStateMixin {
  late List<ItinerarySection> sections;
  late AnimationController _animationController;
  int _sectionCounter = 0;

  @override
  void initState() {
    super.initState();
    sections = [
      ItinerarySection(
        id: '0',
        title: 'Section 1',
        description: 'All the necessary information about this section.\nThis can be anything like trave section, hotel or any other activity',
      ),
    ];
    _sectionCounter = 1;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _addSection() {
    setState(() {
      sections.add(
        ItinerarySection(
          id: _sectionCounter.toString(),
          title: 'Section ${sections.length + 1}',
          description: 'All the necessary information about this section.\nThis can be anything like trave section, hotel or any other activity',
        ),
      );
      _sectionCounter++;
    });
  }

  void _removeSection(int index) {
    if (sections.length > 1) {
      setState(() {
        sections.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Section removed'),
          backgroundColor: Color(0xFF667EEA),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must have at least one section'),
          backgroundColor: Color(0xFFFF6B6B),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _selectDateRange(int index, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (sections[index].startDate ?? widget.tripStartDate)
          : (sections[index].endDate ?? widget.tripEndDate),
      firstDate: widget.tripStartDate,
      lastDate: widget.tripEndDate,
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
          sections[index].startDate = picked;
        } else {
          sections[index].endDate = picked;
        }
      });
    }
  }

  void _editSectionTitle(int index) {
    final controller = TextEditingController(text: sections[index].title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Section Title'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Section name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.edit),
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
                sections[index].title = controller.text.isEmpty
                    ? 'Section ${index + 1}'
                    : controller.text;
              });
              Navigator.pop(context);
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

  void _editSectionDescription(int index) {
    final controller =
        TextEditingController(text: sections[index].description);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Section Description'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Enter description',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.description),
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
                sections[index].description = controller.text;
              });
              Navigator.pop(context);
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

  void _editBudget(int index) {
    final controller = TextEditingController(
      text: sections[index].budget?.toString() ?? '',
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Budget'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter budget amount',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.attach_money),
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
                sections[index].budget =
                    double.tryParse(controller.text) ?? 0;
              });
              Navigator.pop(context);
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
                  // Trip Title
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.tripName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                color: Colors.white70, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              '${DateFormat('dd MMM').format(widget.tripStartDate)} - ${DateFormat('dd MMM yyyy').format(widget.tripEndDate)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Sections
                  ..._buildSections(),
                  const SizedBox(height: 24),

                  // Add Section Button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF667EEA),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _addSection,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add,
                                color: Color(0xFF667EEA),
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Add another Section',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF667EEA),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Save Button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: _saveItinerary,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Save Itinerary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
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

  List<Widget> _buildSections() {
    return List.generate(sections.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(
                index * 0.1,
                0.7 + (index * 0.1),
                curve: Curves.elasticOut,
              ),
            ),
          ),
          child: _buildSectionCard(index),
        ),
      );
    });
  }

  Widget _buildSectionCard(int index) {
    final section = sections[index];
    final colors = [
      const Color(0xFFFF6B6B),
      const Color(0xFF4ECDC4),
      const Color(0xFFFFD93D),
      const Color(0xFF6BCB77),
      const Color(0xFFA8E6CF),
      const Color(0xFF95E1D3),
    ];

    final cardColor = colors[index % colors.length];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header with Title and Delete
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _editSectionTitle(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: cardColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          section.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: cardColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.edit,
                          color: cardColor,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => _removeSection(index),
                  iconSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Description
          GestureDetector(
            onTap: () => _editSectionDescription(index),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: cardColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.description,
                          color: cardColor, size: 16),
                      const SizedBox(width: 8),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF95A3B3),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    section.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF2C3E50),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Date Range and Budget
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  index,
                  section.startDate,
                  section.endDate,
                  cardColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBudgetField(index, section.budget, cardColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(int index, DateTime? startDate, DateTime? endDate,
      Color color) {
    return GestureDetector(
      onTap: () => _selectDateRange(index, true),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: color, size: 14),
                const SizedBox(width: 6),
                const Text(
                  'Date Range',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF95A3B3),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              startDate != null && endDate != null
                  ? '${DateFormat('dd MMM').format(startDate)} - ${DateFormat('dd MMM').format(endDate)}'
                  : 'xxx to yyy',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: startDate != null && endDate != null
                    ? color
                    : const Color(0xFFBCC3D0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetField(int index, double? budget, Color color) {
    return GestureDetector(
      onTap: () => _editBudget(index),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.attach_money, color: color, size: 14),
                const SizedBox(width: 6),
                const Text(
                  'Budget',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF95A3B3),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              budget != null ? '\$${budget.toStringAsFixed(2)}' : 'Add budget',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: budget != null ? color : const Color(0xFFBCC3D0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveItinerary() {
    double totalBudget = 0;
    for (var section in sections) {
      if (section.budget != null) {
        totalBudget += section.budget!;
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Itinerary Saved! 🎉',
          style: TextStyle(
            color: Color(0xFF667EEA),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trip: ${widget.tripName}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Sections: ${sections.length}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Total Budget: \$${totalBudget.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6BCB77),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667EEA),
            ),
            child: const Text(
              'Done',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
