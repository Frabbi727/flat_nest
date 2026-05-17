import 'package:flutter/material.dart';
import '../../../../theme/flat_nest_theme.dart';
import '../../../listing/model/listing_model.dart';

class FeaturedCard extends StatelessWidget {
  final FlatNestTheme t;
  final ListingModel listing;
  final bool saved;
  final bool isLoading;
  final VoidCallback onToggleSave;
  final VoidCallback onTap;

  const FeaturedCard({
    super.key,
    required this.t,
    required this.listing,
    required this.saved,
    this.isLoading = false,
    required this.onToggleSave,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: t.ink,
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                'See all',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: t.primary,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: t.primarySoft,
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Photo or placeholder
                if (listing.thumbnailUrl != null)
                  Positioned.fill(
                    child: Image.network(
                      listing.thumbnailUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    ),
                  )
                else
                  Positioned.fill(child: _placeholder()),
                // Gradient overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.55),
                        ],
                        stops: const [0.3, 1.0],
                      ),
                    ),
                  ),
                ),
                // Featured badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: t.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '⭐ Featured',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Heart button
                Positioned(
                  top: 8,
                  right: 8,
                  child: _HeartButton(
                    t: t,
                    saved: saved,
                    isLoading: isLoading,
                    onTap: onToggleSave,
                  ),
                ),
                // Info overlay
                Positioned(
                  bottom: 14,
                  left: 14,
                  right: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (listing.area != null)
                        Text(
                          listing.area!.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                            letterSpacing: 0.5,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        listing.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '🛏 ${listing.beds ?? '-'} BR · 🚿 ${listing.baths ?? '-'} Bath',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            '${listing.priceFormatted}/mo',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
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
        ),
        const SizedBox(height: 24),
        Text(
          'All Listings',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: t.ink,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _placeholder() {
    return Container(
      color: t.primarySoft,
      child: Center(
        child: Icon(
          Icons.home_work_rounded,
          size: 64,
          color: t.primary.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}

class _HeartButton extends StatelessWidget {
  final FlatNestTheme t;
  final bool saved;
  final bool isLoading;
  final VoidCallback onTap;

  const _HeartButton({
    required this.t,
    required this.saved,
    this.isLoading = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.9),
        ),
        child: isLoading
            ? Padding(
                padding: const EdgeInsets.all(9),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: t.inkSoft,
                ),
              )
            : Icon(
                saved ? Icons.favorite : Icons.favorite_border,
                color: saved ? t.secondary : t.inkSoft,
                size: 18,
              ),
      ),
    );
  }
}
