import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

// FIX #3: El archivo original tenía _getAccelerometerEvents() que siempre
// retornaba Stream.empty() — nunca se leía el acelerómetro real.
// Ahora se importa sensors_plus directamente y se usa accelerometerEventStream().

class SensorService {
  static const double _fallThreshold = 25.0;
  static const Duration _cooldown = Duration(seconds: 30);

  StreamSubscription<AccelerometerEvent>? _sub;
  DateTime? _lastDetection;

  final _fallController = StreamController<void>.broadcast();
  Stream<void> get fallDetected => _fallController.stream;

  void startListening() {
    // Sensors not available on web
    if (kIsWeb) return;
    try {
      _sub = accelerometerEventStream(
        samplingPeriod: SensorInterval.normalInterval,
      ).listen(
        (AccelerometerEvent event) {
          final magnitude =
              sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
          if (magnitude > _fallThreshold) {
            final now = DateTime.now();
            if (_lastDetection == null ||
                now.difference(_lastDetection!) > _cooldown) {
              _lastDetection = now;
              _fallController.add(null);
            }
          }
        },
        onError: (_) {
          // Ignorar errores de sensor en plataformas no soportadas
        },
        cancelOnError: false,
      );
    } catch (_) {
      // Silently ignore on unsupported platforms
    }
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
