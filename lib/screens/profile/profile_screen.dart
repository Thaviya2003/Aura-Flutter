import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../providers/battery_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/profile_image_provider.dart';
import '../../providers/connectivity_provider.dart';
import '../../providers/favorites_provider.dart';

import '../../screens/auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<BatteryProvider>().loadBatteryLevel();
      context.read<LocationProvider>().loadLocation();
      context.read<ProfileImageProvider>().loadSavedImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final batteryProvider = context.watch<BatteryProvider>();
    final locationProvider = context.watch<LocationProvider>();
    final imageProvider = context.watch<ProfileImageProvider>();
    final connectivityProvider = context.watch<ConnectivityProvider>();
    final favoritesProvider = context.watch<FavoritesProvider>();

    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundImage:
                  imageProvider.image != null
                      ? FileImage(imageProvider.image!)
                      : null,
              child:
                  imageProvider.image == null
                      ? const Icon(Icons.person, size: 50)
                      : null,
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    imageProvider.pickImageFromCamera();
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),

                const SizedBox(width: 15),

                ElevatedButton.icon(
                  onPressed: () {
                    imageProvider.pickImageFromGallery();
                  },
                  icon: const Icon(Icons.photo),
                  label: const Text('Gallery'),
                ),
              ],
            ),

            const SizedBox(height: 15),

            ElevatedButton.icon(
              onPressed: () {
                imageProvider.removeProfileImage();
              },
              icon: const Icon(Icons.delete),
              label: const Text('Remove Picture'),
            ),

            const SizedBox(height: 30),

            if (imageProvider.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  imageProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            Text(
              currentUser?.displayName ?? 'AURA User',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              currentUser?.email ?? 'No Email',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
            ),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: const Icon(Icons.battery_full),
                title: const Text('Battery Level'),
                subtitle: Text('${batteryProvider.batteryLevel}%'),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Current Location'),

                subtitle: Builder(
                  builder: (_) {
                    if (locationProvider.isLoading) {
                      return const Text('Getting location...');
                    }

                    if (locationProvider.errorMessage != null) {
                      return Text(locationProvider.errorMessage!);
                    }

                    if (locationProvider.position == null) {
                      return const Text('Location unavailable');
                    }

                    return Text(
                      'Lat: ${locationProvider.position!.latitude.toStringAsFixed(4)}\n'
                      'Lng: ${locationProvider.position!.longitude.toStringAsFixed(4)}',
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              child: ListTile(
                leading: Icon(
                  connectivityProvider.isOnline ? Icons.wifi : Icons.wifi_off,
                ),
                title: const Text('Internet Status'),
                subtitle: Text(
                  connectivityProvider.isOnline ? 'Connected' : 'Offline',
                ),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              child: ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Favorite Watches'),
                subtitle: Text('${favoritesProvider.favorites.length} Saved'),
              ),
            ),

            const SizedBox(height: 15),

            const Card(
              child: ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('App Version'),
                subtitle: Text('AURA v1.0.0'),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();

                  if (!context.mounted) return;

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
