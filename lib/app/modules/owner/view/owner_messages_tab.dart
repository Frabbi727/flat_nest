part of 'owner_home_view.dart';

// ── Messages placeholder tab ──────────────────────────────────────────────────

class _MessagesPlaceholder extends StatelessWidget {
  final FlatNestTheme t;
  const _MessagesPlaceholder({required this.t});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: t.bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: t.inkFaint),
            const SizedBox(height: 16),
            Text('Messages', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: t.ink)),
            const SizedBox(height: 8),
            Text('Renter inquiries will appear here.', style: TextStyle(fontSize: 13, color: t.inkMid)),
          ],
        ),
      ),
    );
  }
}
