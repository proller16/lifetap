import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message_model.dart';
import '../services/chat_service.dart';

final chatServiceProvider = Provider<ChatService>((ref) => ChatService());

// ── Messages stream for a specific alert/chat ─────────────────────────────
final messagesProvider = StreamProvider.family<List<MessageModel>, String>(
  (ref, alertId) => ref.read(chatServiceProvider).messagesStream(alertId),
);

// ── Send message action ────────────────────────────────────────────────────
class ChatNotifier extends StateNotifier<AsyncValue<void>> {
  final ChatService _service;

  ChatNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> send({
    required String alertId,
    required String senderId,
    required String senderName,
    String? senderPhotoURL,
    required String text,
  }) async {
    if (text.trim().isEmpty) return;
    state = const AsyncValue.loading();
    try {
      await _service.sendMessage(
        alertId: alertId,
        senderId: senderId,
        senderName: senderName,
        senderPhotoURL: senderPhotoURL,
        text: text,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final chatNotifierProvider =
    StateNotifierProvider<ChatNotifier, AsyncValue<void>>(
  (ref) => ChatNotifier(ref.read(chatServiceProvider)),
);
