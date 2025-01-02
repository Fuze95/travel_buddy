import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({Key? key}) : super(key: key);

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final _planController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<Map<String, String>> selectedDestinations = [];
  String? selectedDestinationId;
  bool isLoading = true;
  List<Map<String, String>> destinations = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchDestinations();
  }

  Future<void> _fetchDestinations() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('destinations')
          .get();

      setState(() {
        destinations = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'name': (doc.data() as Map<String, dynamic>)['name'] as String,
          };
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching destinations: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _addSelectedDestination(String? destinationId) {
    if (destinationId == null) return;

    final selectedDestination = destinations.firstWhere(
          (dest) => dest['id'] == destinationId,
      orElse: () => {'id': '', 'name': ''},
    );

    if (selectedDestination['id']!.isNotEmpty &&
        !selectedDestinations.any((dest) => dest['id'] == destinationId)) {
      setState(() {
        selectedDestinations.add(selectedDestination);
      });
    }
  }

  void _removeDestination(Map<String, String> destination) {
    setState(() {
      selectedDestinations.removeWhere((dest) => dest['id'] == destination['id']);
    });
  }

  Future<void> _saveTrip() async {
    if (selectedDestinations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one destination')),
      );
      return;
    }

    final tripData = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'plan': _planController.text,
      'description': _descriptionController.text,
      'destinations': selectedDestinations.map((dest) => {
        'id': dest['id'],
        'name': dest['name'],
      }).toList(),
      'createdAt': DateTime.now().toIso8601String(),
    };

    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> trips = prefs.getStringList('trips') ?? [];
      trips.add(jsonEncode(tripData));
      await prefs.setStringList('trips', trips);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save trip')),
        );
      }
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      isAddTripScreen: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trip',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              'Planning',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Destinations',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedDestinationId,
                  hint: const Text('Select destination'),
                  menuMaxHeight: 300,
                  items: destinations.map((destination) {
                    return DropdownMenuItem(
                      value: destination['id'],
                      child: Text(destination['name'] ?? ''),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDestinationId = value;
                    });
                    _addSelectedDestination(value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: selectedDestinations.map((destination) => Chip(
                label: Text(destination['name'] ?? ''),
                deleteIcon: const Icon(Icons.close, size: 20),
                onDeleted: () => _removeDestination(destination),
              )).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Plan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _planController,
              decoration: InputDecoration(
                hintText: 'Plan 1',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveTrip,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B9475),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        noFill: false,
      ),
    );
  }

  @override
  void dispose() {
    _planController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}