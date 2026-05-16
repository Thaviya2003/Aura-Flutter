import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/favorites_provider.dart';
import '../details/watch_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    final favoriteWatches = favoritesProvider.favorites;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),

      body:
          favoriteWatches.isEmpty
              ? const Center(
                child: Text('No favorites yet', style: TextStyle(fontSize: 20)),
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

                      title: Text(watch.name),

                      subtitle: Text(watch.brand),

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
