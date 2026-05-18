import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/api_watch_model.dart';
import '../../providers/connectivity_provider.dart';
import '../../services/api_service.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
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
        title: const Text('Explore'),

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

                return Card(
                  margin: const EdgeInsets.only(bottom: 20),

                  child: ListTile(
                    leading:
                        watch.image.startsWith('http')
                            ? Image.network(
                              watch.image,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                            : Image.asset(
                              watch.image,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),

                    title: Text(watch.title),

                    subtitle: Text('\$${watch.price}'),
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
