import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:mapnavigatorapp/shared/utils/permissions_manager.dart';
import '../../models/location_data.dart';

class LocationProvider extends ChangeNotifier {
  final PermissionsManager _permissionsManager = GetIt.instance<PermissionsManager>();
  LocationData? _currentLocation;
  bool _isTracking = false;
  bool _hasPermission = false;

  String? _errorMessage;
  StreamSubscription<Position>? _positionStreamSubscription;
  final List<LocationData> _locationHistory = [];

  LocationData? get currentLocation => _currentLocation;
  bool get isTracking => _isTracking;
  bool get hasPermission => _hasPermission;
  String? get errorMessage => _errorMessage;
  List<LocationData> get locationHistory => List.unmodifiable(_locationHistory);

  double get speedKmh => (_currentLocation?.speed ?? 0) * 3.6;

  String speedKmhString() {
    return speedKmh.toStringAsFixed(1);
  }

  Future<void> initializeLocation() async {
    try {
      await _permissionsManager.checkLocationPermissions();
      _hasPermission = true;
      if (_hasPermission) {
        await _getCurrentLocation();
      }
    } catch (e) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
      log('Posição obtida: $position');
      _updateLocation(position);
    } catch (e) {
      _errorMessage = 'Erro ao obter localização: $e';
      notifyListeners();
    }
  }

  void _updateLocation(Position position) {
    _currentLocation = LocationData(latitude: position.latitude, longitude: position.longitude, altitude: position.altitude, speed: position.speed, accuracy: position.accuracy, timestamp: DateTime.now());

    _locationHistory.add(_currentLocation!);
    if (_locationHistory.length > 100) {
      _locationHistory.removeAt(0);
    }

    notifyListeners();
  }

  Future<void> startTracking() async {
    if (!_hasPermission) {
      await _permissionsManager.checkLocationPermissions();
      if (!_hasPermission) return;
    }

    if (_isTracking) return;

    _isTracking = true;
    print('Iniciando tracking de localização... $_isTracking');
    notifyListeners();

    const LocationSettings locationSettings = LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 1);

    _positionStreamSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      _updateLocation,
      onError: (error) {
        _errorMessage = 'Erro no tracking: $error';
        _isTracking = false;
        notifyListeners();
      },
    );
  }

  void stopTracking() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    _isTracking = false;
    notifyListeners();
  }

  void clearHistory() {
    _locationHistory.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }
}
