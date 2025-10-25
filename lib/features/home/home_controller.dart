import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapnavigatorapp/shared/utils/permissions_manager.dart';

class HomeController with ChangeNotifier {
  GoogleMapController? _mapController;
  GoogleMapController? get mapController => _mapController;
  bool _isCollecting = false;
  bool get isCollecting => _isCollecting;

  final PermissionsManager _permissionsManager = GetIt.instance<PermissionsManager>();

  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};

  Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polylines;

  void start() {
    _permissionsManager.checkLocationPermissions();
  }

  void startDataCollection() {
    _isCollecting = true;
    log('Coleta de dados iniciada!');
    notifyListeners();
  }

  void stopDataCollection() {
    _isCollecting = false;
    log('Coleta de dados parada.');
    notifyListeners();
  }

  void initialize() {
    log('HomeController inicializado.');
    _permissionsManager.checkLocationPermissions();
  }
}
