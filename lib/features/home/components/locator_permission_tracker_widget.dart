import 'package:flutter/material.dart';
import 'package:mapnavigatorapp/shared/providers/location_provider.dart';
import 'package:mapnavigatorapp/shared/visual/app_colors.dart';
import 'package:provider/provider.dart';

class LocatorPermissionTrackerWidget extends StatelessWidget {
  const LocatorPermissionTrackerWidget({super.key, required this.width, required this.height});
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, _) {
        return InkWell(
          onTap: () {
            if (!locationProvider.hasPermission) {
              locationProvider.initializeLocation();
            }
          },
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4.0, offset: Offset(2, 2))],
            ),
            child: Center(
              child: Text(
                locationProvider.hasPermission ? 'Permissão de localização concedida' : 'Permissão de localização negada',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: locationProvider.hasPermission ? kDetailColor : kCancelColor),
              ),
            ),
          ),
        );
      },
    );
  }
}
