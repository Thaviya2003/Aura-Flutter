import 'package:flutter/material.dart';

import '../../models/api_watch_model.dart';

class WatchDetailScreen extends StatelessWidget {
  final ApiWatchModel watch;

  const WatchDetailScreen({super.key, required this.watch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(watch.title)),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Hero(
              tag: 'watch_${watch.id}',

              child:
                  watch.image.startsWith('http')
                      ? Image.network(
                        watch.image,

                        height: 350,

                        width: double.infinity,

                        fit: BoxFit.cover,

                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 350,

                            color: Colors.grey.shade300,

                            child: const Center(
                              child: Icon(Icons.watch, size: 60),
                            ),
                          );
                        },
                      )
                      : Image.asset(
                        watch.image,

                        height: 350,

                        width: double.infinity,

                        fit: BoxFit.cover,
                      ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    watch.title,

                    style: const TextStyle(
                      fontSize: 28,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    '\$${watch.price}',

                    style: const TextStyle(
                      fontSize: 24,

                      color: Colors.amber,

                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Description',

                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    watch.description,

                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
