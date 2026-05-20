import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../models/alert_model.dart';
import '../../models/user_model.dart';
import '../../providers/alert_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/chat_bubble.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/status_badge.dart';

class EmergencyChatScreen extends ConsumerStatefulWidget {
  final String alertId;
  const EmergencyChatScreen({super.key, required this.alertId});

  @override
  ConsumerState<EmergencyChatScreen> createState() =>
      _EmergencyChatScreenState();
}

class _EmergencyChatScreenState extends ConsumerState<EmergencyChatScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    _msgCtrl.clear();

    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return;

    await ref.read(chatNotifierProvider.notifier).send(
          alertId: widget.alertId,
          senderId: user.uid,
          senderName: user.name,
          senderPhotoURL: user.photoURL,
          text: text,
        );
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final messagesAsync = ref.watch(messagesProvider(widget.alertId));
    final alertAsync = ref.watch(alertDetailProvider(widget.alertId));
    final userAsync = ref.watch(currentUserProvider);

    final user = userAsync.valueOrNull;
    final alert = alertAsync.valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.chatTitle),
        actions: const [LanguageToggle(), SizedBox(width: 8)],
        bottom: alert != null
            ? PreferredSize(
                preferredSize: const Size.fromHeight(52),
                child: _BrigadistaBar(alert: alert),
              )
            : null,
      ),
      body: Column(
        children: [
          // ── Messages list ─────────────────────────────────────────────
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.chat_bubble_outline_rounded,
                            size: 48, color: AppTheme.divider),
                        const SizedBox(height: 12),
                        Text(
                          'Ningún mensaje aún.\nUn brigadista se unirá pronto.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }
                _scrollToBottom();
                return ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    final msg = messages[i];
                    final isMe = msg.senderId == user?.uid;
                    return ChatBubble(
                      text: msg.text,
                      senderName: msg.senderName,
                      timestamp: msg.timestamp,
                      isMe: isMe,
                      photoURL: msg.senderPhotoURL,
                    );
                  },
                );
              },
            ),
          ),
          // ── Input bar ─────────────────────────────────────────────────
          _ChatInputBar(
            controller: _msgCtrl,
            onSend: _send,
            l: l,
          ),
        ],
      ),
    );
  }
}

class _BrigadistaBar extends StatelessWidget {
  final AlertModel alert;
  const _BrigadistaBar({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.navyDark,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white24,
            child: const Icon(Icons.shield_rounded,
                size: 18, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              alert.assignedBrigadistaName != null
                  ? 'Brigadista: ${alert.assignedBrigadistaName}'
                  : 'Esperando brigadista...',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          StatusBadge(status: alert.status),
        ],
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final AppLocalizations l;

  const _ChatInputBar({
    required this.controller,
    required this.onSend,
    required this.l,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppTheme.divider.withOpacity(0.5)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: l.chatPlaceholder,
                  filled: true,
                  fillColor: AppTheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                ),
                onSubmitted: (_) => onSend(),
                maxLines: null,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onSend,
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.navyDark,
                ),
                child: const Icon(Icons.send_rounded,
                    color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
