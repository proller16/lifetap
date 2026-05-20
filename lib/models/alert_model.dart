import 'package:cloud_firestore/cloud_firestore.dart';

enum AlertType { slip, health, accident, other }
enum AlertStatus { pending, active, enRoute, attending, resolved }

class AlertModel {
  final String alertId;
  final String studentId;
  final String studentName;
  final String? studentPhotoURL;
  final String? studentBloodType;
  final AlertType type;
  final GeoPoint location;
  final DateTime timestamp;
  final AlertStatus status;
  final String? assignedBrigadistaId;
  final String? assignedBrigadistaName;
  final String? mediaURL;
  final String? notes;
  final DateTime? resolvedAt;

  const AlertModel({
    required this.alertId,
    required this.studentId,
    required this.studentName,
    this.studentPhotoURL,
    this.studentBloodType,
    required this.type,
    required this.location,
    required this.timestamp,
    required this.status,
    this.assignedBrigadistaId,
    this.assignedBrigadistaName,
    this.mediaURL,
    this.notes,
    this.resolvedAt,
  });

  factory AlertModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final loc = data['location'] as GeoPoint? ??
        const GeoPoint(32.5027, -117.0143); // ITT default coords
    return AlertModel(
      alertId: doc.id,
      studentId: data['studentId'] ?? '',
      studentName: data['studentName'] ?? '',
      studentPhotoURL: data['studentPhotoURL'],
      studentBloodType: data['studentBloodType'],
      type: _parseType(data['type']),
      location: loc,
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: _parseStatus(data['status']),
      assignedBrigadistaId: data['assignedBrigadistaId'],
      assignedBrigadistaName: data['assignedBrigadistaName'],
      mediaURL: data['mediaURL'],
      notes: data['notes'],
      resolvedAt: (data['resolvedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'studentId': studentId,
    'studentName': studentName,
    'studentPhotoURL': studentPhotoURL,
    'studentBloodType': studentBloodType,
    'type': type.name,
    'location': location,
    'timestamp': Timestamp.fromDate(timestamp),
    'status': status.name,
    'assignedBrigadistaId': assignedBrigadistaId,
    'assignedBrigadistaName': assignedBrigadistaName,
    'mediaURL': mediaURL,
    'notes': notes,
    'resolvedAt': resolvedAt != null ? Timestamp.fromDate(resolvedAt!) : null,
  };

  AlertModel copyWith({
    AlertStatus? status,
    String? assignedBrigadistaId,
    String? assignedBrigadistaName,
    String? mediaURL,
    DateTime? resolvedAt,
  }) {
    return AlertModel(
      alertId: alertId,
      studentId: studentId,
      studentName: studentName,
      studentPhotoURL: studentPhotoURL,
      studentBloodType: studentBloodType,
      type: type,
      location: location,
      timestamp: timestamp,
      status: status ?? this.status,
      assignedBrigadistaId: assignedBrigadistaId ?? this.assignedBrigadistaId,
      assignedBrigadistaName: assignedBrigadistaName ?? this.assignedBrigadistaName,
      mediaURL: mediaURL ?? this.mediaURL,
      notes: notes,
      resolvedAt: resolvedAt ?? this.resolvedAt,
    );
  }

  static AlertType _parseType(String? t) {
    switch (t) {
      case 'slip':     return AlertType.slip;
      case 'health':   return AlertType.health;
      case 'accident': return AlertType.accident;
      default:         return AlertType.other;
    }
  }

  static AlertStatus _parseStatus(String? s) {
    switch (s) {
      case 'active':    return AlertStatus.active;
      case 'enRoute':   return AlertStatus.enRoute;
      case 'attending': return AlertStatus.attending;
      case 'resolved':  return AlertStatus.resolved;
      default:          return AlertStatus.pending;
    }
  }

  String get typeKey {
    switch (type) {
      case AlertType.slip:     return 'typeSlip';
      case AlertType.health:   return 'typeHealth';
      case AlertType.accident: return 'typeAccident';
      case AlertType.other:    return 'typeOther';
    }
  }

  String get statusKey {
    switch (status) {
      case AlertStatus.pending:   return 'statusPending';
      case AlertStatus.active:    return 'statusActive';
      case AlertStatus.enRoute:   return 'statusEnRoute';
      case AlertStatus.attending: return 'statusAttending';
      case AlertStatus.resolved:  return 'statusResolved2';
    }
  }

  bool get isActive =>
      status == AlertStatus.pending ||
      status == AlertStatus.active ||
      status == AlertStatus.enRoute ||
      status == AlertStatus.attending;
}
