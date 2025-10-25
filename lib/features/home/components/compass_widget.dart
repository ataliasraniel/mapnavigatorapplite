import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;

class CompassWidget extends StatelessWidget {
  const CompassWidget({super.key, required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Erro ao ler a bússola');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          double? direction = snapshot.data!.heading;

          if (direction == null) {
            return const Center(child: Text('Bússola não disponível.'));
          }

          final rotation = (direction * (math.pi / 180) * 1);

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Transform.rotate(
                angle: rotation,
                child: Icon(Icons.navigation, size: size * 0.67, color: Colors.red),
              ),
            ),
          );
        },
      ),
    );
  }
}
