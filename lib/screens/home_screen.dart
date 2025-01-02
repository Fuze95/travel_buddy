import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/destination_provider.dart';
import '../widgets/category_chip.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/destination_card.dart';
import '../utils/category_data.dart';
import '../screens/favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;

  const HomeScreen({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DestinationProvider>(context, listen: false).fetchDestinations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: Consumer<DestinationProvider>(
        builder: (context, destinationProvider, child) {
          if (destinationProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting Section
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ayubowan,',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'Rubik',
                        ),
                      ),
                      Text(
                        widget.userName,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Rozha One',
                        ),
                      ),
                    ],
                  ),
                ),

                // Categories
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: CategoryData.categories.length,
                    itemBuilder: (context, index) {
                      final category = CategoryData.categories[index];
                      return CategoryChip(
                        label: category['name'],
                        icon: category['icon'],
                        isSelected: _selectedCategory == category['name'],
                        onTap: () => setState(() => _selectedCategory = category['name']),
                      );
                    },
                  ),
                ),

                // Horizontal Destination List
                Container(
                  height: 220,
                  margin: const EdgeInsets.only(top: 24),
                  child: Consumer<DestinationProvider>(
                    builder: (context, provider, child) {
                      final filteredDestinations = provider.getDestinationsByCategory(_selectedCategory);

                      if (filteredDestinations.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'No destinations found for $_selectedCategory category',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredDestinations.length,
                        itemBuilder: (context, index) {
                          final destination = filteredDestinations[index];
                          return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: DestinationCard(
                              destination: destination,
                              isPopular: false,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // Popular Destinations Section
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Popular Destinations',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Rozha One',
                          ),
                        ),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: destinationProvider.popularDestinations.length,
                        itemBuilder: (context, index) {
                          final destination = destinationProvider.popularDestinations[index];
                          return DestinationCard(
                            destination: destination,
                            isPopular: true,
                          );
                        },
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
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 4) { // Favorites
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const FavoritesScreen(),
              ),
            );
          }
        },
      ),
    );
  }
}