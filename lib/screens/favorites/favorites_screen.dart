import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/favorites_provider.dart';
import '../details/watch_detail_screen.dart';
import '../../models/api_watch_model.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    final favoriteWatches = favoritesProvider.favorites.cast<ApiWatchModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),

      body:
          favoriteWatches.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.favorite_border, size: 80, color: Colors.grey),

                    SizedBox(height: 16),

                    Text(
                      'No Favorites Yet',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      'Tap the heart icon on a watch to save it.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),

                itemCount: favoriteWatches.length,

                itemBuilder: (context, index) {
                  final watch = favoriteWatches[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 20),

                    child: ListTile(
                      leading: Hero(
                        tag: watch.image,

                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),

                          child: Image.network(
                            watch.image,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      title: Text(watch.title),

                      subtitle: Text(
                        watch.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      trailing: Text('\$${watch.price.toStringAsFixed(0)}'),

                      onTap: () {
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) => WatchDetailScreen(watch: watch),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
