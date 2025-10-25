class LocationData {
  final double latitude;
  final double longitude;
  final double altitude;
  final double speed;
  final double accuracy;
  final DateTime timestamp;

  LocationData({required this.latitude, required this.longitude, required this.altitude, required this.speed, required this.accuracy, required this.timestamp});

  @override
  String toString() {
    return 'LocationData(lat: $latitude, lng: $longitude, speed: ${speed.toStringAsFixed(1)} m/s)';
  }
}
