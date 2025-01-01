import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/destination.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/cdn_image.dart';
import '../services/destination_provider.dart';

class DestinationDetailsScreen extends StatelessWidget {
  final String destinationId;

  const DestinationDetailsScreen({
    Key? key,
    required this.destinationId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Consumer<DestinationProvider>(
        builder: (context, destinationProvider, child) {
          final destination = destinationProvider.destinations
              .firstWhere((d) => d.id == destinationId);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Image Section
                Stack(
                  children: [
                    CdnImage(
                      imageUrl: destination.imageUrl,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Text(
                        destination.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating and Category
                      Row(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                destination.rating.toString(),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          ...destination.category.map((cat) => Chip(
                            label: Text(cat),
                            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          )),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Description
                      Text(
                        'About',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(destination.description),
                      const SizedBox(height: 24),

                      // Weather Information
                      Text(
                        'Weather Information',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      WeatherInfoCard(weatherInfo: destination.weatherInfo),
                      const SizedBox(height: 24),

                      // Activities
                      Text(
                        'Activities',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      ActivitiesList(activities: destination.activities),
                      const SizedBox(height: 24),

                      // Local Tips
                      Text(
                        'Local Tips',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      LocalTipsList(tips: destination.localTips),
                      const SizedBox(height: 24),

                      // Transportation Options
                      Text(
                        'Getting There',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      TransportationList(
                        transportationOptions: destination.transportationOptions,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: -1, // No active index
        noFill: true, // No filled state
        onTap: (_) {}, // Empty callback
      ),
    );
  }
}

// Helper Widgets
class WeatherInfoCard extends StatelessWidget {
  final Map<String, dynamic> weatherInfo;

  const WeatherInfoCard({Key? key, required this.weatherInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.wb_sunny_outlined),
                const SizedBox(width: 8),
                Text('Summer: ${weatherInfo['summerTemp']}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.ac_unit_outlined),
                const SizedBox(width: 8),
                Text('Winter: ${weatherInfo['winterTemp']}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.water_drop_outlined),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Rainy Seasons: ${(weatherInfo['rainySeasons'] as List).join(', ')}',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ActivitiesList extends StatelessWidget {
  final List<String> activities;

  const ActivitiesList({Key? key, required this.activities}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.directions_run),
          title: Text(activities[index]),
          contentPadding: EdgeInsets.zero,
        );
      },
    );
  }
}

class LocalTipsList extends StatelessWidget {
  final List<String> tips;

  const LocalTipsList({Key? key, required this.tips}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tips.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.lightbulb_outline),
          title: Text(tips[index]),
          contentPadding: EdgeInsets.zero,
        );
      },
    );
  }
}

class TransportationList extends StatelessWidget {
  final List<String> transportationOptions;

  const TransportationList({Key? key, required this.transportationOptions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transportationOptions.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.directions_car),
          title: Text(transportationOptions[index]),
          contentPadding: EdgeInsets.zero,
        );
      },
    );
  }
}