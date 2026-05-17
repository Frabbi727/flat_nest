import 'package:flutter/material.dart';
import '../../../../theme/flat_nest_theme.dart';

class DiscoveryTopBar extends StatelessWidget {
  final FlatNestTheme t;
  final String userName;
  final String locationLabel;

  const DiscoveryTopBar({
    super.key,
    required this.t,
    required this.userName,
    required this.locationLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, size: 18, color: t.inkSoft),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        locationLabel,
                        style: TextStyle(fontSize: 12, color: t.inkSoft),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Hello, $userName 👋',
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
          // Notification bell
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: t.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: t.borderSoft),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.notifications_outlined, color: t.ink, size: 20),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: t.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: t.primarySoft,
            ),
            child: Center(
              child: Text(
                'RK',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: t.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
