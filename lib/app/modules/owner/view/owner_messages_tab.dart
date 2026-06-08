part of 'owner_home_view.dart';

class _MessagesTab extends GetView<ChatController> {
  const _MessagesTab();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return Scaffold(
      backgroundColor: t.bg,
      body: Column(
        children: [
          // Top bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Row(
              children: [
                Text(
                  'Messages',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: t.ink,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
          ),
          // Chat list
          Expanded(
            child: Obx(() => controller.isLoading
                ? Center(child: CircularProgressIndicator(color: t.primary))
                : controller.chats.isEmpty
                    ? _EmptyMessages(t: t)
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
    );
  }
}

class _EmptyMessages extends StatelessWidget {
  final FlatNestTheme t;
  const _EmptyMessages({required this.t});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64, color: t.inkFaint),
          const SizedBox(height: 16),
          Text(
            'No inquiries yet',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: t.ink,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'When renters message you about your flats,\nthey will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: t.inkMid),
          ),
        ],
      ),
    );
  }
}
