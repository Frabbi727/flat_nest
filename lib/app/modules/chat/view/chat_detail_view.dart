import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/flat_nest_theme.dart';
import '../controller/chat_controller.dart';

class ChatDetailView extends GetView<ChatController> {
  const ChatDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;
    final chat = controller.selectedChat.value;

    if (chat == null) {
      return Scaffold(
        backgroundColor: t.bg,
        body: Center(child: Text('No chat selected', style: TextStyle(color: t.ink))),
      );
    }

    return Scaffold(
      backgroundColor: t.bg,
      body: Column(
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
            child: Obx(() => ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.messages.length,
                  itemBuilder: (_, i) {
                    final msg = controller.messages[i];
                    final isMe = msg.senderId == controller.myUserId;
                    return _MessageBubble(t: t, text: msg.text, isMe: isMe, time: _formatTime(msg.createdAt));
                  },
                )),
          ),
          // Input bar
          Container(
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
          ),
        ],
      ),
    );
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
