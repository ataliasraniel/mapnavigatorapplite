import 'dart:async';
import 'dart:math';
import 'dart:developer' as log;
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../models/sensor_data.dart';

class SensorProvider extends ChangeNotifier {
  SensorData? _currentSensorData;
  bool _isMonitoring = false;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  StreamSubscription<MagnetometerEvent>? _magnetometerSubscription;
  StreamSubscription<UserAccelerometerEvent>? _userAccelerometerSubscription;
  Timer? _timer;
  int _elapsedSeconds = 0;
  int get elapsedSeconds => _elapsedSeconds;
  // A função _startCounting() deve estar aqui
  void _startCounting() {
    print("INICIANDO TIMER");
    // ... seu código do Timer.periodic
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // O setState só funciona aqui!
      // Boa prática: verifica se o widget ainda está na tela
      _elapsedSeconds++;
      print('Elapsed seconds: $_elapsedSeconds');
      notifyListeners();
    });
  }

  void _stopCounting() {
    _timer?.cancel();
    _timer = null;
  }

  double _accelerometerX = 0;
  double _accelerometerY = 0;
  double _accelerometerZ = 0;
  double _gyroscopeX = 0;
  double _gyroscopeY = 0;
  double _gyroscopeZ = 0;
  double _magnetometerX = 0;
  double _magnetometerY = 0;
  double _magnetometerZ = 0;
  double _userAccelX = 0;
  double _userAccelY = 0;
  double _userAccelZ = 0;

  SensorData? get currentSensorData => _currentSensorData;
  bool get isMonitoring => _isMonitoring;

  double get accelerometerX => _accelerometerX;
  double get accelerometerY => _accelerometerY;
  double get accelerometerZ => _accelerometerZ;
  double get gyroscopeX => _gyroscopeX;
  double get gyroscopeY => _gyroscopeY;
  double get gyroscopeZ => _gyroscopeZ;
  double get magnetometerX => _magnetometerX;
  double get magnetometerY => _magnetometerY;
  double get magnetometerZ => _magnetometerZ;

  String get userAccelerationMagnitudeToString =>
      sqrt(_userAccelX * _userAccelX + _userAccelY * _userAccelY + _userAccelZ * _userAccelZ).toStringAsFixed(2);

  void startMonitoring() {
    if (_isMonitoring) return;

    _isMonitoring = true;
    notifyListeners();

    _accelerometerSubscription = accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        _accelerometerX = event.x;
        _accelerometerY = event.y;
        _accelerometerZ = event.z;
        _updateSensorData();
      },
      onError: (error) {
        debugPrint('Erro no acelerômetro: $error');
      },
    );

    _userAccelerometerSubscription = userAccelerometerEventStream().listen(
      (UserAccelerometerEvent event) {
        _userAccelX = event.x;
        _userAccelY = event.y;
        _userAccelZ = event.z;
        notifyListeners();
      },
      onError: (error) {
        debugPrint('Erro na aceleração do usuário: $error');
      },
    );

    _gyroscopeSubscription = gyroscopeEventStream().listen(
      (GyroscopeEvent event) {
        _gyroscopeX = event.x;
        _gyroscopeY = event.y;
        _gyroscopeZ = event.z;
        _updateSensorData();
      },
      onError: (error) {
        debugPrint('Erro no giroscópio: $error');
      },
    );

    _magnetometerSubscription = magnetometerEventStream().listen(
      (MagnetometerEvent event) {
        _magnetometerX = event.x;
        _magnetometerY = event.y;
        _magnetometerZ = event.z;
        _updateSensorData();
      },
      onError: (error) {
        debugPrint('Erro no magnetômetro: $error');
      },
    );
    log.log("Alright. All sensors are being monitored.");
    _startCounting();
  }

  void _updateSensorData() {
    _currentSensorData = SensorData(
      accelerometerX: _accelerometerX,
      accelerometerY: _accelerometerY,
      accelerometerZ: _accelerometerZ,
      gyroscopeX: _gyroscopeX,
      gyroscopeY: _gyroscopeY,
      gyroscopeZ: _gyroscopeZ,
      timestamp: DateTime.now(),
    );
    notifyListeners();
  }

  void stopMonitoring() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _magnetometerSubscription?.cancel();
    _accelerometerSubscription = null;
    _gyroscopeSubscription = null;
    _magnetometerSubscription = null;
    _userAccelerometerSubscription?.cancel();
    _userAccelerometerSubscription = null;
    _isMonitoring = false;

    _stopCounting();
    notifyListeners();
  }

  @override
  void dispose() {
    stopMonitoring();
    super.dispose();
  }
}
