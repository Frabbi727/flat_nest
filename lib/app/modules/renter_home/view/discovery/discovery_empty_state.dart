import 'package:flutter/material.dart';
import '../../../../theme/flat_nest_theme.dart';

class DiscoveryEmptyState extends StatelessWidget {
  final FlatNestTheme t;

  const DiscoveryEmptyState({super.key, required this.t});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 64, color: t.inkFaint),
          const SizedBox(height: 16),
          Text(
            'No listings found',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: t.ink,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try changing your filters',
            style: TextStyle(fontSize: 13, color: t.inkMid),
          ),
        ],
      ),
    );
  }
}
