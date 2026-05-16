import 'package:flutter/material.dart';

import '../../data/watch_data.dart';
import '../../models/watch_model.dart';
import '../details/watch_detail_screen.dart';

import 'package:provider/provider.dart';
import '../../providers/favorites_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AURA')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Luxury Collection',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              'Discover premium timepieces',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: ListView.builder(
                itemCount: watches.length,

                itemBuilder: (context, index) {
                  final WatchModel watch = watches[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) => WatchDetailScreen(watch: watch),
                        ),
                      );
                    },

                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),

                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Hero(
                              tag: watch.image,

                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),

                                child: Image.network(
                                  watch.image,
                                  height: 230,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(16),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    watch.brand,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,

                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    watch.name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,

                                    children: [
                                      Text(
                                        '\$${watch.price.toStringAsFixed(0)}',

                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,

                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                        ),
                                      ),

                                      Row(
                                        children: [
                                          Consumer<FavoritesProvider>(
                                            builder: (
                                              context,
                                              favoritesProvider,
                                              child,
                                            ) {
                                              final isFavorite =
                                                  favoritesProvider.isFavorite(
                                                    watch,
                                                  );

                                              return IconButton(
                                                onPressed: () {
                                                  favoritesProvider
                                                      .toggleFavorite(watch);
                                                },

                                                icon: Icon(
                                                  isFavorite
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,

                                                  color: Colors.red,
                                                ),
                                              );
                                            },
                                          ),

                                          Icon(
                                            Icons.arrow_forward_ios,

                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
