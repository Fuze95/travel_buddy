import 'package:flutter/material.dart';
import 'dart:convert';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/trip_card.dart';
import '../screens/add_plan_screen.dart';
import '../screens/view_plan_screen.dart';
import '../screens/edit_plan_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TripPlanningScreen extends StatefulWidget {
  const TripPlanningScreen({Key? key}) : super(key: key);

  @override
  State<TripPlanningScreen> createState() => _TripPlanningScreenState();
}

class _TripPlanningScreenState extends State<TripPlanningScreen> {
  List<Map<String, dynamic>> trips = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tripsList = prefs.getStringList('trips') ?? [];

      setState(() {
        trips = tripsList
            .map((tripStr) => json.decode(tripStr) as Map<String, dynamic>)
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load trips')),
        );
      }
    }
  }

  Future<void> _deleteTrip(String tripId) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          title: const Text(
            'Delete Trip',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Are you sure you want to delete this trip?\nThis action cannot be undone.',
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Delete'),
                ),
              ],
            )
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final tripsList = prefs.getStringList('trips') ?? [];

        final updatedTrips = tripsList.where((tripStr) {
          final trip = json.decode(tripStr) as Map<String, dynamic>;
          return trip['id'] != tripId;
        }).toList();

        await prefs.setStringList('trips', updatedTrips);
        await _loadTrips();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Trip deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete trip')),
          );
        }
      }
    }
  }

  Future<String> _getDestinationImageFromFirestore(List<Map<String, dynamic>> destinations) async {
    if (destinations.isEmpty) {
      return 'assets/images/placeholder_destination.jpg';
    }

    try {
      final firstDestination = destinations[0];
      if (firstDestination.containsKey('id')) {
        final String destinationId = firstDestination['id'];

        final docSnapshot = await FirebaseFirestore.instance
            .collection('destinations')
            .doc(destinationId)
            .get();

        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          if (data != null && data.containsKey('imageUrl')) {
            return data['imageUrl'];
          }
        }
      }
    } catch (e) {
      print('Error fetching destination image: $e');
    }

    return 'assets/images/placeholder_destination.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          // Fixed Header Container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trip',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Planning',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddTripScreen(),
                      ),
                    );
                    _loadTrips();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B9475),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content Area
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : trips.isEmpty
                ? Center(
              child: Text(
                'No trips planned yet',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                final destinations = List<Map<String, dynamic>>.from(trip['destinations'] ?? []);

                return FutureBuilder<String>(
                  future: _getDestinationImageFromFirestore(destinations),
                  builder: (context, snapshot) {
                    final imageUrl = snapshot.data ?? 'assets/images/placeholder_destination.jpg';

                    return TripCard(
                      plan: trip['plan'] ?? 'Untitled Plan',
                      description: trip['description'] ?? '',
                      imageUrl: imageUrl,
                      onView: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewPlanScreen(planId: trip['id']),
                          ),
                        );
                      },
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTripScreen(
                              tripId: trip['id'],
                              onUpdateComplete: _loadTrips,
                            ),
                          ),
                        );
                      },
                      onDelete: () => _deleteTrip(trip['id']),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        noFill: false,
        onTap: (index) {},
      ),
    );
  }
}