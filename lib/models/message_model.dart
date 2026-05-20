import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String messageId;
  final String chatId;
  final String senderId;
  final String senderName;
  final String? senderPhotoURL;
  final String text;
  final DateTime timestamp;
  final bool isRead;

  const MessageModel({
    required this.messageId,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    this.senderPhotoURL,
    required this.text,
    required this.timestamp,
    this.isRead = false,
  });

  // ── From Firestore ────────────────────────────────────────────────────────
  factory MessageModel.fromFirestoreMap(
      String id, Map<String, dynamic> data) {
    return MessageModel(
      messageId: id,
      chatId: data['chatId']?.toString() ?? '',
      senderId: data['senderId']?.toString() ?? '',
      senderName: data['senderName']?.toString() ?? '',
      senderPhotoURL: data['senderPhotoURL']?.toString(),
      text: data['text']?.toString() ?? '',
      timestamp: data['timestamp'] != null
          ? (data['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
      isRead: data['isRead'] as bool? ?? false,
    );
  }

  // ── Legacy Realtime DB format (kept for compatibility) ────────────────────
  factory MessageModel.fromMap(String id, Map<dynamic, dynamic> data) {
    return MessageModel(
      messageId: id,
      chatId: data['chatId']?.toString() ?? '',
      senderId: data['senderId']?.toString() ?? '',
      senderName: data['senderName']?.toString() ?? '',
      senderPhotoURL: data['senderPhotoURL']?.toString(),
      text: data['text']?.toString() ?? '',
      timestamp: data['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['timestamp'] as int)
          : DateTime.now(),
      isRead: data['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestoreMap() => {
    'chatId': chatId,
    'senderId': senderId,
    'senderName': senderName,
    'senderPhotoURL': senderPhotoURL,
    'text': text,
    'timestamp': Timestamp.fromDate(timestamp),
    'isRead': isRead,
  };

  // Legacy
  Map<String, dynamic> toMap() => {
    'chatId': chatId,
    'senderId': senderId,
    'senderName': senderName,
    'senderPhotoURL': senderPhotoURL,
    'text': text,
    'timestamp': timestamp.millisecondsSinceEpoch,
    'isRead': isRead,
  };
}
