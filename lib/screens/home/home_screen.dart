import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorites_provider.dart';

import '../../models/api_watch_model.dart';
import '../../providers/connectivity_provider.dart';
import '../../services/api_service.dart';
import '../details/watch_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<ApiWatchModel>> watchesFuture;

  // Premium UI Theme Accents
  final Color primaryGold = const Color(0xFFE5A922);
  int _currentTabIndex = 0;

  // Category Tab Options
  final List<String> _categories = [
    'All',
    'Luxury',
    'Trending',
    'Sport',
    'Classic',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    watchesFuture = ApiService().fetchWatches(
      isOnline: connectivityProvider.isOnline,
    );
  }

  @override
  Widget build(BuildContext context) {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      body: SafeArea(
        child: FutureBuilder<List<ApiWatchModel>>(
          future: watchesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE5A922)),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    snapshot.error.toString(),
                    style: TextStyle(
                      color:
                          isDark
                              ? Colors.white70
                              : Colors.black.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final watches = snapshot.data!;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              favoritesProvider.loadFavorites(watches);
            });

            return RefreshIndicator(
              color: primaryGold,
              onRefresh: () async {
                setState(() {
                  watchesFuture = ApiService().fetchWatches(
                    isOnline: connectivityProvider.isOnline,
                  );
                });
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. "AURA" Title and Online/Offline Badge Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'AURA',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: primaryGold,
                              letterSpacing: 2.0,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  connectivityProvider.isOnline
                                      ? Colors.green.withOpacity(0.15)
                                      : Colors.red.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              connectivityProvider.isOnline
                                  ? 'Online'
                                  : 'Offline',
                              style: TextStyle(
                                color:
                                    connectivityProvider.isOnline
                                        ? Colors.green
                                        : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // 2. Greeting block below title
                      Text(
                        'Welcome back, Elegance',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white60 : Colors.grey[600],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 3. Modernized Structural Search Bar
                      TextField(
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search collection...',
                          hintStyle: TextStyle(
                            color: isDark ? Colors.white54 : Colors.grey[400],
                            fontSize: 15,
                          ),
                          prefixIcon: Icon(Icons.search, color: primaryGold),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          fillColor:
                              isDark ? Colors.grey[850] : Colors.grey[100],
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: primaryGold,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 4. Premium Slideshow Promotional Section
                      Container(
                        height: 170,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [primaryGold, primaryGold.withOpacity(0.7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryGold.withOpacity(0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: -20,
                              bottom: -20,
                              child: Icon(
                                Icons.spa_outlined,
                                size: 180,
                                color: Colors.white.withOpacity(0.15),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'Featured Spotlight',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Discover The\nPremium Artisans',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // 5. Section Header Text Component
                      Text(
                        'Shop',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // 6. Horizontally Scrollable Filtering Category Tabs
                      SizedBox(
                        height: 38,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            bool isSelected = _currentTabIndex == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _currentTabIndex = index;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? primaryGold
                                          : (isDark
                                              ? Colors.grey[850]
                                              : Colors.grey[100]),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  _categories[index],
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.black
                                            : (isDark
                                                ? Colors.white70
                                                : Colors.black54),
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 7. Watch Details Dynamic Grid Cards Section
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: watches.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.64,
                            ),
                        itemBuilder: (context, index) {
                          final watch = watches[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => WatchDetailScreen(watch: watch),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    isDark
                                        ? Colors.grey[850]
                                        : Colors.grey[500]!.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color:
                                      isDark
                                          ? Colors.grey[800]!
                                          : Colors.grey[200]!,
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Watch Card Image Render Box with Native Preserved Validation Flags
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color:
                                            isDark
                                                ? Colors.grey[900]
                                                : Colors.white,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Hero(
                                        tag: 'watch_${watch.id}',
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          child:
                                              watch.image.startsWith('http')
                                                  ? Image.network(
                                                    watch.image,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
                                                      return Container(
                                                        color:
                                                            Colors
                                                                .grey
                                                                .shade300,
                                                        child: const Center(
                                                          child: Icon(
                                                            Icons.watch,
                                                            size: 40,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  )
                                                  : Image.asset(
                                                    watch.image,
                                                    fit: BoxFit.cover,
                                                  ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Dynamic Watch Title Text
                                  Text(
                                    watch.title,
                                    style: TextStyle(
                                      color:
                                          isDark
                                              ? Colors.white
                                              : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),

                                  // Dynamic Watch Description Text
                                  Text(
                                    watch.description,
                                    style: TextStyle(
                                      color:
                                          isDark
                                              ? Colors.white54
                                              : Colors.grey[600],
                                      fontSize: 11,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),

                                  // Dynamic Price Rendering Container Info
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '\$${watch.price}',
                                        style: TextStyle(
                                          color: primaryGold,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),

                                        onPressed: () async {
                                          await favoritesProvider
                                              .toggleFavorite(watch);
                                        },

                                        icon: Icon(
                                          favoritesProvider.isFavorite(watch)
                                              ? Icons.favorite
                                              : Icons.favorite_border,

                                          color:
                                              favoritesProvider.isFavorite(
                                                    watch,
                                                  )
                                                  ? Colors.red
                                                  : primaryGold,

                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
