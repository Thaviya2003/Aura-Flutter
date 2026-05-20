import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/battery_provider.dart';

import '../../providers/location_provider.dart';

import 'dart:io';

import '../../providers/profile_image_provider.dart';

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

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
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

            const SizedBox(height: 30),

            Card(
              child: ListTile(
                leading: const Icon(Icons.battery_full),
                title: const Text('Battery Level'),
                subtitle: Text('${batteryProvider.batteryLevel}%'),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text('Current Location'),
                subtitle: Text(
                  locationProvider.position == null
                      ? 'Loading...'
                      : locationProvider.position == null
                      ? 'Location unavailable'
                      : 'Lat: ${locationProvider.position!.latitude.toStringAsFixed(4)}\n'
                          'Lng: ${locationProvider.position!.longitude.toStringAsFixed(4)}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
