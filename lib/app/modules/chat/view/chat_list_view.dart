import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/flat_nest_theme.dart';
import '../controller/chat_controller.dart';
import '../model/chat_model.dart';

class ChatListView extends GetView<ChatController> {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return Scaffold(
      backgroundColor: t.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back_ios_new, color: t.ink, size: 18),
                  ),
                  const SizedBox(width: 16),
                  Text('Messages', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: t.ink, letterSpacing: -0.3)),
                ],
              ),
            ),
            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: t.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: t.borderSoft),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    Icon(Icons.search, color: t.inkSoft, size: 18),
                    const SizedBox(width: 8),
                    Text('Search conversations', style: TextStyle(color: t.inkFaint, fontSize: 14)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Chat list
            Expanded(
              child: Obx(() => controller.isLoading
                  ? Center(child: CircularProgressIndicator(color: t.primary))
                  : controller.chats.isEmpty
                      ? _EmptyState(t: t)
                      : ListView.separated(
                          padding: const EdgeInsets.only(top: 8, bottom: 80),
                          itemCount: controller.chats.length,
                          separatorBuilder: (_, __) => Divider(color: t.borderSoft, height: 1),
                          itemBuilder: (_, i) {
                            final chat = controller.chats[i];
                            return ChatRow(
                              t: t,
                              chat: chat,
                              onTap: () => controller.openChat(chat),
                            );
                          },
                        )),
            ),
          ],
        ),
      ),

    );
  }
}

class ChatRow extends StatelessWidget {
  final FlatNestTheme t;
  final ChatModel chat;
  final VoidCallback onTap;

  const ChatRow({super.key, required this.t, required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(shape: BoxShape.circle, color: t.primarySoft),
              child: Center(
                child: Text(
                  chat.otherUser.initials,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: t.primary),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chat.otherUser.name,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: t.ink),
                      ),
                      Text(
                        _timeAgo(chat.updatedAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: chat.unreadCount > 0 ? t.primary : t.inkSoft,
                          fontWeight: chat.unreadCount > 0 ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '📍 ${chat.listing.title}',
                    style: TextStyle(fontSize: 11, color: t.inkSoft),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.lastMessage?.text ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            color: chat.unreadCount > 0 ? t.ink : t.inkMid,
                            fontWeight: chat.unreadCount > 0 ? FontWeight.w600 : FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (chat.status == ChatStatus.pending)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: t.primarySoft,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Pending',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: t.primary),
                          ),
                        )
                      else if (chat.unreadCount > 0)
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: t.primary),
                          child: Center(
                            child: Text(
                              '${chat.unreadCount}',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(String iso) {
    try {
      final dt = DateTime.parse(iso);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m';
      if (diff.inHours < 24) return '${diff.inHours}h';
      return '${diff.inDays}d';
    } catch (_) {
      return '';
    }
  }
}

class _EmptyState extends StatelessWidget {
  final FlatNestTheme t;
  const _EmptyState({required this.t});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: t.inkFaint),
          const SizedBox(height: 16),
          Text('No conversations yet', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: t.ink)),
          const SizedBox(height: 8),
          Text('Message an owner to get started.', style: TextStyle(fontSize: 13, color: t.inkMid)),
        ],
      ),
    );
  }
}
