class SensorData {
  final double accelerometerX;
  final double accelerometerY;
  final double accelerometerZ;
  final double gyroscopeX;
  final double gyroscopeY;
  final double gyroscopeZ;
  final DateTime timestamp;

  SensorData({
    required this.accelerometerX,
    required this.accelerometerY,
    required this.accelerometerZ,
    required this.gyroscopeX,
    required this.gyroscopeY,
    required this.gyroscopeZ,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'SensorData(accel: ${accelerometerX.toStringAsFixed(2)}, ${accelerometerY.toStringAsFixed(2)}, ${accelerometerZ.toStringAsFixed(2)})';
  }
}
