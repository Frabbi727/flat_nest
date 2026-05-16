import 'package:flutter/material.dart';
import '../../../theme/flat_nest_theme.dart';
import '../../listing/model/listing_model.dart';

class ListingCardWidget extends StatelessWidget {
  final FlatNestTheme t;
  final ListingModel listing;
  final bool saved;
  final bool isLoading;
  final VoidCallback onToggleSave;
  final VoidCallback onTap;

  const ListingCardWidget({
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: t.borderSoft),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: listing.thumbnailUrl != null
                        ? Image.network(
                            listing.thumbnailUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _placeholder(),
                          )
                        : _placeholder(),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: _TypeBadge(t: t, type: listing.type),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: isLoading ? null : onToggleSave,
                    child: Container(
                      width: 34,
                      height: 34,
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
                              size: 17,
                            ),
                    ),
                  ),
                ),
              ],
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          listing.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: t.ink,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        listing.priceFormatted,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: t.ink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (listing.area != null)
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 13, color: t.inkSoft),
                        const SizedBox(width: 3),
                        Text(
                          listing.area!,
                          style: TextStyle(fontSize: 12, color: t.inkMid),
                        ),
                      ],
                    ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _StatChip(icon: '🛏', value: '${listing.beds ?? '-'}', label: 'Bed'),
                      const SizedBox(width: 12),
                      _StatChip(icon: '🚿', value: '${listing.baths ?? '-'}', label: 'Bath'),
                      if (listing.size != null) ...[
                        const SizedBox(width: 12),
                        _StatChip(icon: '📐', value: '${listing.size}', label: 'ft²'),
                      ],
                    ],
                  ),
                  if (listing.amenities.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: listing.amenities.take(3).map((a) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: t.primarySoft,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '✓ ${a.label}',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: t.primaryInk,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: t.primarySoft,
      child: Center(
        child: Icon(
          Icons.home_work_rounded,
          size: 48,
          color: t.primary.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final FlatNestTheme t;
  final String type;

  const _TypeBadge({required this.t, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: t.primarySoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        type,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: t.primaryInk,
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 4),
        Text(
          '$value $label',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF5B5B62),
          ),
        ),
      ],
    );
  }
}
