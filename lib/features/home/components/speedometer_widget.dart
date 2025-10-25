import 'package:flutter/material.dart';
import 'package:mapnavigatorapp/shared/providers/location_provider.dart';
import 'package:mapnavigatorapp/shared/visual/app_colors.dart';
import 'package:provider/provider.dart';

class SpeedometerWidget extends StatefulWidget {
  const SpeedometerWidget({super.key, this.size = 150.0});
  final double size;

  @override
  State<SpeedometerWidget> createState() => _SpeedometerWidgetState();
}

class _SpeedometerWidgetState extends State<SpeedometerWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, _) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4.0, offset: Offset(2, 2))],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: !locationProvider.isTracking
                ? [
                    Text(
                      '--',
                      style: TextStyle(fontSize: widget.size / 3.5, fontWeight: FontWeight.w900, color: kTextColor),
                    ),
                  ]
                : <Widget>[
                    Text(
                      locationProvider.speedKmhString(),
                      style: TextStyle(fontSize: widget.size / 3.5, fontWeight: FontWeight.w900, color: kTextColor),
                    ),
                    Text(
                      'km/h'.toUpperCase(),
                      style: TextStyle(fontSize: widget.size / 6, color: Colors.black54),
                    ),
                  ],
          ),
        );
      },
    );
  }
}
