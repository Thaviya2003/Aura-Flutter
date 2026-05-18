import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final connectivityProvider = Provider.of<ConnectivityProvider>(context);

    watchesFuture = ApiService().fetchWatches(
      isOnline: connectivityProvider.isOnline,
    );
  }

  @override
  Widget build(BuildContext context) {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AURA'),

        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),

            child: Center(
              child: Text(
                connectivityProvider.isOnline ? 'Online' : 'Offline',

                style: TextStyle(
                  color:
                      connectivityProvider.isOnline ? Colors.green : Colors.red,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),

      body: FutureBuilder<List<ApiWatchModel>>(
        future: watchesFuture,

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final watches = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                watchesFuture = ApiService().fetchWatches(
                  isOnline: connectivityProvider.isOnline,
                );
              });
            },

            child: ListView.builder(
              padding: const EdgeInsets.all(16),

              itemCount: watches.length,

              itemBuilder: (context, index) {
                final watch = watches[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => WatchDetailScreen(watch: watch),
                      ),
                    );
                  },

                  child: Card(
                    elevation: 5,

                    margin: const EdgeInsets.only(bottom: 20),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Hero(
                          tag: 'watch_${watch.id}',

                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),

                            child:
                                watch.image.startsWith('http')
                                    ? Image.network(
                                      watch.image,

                                      height: 220,

                                      width: double.infinity,

                                      fit: BoxFit.cover,

                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Container(
                                          height: 220,

                                          color: Colors.grey.shade300,

                                          child: const Center(
                                            child: Icon(Icons.watch, size: 50),
                                          ),
                                        );
                                      },
                                    )
                                    : Image.asset(
                                      watch.image,

                                      height: 220,

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
                                watch.title,

                                style: const TextStyle(
                                  fontSize: 20,

                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                '\$${watch.price}',

                                style: const TextStyle(
                                  fontSize: 18,

                                  color: Colors.amber,

                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                watch.description,

                                maxLines: 2,

                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
