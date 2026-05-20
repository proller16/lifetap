import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/alert_model.dart';
import '../models/user_model.dart';

class AlertService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  CollectionReference<Map<String, dynamic>> get _alerts =>
      _db.collection('alerts');

  Future<AlertModel> createAlert({
    required UserModel student,
    required AlertType type,
    required double lat,
    required double lng,
    String? mediaURL,
    String? notes,
  }) async {
    final alertId = _uuid.v4();
    final now = DateTime.now();
    final model = AlertModel(
      alertId: alertId,
      studentId: student.uid,
      studentName: student.name,
      studentPhotoURL: student.photoURL,
      studentBloodType: student.bloodType,
      type: type,
      location: GeoPoint(lat, lng),
      timestamp: now,
      status: AlertStatus.pending,
      mediaURL: mediaURL,
      notes: notes,
    );
    await _alerts.doc(alertId).set(model.toFirestore());
    return model;
  }

  Future<void> acceptAlert({
    required String alertId,
    required UserModel brigadista,
  }) async {
    await _alerts.doc(alertId).update({
      'status': AlertStatus.active.name,
      'assignedBrigadistaId': brigadista.uid,
      'assignedBrigadistaName': brigadista.name,
    });
  }

  Future<void> updateStatus(String alertId, AlertStatus status) async {
    final Map<String, dynamic> update = {'status': status.name};
    if (status == AlertStatus.resolved) {
      update['resolvedAt'] = Timestamp.now();
    }
    await _alerts.doc(alertId).update(update);
  }

  // Simple orderBy + in-memory filter — avoids composite index requirement
  Stream<List<AlertModel>> activeAlertsStream() {
    return _alerts
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots()
        .map((snap) => snap.docs
            .map(AlertModel.fromFirestore)
            .where((a) => a.isActive)
            .toList());
  }

  Stream<AlertModel?> studentActiveAlertStream(String studentId) {
    return _alerts
        .where('studentId', isEqualTo: studentId)
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots()
        .map((snap) {
          if (snap.docs.isEmpty) return null;
          final active = snap.docs
              .map(AlertModel.fromFirestore)
              .where((a) => a.isActive)
              .toList();
          return active.isEmpty ? null : active.first;
        });
  }

  Stream<AlertModel?> alertStream(String alertId) {
    return _alerts.doc(alertId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return AlertModel.fromFirestore(doc);
    });
  }

  Stream<List<AlertModel>> allAlertsStream({
    AlertType? type,
    AlertStatus? status,
    DateTime? from,
    DateTime? to,
  }) {
    return _alerts
        .orderBy('timestamp', descending: true)
        .limit(200)
        .snapshots()
        .map((snap) {
      var list = snap.docs.map(AlertModel.fromFirestore).toList();
      if (type != null) list = list.where((a) => a.type == type).toList();
      if (status != null) list = list.where((a) => a.status == status).toList();
      if (from != null) list = list.where((a) => a.timestamp.isAfter(from)).toList();
      if (to != null) list = list.where((a) => a.timestamp.isBefore(to)).toList();
      return list;
    });
  }

  Future<Map<String, int>> fetchStats() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final allSnap = await _alerts.get();
    final all = allSnap.docs.map(AlertModel.fromFirestore).toList();
    return {
      'total': all.length,
      'active': all.where((a) => a.isActive).length,
      'resolvedToday': all
          .where((a) =>
              a.status == AlertStatus.resolved &&
              a.resolvedAt != null &&
              a.resolvedAt!.isAfter(todayStart))
          .length,
    };
  }

  Future<void> deleteAlert(String alertId) async {
    await _alerts.doc(alertId).delete();
  }
}
