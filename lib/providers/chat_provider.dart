import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message_model.dart';
import '../services/chat_service.dart';

final chatServiceProvider = Provider<ChatService>((ref) => ChatService());

// FIX #4a: Usar ref.watch en lugar de ref.read dentro del StreamProvider.family
// para que el stream se re-suscriba correctamente cuando cambia el alertId.
final messagesProvider = StreamProvider.family<List<MessageModel>, String>(
  (ref, alertId) => ref.watch(chatServiceProvider).messagesStream(alertId),
);

// FIX #4b: Convertir ChatNotifier en .family para que cada chat (alertId)
// tenga su propio estado independiente. Antes todos compartían el mismo notifier
// lo que causaba que el estado de loading/error de un chat afectara a otro.
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
      rethrow; // FIX #4c: rethrow para que la UI pueda mostrar el error
    }
  }
}

// FIX #4b: .family por alertId
final chatNotifierProvider =
    StateNotifierProvider.family<ChatNotifier, AsyncValue<void>, String>(
  (ref, alertId) => ChatNotifier(ref.read(chatServiceProvider)),
);
