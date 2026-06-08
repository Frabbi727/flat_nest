import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/service/auth_service.dart';
import '../../../theme/flat_nest_theme.dart';
import '../model/chat_model.dart';
import '../controller/chat_controller.dart';

class ChatDetailView extends GetView<ChatController> {
  const ChatDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return Scaffold(
      backgroundColor: t.bg,
      body: Obx(() {
        final chat = controller.selectedChat.value;
        if (chat == null) {
          return Center(child: Text('No chat selected', style: TextStyle(color: t.ink)));
        }

        return Column(
          children: [
            // Top bar
            Container(
              color: t.surface,
              padding: EdgeInsets.fromLTRB(8, MediaQuery.of(context).padding.top + 8, 12, 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.arrow_back_ios_new, color: t.ink, size: 18),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: t.primarySoft),
                    child: Center(
                      child: Text(
                        chat.otherUser.initials,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: t.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(chat.otherUser.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: t.ink)),
                        Text(chat.listing.title, style: TextStyle(fontSize: 11, color: t.inkSoft), overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  Icon(Icons.phone_outlined, color: t.ink, size: 20),
                ],
              ),
            ),
            Divider(color: t.borderSoft, height: 1),
            // Messages
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.messages.length,
                itemBuilder: (_, i) {
                  final msg = controller.messages[i];
                  final isMe = msg.senderId == controller.myUserId;
                  return _MessageBubble(t: t, text: msg.text, isMe: isMe, time: _formatTime(msg.createdAt));
                },
              ),
            ),
            // Status bar / Input bar
            _buildBottomBar(context, t, chat),
          ],
        );
      }),
    );
  }

  Widget _buildBottomBar(BuildContext context, FlatNestTheme t, ChatModel chat) {
    switch (chat.status) {
      case ChatStatus.accepted:
        return _InputBar(t: t, controller: controller);
      case ChatStatus.pending:
        final isOwner = Get.find<AuthService>().currentUser?.isOwner == true;
        if (isOwner) {
          return _OwnerActionsBar(t: t, controller: controller);
        } else {
          return _StatusBanner(
            t: t,
            icon: Icons.hourglass_empty_rounded,
            message: 'Waiting for the owner to accept your chat request.',
          );
        }
      case ChatStatus.rejected:
        return _StatusBanner(
          t: t,
          icon: Icons.block_flipped,
          message: 'This chat request was declined.',
          isError: true,
        );
      case ChatStatus.unknown:
        return const SizedBox.shrink();
    }
  }

  String _formatTime(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '$h:$m';
    } catch (_) {
      return '';
    }
  }
}

class _InputBar extends StatelessWidget {
  final FlatNestTheme t;
  final ChatController controller;

  const _InputBar({required this.t, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 8, 12, MediaQuery.of(context).padding.bottom + 8),
      decoration: BoxDecoration(
        color: t.surface,
        border: Border(top: BorderSide(color: t.borderSoft)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: t.bg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: t.borderSoft),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: controller.messageController,
                style: TextStyle(fontSize: 15, color: t.ink),
                decoration: InputDecoration(
                  hintText: 'Type a message…',
                  hintStyle: TextStyle(color: t.inkFaint),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: controller.sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(shape: BoxShape.circle, color: t.primary),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnerActionsBar extends StatelessWidget {
  final FlatNestTheme t;
  final ChatController controller;

  const _OwnerActionsBar({required this.t, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: t.surface,
        border: Border(top: BorderSide(color: t.borderSoft)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: controller.rejectRequest,
              style: OutlinedButton.styleFrom(
                foregroundColor: t.error,
                side: BorderSide(color: t.error.withValues(alpha: 0.4)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Reject', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: controller.acceptRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: t.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Accept Request', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final FlatNestTheme t;
  final IconData icon;
  final String message;
  final bool isError;

  const _StatusBanner({
    required this.t,
    required this.icon,
    required this.message,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isError ? t.error : t.primary;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        border: Border(top: BorderSide(color: color.withValues(alpha: 0.15))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isError ? t.error : t.inkMid,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final FlatNestTheme t;
  final String text;
  final bool isMe;
  final String time;

  const _MessageBubble({required this.t, required this.text, required this.isMe, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(shape: BoxShape.circle, color: t.primarySoft),
              child: Center(child: Icon(Icons.person, size: 16, color: t.primary)),
            ),
            const SizedBox(width: 8),
          ],
          Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isMe ? t.primary : t.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isMe ? 16 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 16),
                  ),
                  border: isMe ? null : Border.all(color: t.borderSoft),
                ),
                child: Text(
                  text,
                  style: TextStyle(fontSize: 14, color: isMe ? Colors.white : t.ink, height: 1.4),
                ),
              ),
              const SizedBox(height: 4),
              Text(time, style: TextStyle(fontSize: 10, color: t.inkSoft)),
            ],
          ),
          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }
}
