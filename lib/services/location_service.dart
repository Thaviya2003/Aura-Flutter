import 'package:geolocator/geolocator.dart' as geolocator;

class LocationService {
  Future<geolocator.Position?> getCurrentLocation() async {
    bool serviceEnabled;
    geolocator.LocationPermission permission;

    serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return null;
    }

    permission = await geolocator.Geolocator.checkPermission();

    if (permission == geolocator.LocationPermission.denied) {
      permission = await geolocator.Geolocator.requestPermission();

      if (permission == geolocator.LocationPermission.denied) {
        return null;
      }
    }

    if (permission == geolocator.LocationPermission.deniedForever) {
      return null;
    }

    return await geolocator.Geolocator.getCurrentPosition(
      desiredAccuracy: geolocator.LocationAccuracy.high,
    );
  }
}