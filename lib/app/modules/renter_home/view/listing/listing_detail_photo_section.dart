import 'package:flutter/material.dart';
import '../../../../theme/flat_nest_theme.dart';
import '../../../listing/model/listing_model.dart';

class ListingDetailPhotoSection extends StatelessWidget {
  final FlatNestTheme t;
  final ListingModel listing;
  final int photoIndex;
  final ValueChanged<int> onPhotoChange;
  final bool saved;
  final bool isLoading;
  final VoidCallback onToggleSave;

  const ListingDetailPhotoSection({
    super.key,
    required this.t,
    required this.listing,
    required this.photoIndex,
    required this.onPhotoChange,
    required this.saved,
    this.isLoading = false,
    required this.onToggleSave,
  });

  @override
  Widget build(BuildContext context) {
    final photos = listing.photos;
    return SizedBox(
      height: 360,
      child: Stack(
        children: [
          // Main photo
          Positioned.fill(
            child: photos.isNotEmpty
                ? Image.network(
                    photos[photoIndex].url,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
          ),
          // Gradient
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.2),
                  ],
                  stops: const [0, 0.4, 1],
                ),
              ),
            ),
          ),
          // Top actions (share, heart)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 16,
            child: Row(
              children: [
                _CircleBtn(icon: Icons.share_outlined, onTap: () {}),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: isLoading ? null : onToggleSave,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.95),
                    ),
                    child: isLoading
                        ? Padding(
                            padding: const EdgeInsets.all(10),
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
                ),
              ],
            ),
          ),
          // Dot indicators + counter
          if (photos.length > 1) ...[
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(photos.length, (i) {
                  return GestureDetector(
                    onTap: () => onPhotoChange(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == photoIndex ? 22 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: i == photoIndex
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Positioned(
              bottom: 12,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${photoIndex + 1}/${photos.length}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: t.primarySoft,
      child: Center(
        child: Icon(
          Icons.home_work_rounded,
          size: 80,
          color: t.primary.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.95),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }
}
