import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../theme/flat_nest_theme.dart';

class ListingShimmerCard extends StatelessWidget {
  final FlatNestTheme t;

  const ListingShimmerCard({super.key, required this.t});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE0E0E0);
    final highlight = isDark ? const Color(0xFF3D3D3D) : const Color(0xFFF5F5F5);

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Container(
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: t.borderSoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo skeleton
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(height: 160, width: double.infinity, color: base),
            ),
            // Info skeleton
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _Box(w: 160, h: 14, base: base),
                      _Box(w: 70, h: 14, base: base),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _Box(w: 100, h: 11, base: base),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _Box(w: 54, h: 12, base: base),
                      const SizedBox(width: 12),
                      _Box(w: 54, h: 12, base: base),
                      const SizedBox(width: 12),
                      _Box(w: 54, h: 12, base: base),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _Box(w: 80, h: 20, base: base, radius: 6),
                      const SizedBox(width: 6),
                      _Box(w: 70, h: 20, base: base, radius: 6),
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
}

class FeaturedShimmerCard extends StatelessWidget {
  final FlatNestTheme t;

  const FeaturedShimmerCard({super.key, required this.t});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE0E0E0);
    final highlight = isDark ? const Color(0xFF3D3D3D) : const Color(0xFFF5F5F5);

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Featured" header row
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Box(w: 80, h: 16, base: base),
                _Box(w: 40, h: 14, base: base),
              ],
            ),
          ),
          // Large card
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(height: 220, width: double.infinity, color: base),
          ),
          const SizedBox(height: 24),
          // "All Listings" header
          _Box(w: 110, h: 16, base: base),
        ],
      ),
    );
  }
}

class _Box extends StatelessWidget {
  final double w;
  final double h;
  final Color base;
  final double radius;

  const _Box({
    required this.w,
    required this.h,
    required this.base,
    this.radius = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
