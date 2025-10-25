import 'dart:developer';

import 'package:geolocator/geolocator.dart';

class PermissionsManager {
  Future<bool> checkLocationPermissions() async {
    log('Checking location permissions...');
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Serviço de localização desativado.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permissão de localização negada');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permissão de localização negada permanentemente');
    }
    log("Fine. Location permissions granted.");
    return true;
  }
}
