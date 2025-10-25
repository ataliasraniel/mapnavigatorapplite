import 'package:flutter/material.dart';
import 'package:mapnavigatorapp/shared/providers/sensor_provider.dart';
import 'package:mapnavigatorapp/shared/visual/app_colors.dart';
import 'package:provider/provider.dart';

class AccelerometerWidget extends StatefulWidget {
  const AccelerometerWidget({super.key, this.size = 150.0});
  final double size;

  @override
  State<AccelerometerWidget> createState() => _AccelerometerWidgetState();
}

class _AccelerometerWidgetState extends State<AccelerometerWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SensorProvider>(
      builder: (context, sensorProvider, _) {
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
            children: !sensorProvider.isMonitoring
                ? [
                    Text(
                      '--',
                      style: TextStyle(fontSize: widget.size / 3.5, fontWeight: FontWeight.w900, color: kTextColor),
                    ),
                  ]
                : <Widget>[
                    Text(
                      sensorProvider.userAccelerationMagnitudeToString,
                      style: TextStyle(fontSize: widget.size / 3.5, fontWeight: FontWeight.w900, color: kTextColor),
                    ),
                    Text(
                      'ms/²'.toUpperCase(),
                      style: TextStyle(fontSize: widget.size / 6, color: Colors.black54),
                    ),
                  ],
          ),
        );
      },
    );
  }
}
