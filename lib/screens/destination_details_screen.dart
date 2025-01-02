import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/cdn_image.dart';
import '../services/destination_provider.dart';

class DashedDivider extends StatelessWidget {
  const DashedDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        height: 1,
        color: Colors.grey[300],
        child: Row(
          children: List.generate(
            50,
                (index) => Expanded(
              child: Container(
                color: index % 2 == 0 ? Colors.grey[300] : Colors.white,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
                // Destination Name and Location Header
                Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              destination.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined,
                                    color: Colors.grey[600],
                                    size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  '${destination.name}, Sri Lanka',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 40,  // Matches the height of the name area
                        child: IconButton(
                          icon: Icon(
                            destination.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.grey[600],
                            size: 24,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            // Toggle favorite
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Image
                Stack(
                  children: [
                    CdnImage(
                      imageUrl: destination.imageUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Handle map view
                        },
                        icon: const Icon(Icons.open_in_new, size: 16),
                        label: const Text('View on Map'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          textStyle: const TextStyle(fontSize: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Rating and Category
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        destination.rating.toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.category_outlined, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              destination.category.first,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    destination.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),

                const DashedDivider(),

                // Weather Info
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                  child: Row(
                    children: [
                      WeatherInfoTile(
                        icon: Icons.wb_sunny_outlined,
                        value: '${destination.weatherInfo['summerTemp']}',
                      ),
                      const SizedBox(width: 24),
                      WeatherInfoTile(
                        icon: Icons.water_drop_outlined,
                        value: (destination.weatherInfo['rainySeasons'] as List)
                            .take(2)
                            .join(', '),
                      ),
                    ],
                  ),
                ),

                const DashedDivider(),

                // Activities Section
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(
                    'Activities',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Activities Chips
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: destination.activities.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Chip(
                          label: Text(
                            destination.activities[index],
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: Colors.grey[200],
                          padding: EdgeInsets.zero,
                        ),
                      );
                    },
                  ),
                ),

                const DashedDivider(),

                // Tips Section
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Tips',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Tips List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: destination.localTips.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              destination.localTips[index],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const DashedDivider(),

                // Transportation Section
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Transportation',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Transportation List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: destination.transportationOptions.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              destination.transportationOptions[index],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: -1,
        noFill: true,
        onTap: (_) {},
      ),
    );
  }
}

class WeatherInfoTile extends StatelessWidget {
  final IconData icon;
  final String value;

  const WeatherInfoTile({
    Key? key,
    required this.icon,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}