part of 'owner_home_view.dart';

// ── Shared image placeholder ──────────────────────────────────────────────────

Widget _imgPlaceholder(FlatNestTheme t) => Container(
      color: t.primarySoft,
      child: Icon(Icons.home_work_rounded, color: t.primary.withValues(alpha: 0.4), size: 28),
    );

// ── Listing row card ──────────────────────────────────────────────────────────

class _ListingRow extends GetView<OwnerController> {
  final FlatNestTheme t;
  final OwnerListingModel listing;

  const _ListingRow({required this.t, required this.listing});

  Color get _statusColor {
    switch (listing.status) {
      case 'active': return t.success;
      case 'pending': return t.warning;
      case 'rejected': return t.error;
      case 'rented': return t.primary;
      default: return t.inkSoft;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasActions = listing.status == 'draft' ||
        listing.status == 'active' ||
        listing.status == 'rejected';

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.borderSoft),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: _statusColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainRow(),
                    const SizedBox(height: 8),
                    _buildTags(),
                    _buildAddress(),
                    _buildOwnerContact(),
                    _buildPendingBanner(),
                    _buildRejectionBanner(),
                    if (hasActions) ...[
                      const SizedBox(height: 10),
                      _buildActions(context),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainRow() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 64,
            height: 64,
            child: listing.thumbnailUrl != null
                ? Image.network(
                    listing.thumbnailUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imgPlaceholder(t),
                    loadingBuilder: (_, child, progress) =>
                        progress == null ? child : _imgPlaceholder(t),
                  )
                : _imgPlaceholder(t),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      listing.title,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: t.ink),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      listing.statusLabel,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _statusColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text('${listing.area ?? 'Unknown'} · ${listing.priceFormatted}/mo',
                  style: TextStyle(fontSize: 11, color: t.inkSoft)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.remove_red_eye_outlined, size: 12, color: t.inkSoft),
                  const SizedBox(width: 3),
                  Text('${listing.views}', style: TextStyle(fontSize: 11, color: t.inkMid)),
                  const SizedBox(width: 12),
                  Icon(Icons.chat_bubble_outline, size: 12, color: t.inkSoft),
                  const SizedBox(width: 3),
                  Text('${listing.inquiries}', style: TextStyle(fontSize: 11, color: t.inkMid)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        _SmallInfoTag(
          text: '📅 ${listing.availableFromFormatted}',
          bgColor: listing.isAvailableNow ? t.successSoft : t.bgAlt,
          textColor: listing.isAvailableNow ? t.success : t.inkMid,
        ),
        if (listing.floorNo != null)
          _SmallInfoTag(text: '🏢 Floor ${listing.floorNo}', bgColor: t.bgAlt, textColor: t.inkMid),
        if (listing.facing != null)
          _SmallInfoTag(text: '🧭 ${listing.facing!.label}', bgColor: t.bgAlt, textColor: t.inkMid),
      ],
    );
  }

  Widget _buildAddress() {
    if (listing.road == null && listing.houseName == null &&
        listing.block == null && listing.section == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined, size: 12, color: t.inkSoft),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              [
                if (listing.road != null) listing.road!,
                if (listing.houseName != null) listing.houseName!,
                if (listing.block != null) 'Block ${listing.block}',
                if (listing.section != null) 'Section ${listing.section}',
              ].join(', '),
              style: TextStyle(fontSize: 10, color: t.inkMid),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerContact() {
    if (listing.ownerName == null && listing.ownerPhone == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Icon(Icons.person_outline, size: 12, color: t.inkSoft),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              [
                if (listing.ownerName != null) listing.ownerName!,
                if (listing.ownerPhone != null) listing.ownerPhone!,
              ].join(' · '),
              style: TextStyle(fontSize: 10, color: t.inkMid),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (listing.preferredContact != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: t.primarySoft, borderRadius: BorderRadius.circular(10)),
              child: Text(
                _contactLabel(listing.preferredContact!),
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: t.primaryInk),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPendingBanner() {
    if (listing.status != 'pending') return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: t.warningSoft, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Icon(Icons.hourglass_top_rounded, size: 14, color: t.warning),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Your listing is under review. You\'ll be notified once it\'s approved.',
                style: TextStyle(fontSize: 11, color: t.warning, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRejectionBanner() {
    if (listing.status != 'rejected') return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: t.errorSoft,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: t.error.withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.cancel_outlined, size: 14, color: t.error),
                const SizedBox(width: 6),
                Text('Admin note:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: t.error)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              listing.rejectionReason ?? 'Your listing was rejected. Please fix the issues and resubmit.',
              style: TextStyle(fontSize: 12, color: t.error, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    switch (listing.status) {
      case 'draft':
        return _actionBtn(label: 'Continue', icon: Icons.arrow_forward_rounded, color: t.primary, onTap: () => controller.continueDraft(listing));
      case 'active':
        return Row(
          children: [
            _actionBtn(label: 'Edit', icon: Icons.edit_rounded, color: t.inkMid, onTap: () => _onEdit(context)),
            const SizedBox(width: 8),
            _actionBtn(label: 'Mark as Rented', icon: Icons.check_circle_outline, color: t.success, onTap: () => _onMarkRented(context)),
          ],
        );
      case 'rejected':
        return _actionBtn(label: 'Fix & Resubmit', icon: Icons.replay_rounded, color: t.error, onTap: () => controller.fixAndResubmit(listing));
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _actionBtn({required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 5),
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }

  String _contactLabel(String contact) => switch (contact) {
    'whatsapp' => 'WhatsApp',
    'both' => 'Call/WA',
    _ => 'Call',
  };

  Future<void> _onEdit(BuildContext context) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Save changes?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            content: const Text(
              'Saving changes will temporarily hide your listing until it\'s re-approved by admin. Continue?',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Continue'),
              ),
            ],
          ),
        ) ?? false;
    if (confirmed) controller.navigateToEdit(listing);
  }

  Future<void> _onMarkRented(BuildContext context) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Mark as Rented?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            content: const Text(
              'This will mark your listing as rented and remove it from public search. This action cannot be undone.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: t.success,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Mark as Rented'),
              ),
            ],
          ),
        ) ?? false;
    if (confirmed) controller.markRented(listing.id);
  }
}

// ── Small info tag ────────────────────────────────────────────────────────────

class _SmallInfoTag extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;

  const _SmallInfoTag({required this.text, required this.bgColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: textColor)),
    );
  }
}
