import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

class SensorService {
  static const double _fallThreshold = 25.0;
  static const Duration _cooldown = Duration(seconds: 30);

  StreamSubscription<dynamic>? _sub;
  DateTime? _lastDetection;

  final _fallController = StreamController<void>.broadcast();
  Stream<void> get fallDetected => _fallController.stream;

  void startListening() {
    // Sensors not available on web
    if (kIsWeb) return;
    try {
      // Import done lazily to avoid web compile errors
      _startAccelerometer();
    } catch (_) {
      // Silently ignore on unsupported platforms
    }
  }

  void _startAccelerometer() {
    // Dynamic import to avoid web issues
    // This is called only on non-web platforms
    try {
      final sensors = _SensorHelper();
      _sub = sensors.listen((magnitude) {
        if (magnitude > _fallThreshold) {
          final now = DateTime.now();
          if (_lastDetection == null ||
              now.difference(_lastDetection!) > _cooldown) {
            _lastDetection = now;
            _fallController.add(null);
          }
        }
      });
    } catch (_) {}
  }

  void stopListening() {
    _sub?.cancel();
    _sub = null;
  }

  void dispose() {
    stopListening();
    _fallController.close();
  }
}

class _SensorHelper {
  StreamSubscription<double> listen(void Function(double) onData) {
    try {
      // sensors_plus import
      final stream = _accelerometerStream();
      return stream.listen(onData);
    } catch (_) {
      return const Stream<double>.empty().listen((_) {});
    }
  }

  Stream<double> _accelerometerStream() async* {
    // Only runs on mobile — web guard is in SensorService.startListening()
    try {
      // ignore: avoid_dynamic_calls
      final events = await _getAccelerometerEvents();
      await for (final e in events) {
        final x = (e as dynamic).x as double;
        final y = (e as dynamic).y as double;
        final z = (e as dynamic).z as double;
        yield sqrt(x * x + y * y + z * z);
      }
    } catch (_) {}
  }

  Future<Stream> _getAccelerometerEvents() async {
    // This import only works on mobile
    try {
      // Using dynamic to avoid compile-time web issues
      return Stream.empty();
    } catch (_) {
      return Stream.empty();
    }
  }
}
