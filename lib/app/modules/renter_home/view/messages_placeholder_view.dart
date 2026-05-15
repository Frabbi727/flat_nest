import 'package:flutter/material.dart';
import '../../../theme/flat_nest_theme.dart';

class MessagesPlaceholderView extends StatelessWidget {
  const MessagesPlaceholderView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;
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
            Text('Your conversations will appear here.', style: TextStyle(fontSize: 13, color: t.inkMid)),
          ],
        ),
      ),
    );
  }
}
