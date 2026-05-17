import 'package:flutter/material.dart';
import '../../../../theme/flat_nest_theme.dart';

class DiscoveryTypeChip extends StatelessWidget {
  final FlatNestTheme t;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const DiscoveryTypeChip({
    super.key,
    required this.t,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: active ? t.primary : t.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? t.primary : t.borderSoft),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : t.inkMid,
          ),
        ),
      ),
    );
  }
}
