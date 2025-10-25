import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapnavigatorapp/features/home/components/accelerometer_widget.dart';
import 'package:mapnavigatorapp/features/home/components/compass_widget.dart';
import 'package:mapnavigatorapp/features/home/components/locator_permission_tracker_widget.dart';
import 'package:mapnavigatorapp/features/home/components/speedometer_widget.dart';
import 'package:mapnavigatorapp/features/home/components/start_data_colector_bottom_sheet.dart';
import 'package:mapnavigatorapp/shared/constants/constants.dart';
import 'package:mapnavigatorapp/shared/providers/location_provider.dart';
import 'package:mapnavigatorapp/shared/providers/sensor_provider.dart';
import 'package:mapnavigatorapp/shared/visual/app_colors.dart';
import 'package:mapnavigatorapp/shared/widgets/buttons/primary_button.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  StreamSubscription<Position>? _positionStreamSubscription;

  void _startLocationTracking() {}

  @override
  void initState() {
    super.initState();
    _startLocationTracking();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocationProvider, SensorProvider>(
      builder: (context, locationProvider, sensorProvider, _) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: (GoogleMapController mapController) {
                  _controller.complete(mapController);
                  _controller.future.then((controller) {
                    _positionStreamSubscription = Geolocator.getPositionStream(locationSettings: const LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 5)).listen((Position position) {
                      controller.animateCamera(CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));
                    });
                  });
                },
                initialCameraPosition: CameraPosition(target: locationProvider.currentLocation == null ? const LatLng(37.42796133580664, -122.085749655962) : LatLng(locationProvider.currentLocation!.latitude, locationProvider.currentLocation!.longitude), zoom: 16),
                polylines: locationProvider.locationHistory.length > 1 ? {Polyline(polylineId: const PolylineId('tracking_path'), points: locationProvider.locationHistory.map((location) => LatLng(location.latitude, location.longitude)).toList(), color: Colors.blue, width: 3)} : {},
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                compassEnabled: true,
                trafficEnabled: false,
              ),
              Padding(
                padding: const EdgeInsets.only(top: kDefaultPadding),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: LocatorPermissionTrackerWidget(width: MediaQuery.of(context).size.width * 0.6, height: 64),
                ),
              ),

              Positioned(
                left: 34,
                bottom: 94,
                child: Column(
                  children: [
                    CompassWidget(size: 64),
                    SizedBox(height: kSmallSize),
                    AccelerometerWidget(size: 64),
                    SizedBox(height: kSmallSize),
                    SpeedometerWidget(size: 84),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.all(kDefaultPadding),

                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: PrimaryButton(
                    text: locationProvider.isTracking ? 'Data está sendo Coletada' : 'Iniciar Coleta de Dados',
                    icon: locationProvider.isTracking ? Icons.data_array : Icons.play_arrow,
                    color: locationProvider.isTracking ? kCancelColor : null,
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (_) {
                          return StartDataColectorBottomSheet(isColecting: locationProvider.isTracking);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
