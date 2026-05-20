// ── Chat Service — migrated from Realtime DB to Firestore ─────────────────
// Reason: Firebase Realtime Database requires databaseURL config that is
// not included in flutterfire auto-generated firebase_options.dart by default.
// Firestore is already working and supports real-time streams identically.

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _chatRef(String alertId) =>
      _db.collection('chats').doc(alertId).collection('messages');

  // ── Send message ──────────────────────────────────────────────────────────
  Future<void> sendMessage({
    required String alertId,
    required String senderId,
    required String senderName,
    String? senderPhotoURL,
    required String text,
  }) async {
    final ref = _chatRef(alertId).doc();
    final msg = MessageModel(
      messageId: ref.id,
      chatId: alertId,
      senderId: senderId,
      senderName: senderName,
      senderPhotoURL: senderPhotoURL,
      text: text.trim(),
      timestamp: DateTime.now(),
    );
    await ref.set(msg.toFirestoreMap());
  }

  // ── Stream messages (real-time) ───────────────────────────────────────────
  Stream<List<MessageModel>> messagesStream(String alertId) {
    return _chatRef(alertId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) =>
                MessageModel.fromFirestoreMap(doc.id, doc.data()))
            .toList());
  }

  // ── Mark messages as read ─────────────────────────────────────────────────
  Future<void> markRead(String alertId, String messageId) async {
    await _chatRef(alertId).doc(messageId).update({'isRead': true});
  }

  // ── Delete chat ───────────────────────────────────────────────────────────
  Future<void> deleteChat(String alertId) async {
    final batch = _db.batch();
    final messages = await _chatRef(alertId).get();
    for (final doc in messages.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
