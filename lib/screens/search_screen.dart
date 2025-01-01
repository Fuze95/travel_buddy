import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/destination_provider.dart';
import '../models/destination.dart';
import '../widgets/destination_card.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/custom_app_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Destination> _searchResults = [];
  bool _isSearching = false;
  int _currentIndex = 0;
  String _searchError = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query, DestinationProvider provider) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
        _searchError = '';
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchError = '';
    });

    try {
      final results = await provider.searchDestinations(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _searchError = 'An error occurred while searching. Please try again.';
        _isSearching = false;
        _searchResults = [];
      });
    }
  }

  PreferredSizeWidget _buildSearchAppBar() {
    return CustomAppBar(
      isSearchScreen: true,
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search destinations, activities...',
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, color: Colors.grey),
            onPressed: () {
              _searchController.clear();
              _performSearch('', Provider.of<DestinationProvider>(context, listen: false));
            },
          )
              : null,
        ),
        onChanged: (value) {
          if (value.length >= 2) {
            _performSearch(value, Provider.of<DestinationProvider>(context, listen: false));
          } else if (value.isEmpty) {
            _performSearch('', Provider.of<DestinationProvider>(context, listen: false));
          }
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    return Consumer<DestinationProvider>(
      builder: (context, destinationProvider, child) {
        if (_isSearching) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF8B9475),
            ),
          );
        }

        if (_searchError.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  _searchError,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (_searchResults.isEmpty && _searchController.text.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No destinations found for "${_searchController.text}"',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _searchResults.length,
          itemBuilder: (context, index) {
            final destination = _searchResults[index];
            return DestinationCard(
              destination: destination,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/destination-details',
                  arguments: destination,
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildSearchAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          if (_searchController.text.isNotEmpty && _searchResults.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Found ${_searchResults.length} destinations',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          Expanded(child: _buildSearchResults()),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        noFill: true,
      ),
    );
  }
}