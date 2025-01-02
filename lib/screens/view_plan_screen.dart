import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../screens/destination_details_screen.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class ViewPlanScreen extends StatefulWidget {
  final String planId;

  const ViewPlanScreen({Key? key, required this.planId}) : super(key: key);

  @override
  State<ViewPlanScreen> createState() => _ViewPlanScreenState();
}

class _ViewPlanScreenState extends State<ViewPlanScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic>? tripData;
  bool isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadTripData();
  }

  Future<void> _loadTripData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tripsList = prefs.getStringList('trips') ?? [];

      final trip = tripsList
          .map((tripStr) => json.decode(tripStr) as Map<String, dynamic>)
          .firstWhere(
            (trip) => trip['id'] == widget.planId,
        orElse: () => {},
      );

      if (trip.isNotEmpty) {
        setState(() {
          tripData = trip;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading trip data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateToDestinationDetails(String destinationId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DestinationDetailsScreen(
          destinationId: destinationId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        scaffoldKey: _scaffoldKey,
        isViewPlanScreen: true,
      ),
      drawer: CustomDrawer(scaffoldKey: _scaffoldKey),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tripData == null
          ? const Center(child: Text('No plan found'))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
                )
            ),
            const SizedBox(height: 24),
            const Text(
              'Destinations',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: (tripData!['destinations'] as List)
                  .map((destination) {
                return ActionChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(destination['name'] as String),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_outward, size: 16),
                    ],
                  ),
                  onPressed: () => _navigateToDestinationDetails(
                      destination['id'] as String),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Plan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tripData!['plan'] as String,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tripData!['description'] as String,
              style: Theme.of(context).textTheme.bodyLarge,
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
}