import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/alert_model.dart';
import '../models/user_model.dart';
import '../services/alert_service.dart';
import '../services/location_service.dart';

final alertServiceProvider = Provider<AlertService>((ref) => AlertService());
final locationServiceProvider = Provider<LocationService>(
  (ref) => LocationService(),
);

// ── Active alerts stream (brigadista dashboard) ───────────────────────────
final activeAlertsProvider = StreamProvider<List<AlertModel>>((ref) {
  return ref.read(alertServiceProvider).activeAlertsStream();
});

// ── Student's active alert ────────────────────────────────────────────────
final studentAlertProvider = StreamProvider.family<AlertModel?, String>(
  (ref, studentId) =>
      ref.read(alertServiceProvider).studentActiveAlertStream(studentId),
);

// ── Single alert stream ───────────────────────────────────────────────────
final alertDetailProvider = StreamProvider.family<AlertModel?, String>(
  (ref, alertId) => ref.read(alertServiceProvider).alertStream(alertId),
);

// ── Admin: all alerts with filters ───────────────────────────────────────
final allAlertsProvider = StreamProvider.family<List<AlertModel>, AlertFilter>(
  (ref, filter) => ref.read(alertServiceProvider).allAlertsStream(
    type: filter.type,
    status: filter.status,
    from: filter.from,
    to: filter.to,
  ),
);

// ── Admin stats ───────────────────────────────────────────────────────────
final adminStatsProvider = FutureProvider<Map<String, int>>((ref) {
  return ref.read(alertServiceProvider).fetchStats();
});

// ── Alert Actions Notifier ────────────────────────────────────────────────
class AlertNotifier extends StateNotifier<AsyncValue<AlertModel?>> {
  final AlertService _alertService;
  final LocationService _locationService;

  AlertNotifier(this._alertService, this._locationService)
      : super(const AsyncValue.data(null));

  // Panic button — create alert
  Future<AlertModel> sendPanicAlert({
    required UserModel student,
    AlertType type = AlertType.other,
    String? mediaURL,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      final position = await _locationService.getCurrentPosition();
      final lat = position?.latitude ?? 32.5027;  // ITT campus fallback
      final lng = position?.longitude ?? -117.0143;
      final alert = await _alertService.createAlert(
        student: student,
        type: type,
        lat: lat,
        lng: lng,
        mediaURL: mediaURL,
        notes: notes,
      );
      state = AsyncValue.data(alert);
      return alert;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  // Brigadista accepts
  Future<void> acceptAlert(String alertId, UserModel brigadista) async {
    await _alertService.acceptAlert(alertId: alertId, brigadista: brigadista);
  }

  // Update status
  Future<void> updateStatus(String alertId, AlertStatus status) async {
    await _alertService.updateStatus(alertId, status);
  }

  void reset() => state = const AsyncValue.data(null);
}

final alertNotifierProvider =
    StateNotifierProvider<AlertNotifier, AsyncValue<AlertModel?>>(
  (ref) => AlertNotifier(
    ref.read(alertServiceProvider),
    ref.read(locationServiceProvider),
  ),
);

// ── Alert filter data class ───────────────────────────────────────────────
class AlertFilter {
  final AlertType? type;
  final AlertStatus? status;
  final DateTime? from;
  final DateTime? to;

  const AlertFilter({this.type, this.status, this.from, this.to});

  AlertFilter copyWith({
    AlertType? type,
    AlertStatus? status,
    DateTime? from,
    DateTime? to,
    bool clearType = false,
    bool clearStatus = false,
    bool clearFrom = false,
    bool clearTo = false,
  }) {
    return AlertFilter(
      type: clearType ? null : (type ?? this.type),
      status: clearStatus ? null : (status ?? this.status),
      from: clearFrom ? null : (from ?? this.from),
      to: clearTo ? null : (to ?? this.to),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AlertFilter &&
      other.type == type &&
      other.status == status &&
      other.from == from &&
      other.to == to;

  @override
  int get hashCode => Object.hash(type, status, from, to);
}

final alertFilterProvider = StateProvider<AlertFilter>(
  (ref) => const AlertFilter(),
);
