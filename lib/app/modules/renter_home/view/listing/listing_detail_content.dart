import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../theme/flat_nest_theme.dart';
import '../../../../route/app_routes.dart';
import '../../../listing/model/listing_model.dart';

class ListingDetailContent extends StatelessWidget {
  final FlatNestTheme t;
  final ListingModel listing;

  const ListingDetailContent({
    super.key,
    required this.t,
    required this.listing,
  });

  String _displayName() {
    if (listing.ownerName != null && listing.ownerName!.isNotEmpty) {
      return listing.ownerName!;
    }
    return listing.owner?.name ?? 'Owner';
  }

  String _initials() {
    final name = _displayName();
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TitleRow(t: t, listing: listing),
          const SizedBox(height: 20),
          _StatStrip(t: t, listing: listing),
          const SizedBox(height: 16),
          _AvailabilityTags(t: t, listing: listing),
          if (listing.description != null) ...[
            const SizedBox(height: 24),
            _SectionTitle(t: t, text: 'About this flat'),
            const SizedBox(height: 8),
            Text(
              listing.description!,
              style: TextStyle(fontSize: 13, color: t.inkMid, height: 1.55),
            ),
          ],
          if (listing.amenities.isNotEmpty) ...[
            const SizedBox(height: 24),
            _SectionTitle(t: t, text: 'Amenities'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: listing.amenities
                  .map((a) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: t.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: t.borderSoft),
                        ),
                        child: Text(
                          '✓ ${a.label}',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: t.ink),
                        ),
                      ))
                  .toList(),
            ),
          ],
          if (listing.road != null ||
              listing.houseName != null ||
              listing.block != null ||
              listing.section != null) ...[
            const SizedBox(height: 24),
            _SectionTitle(t: t, text: 'Address Details'),
            const SizedBox(height: 8),
            _AddressCard(t: t, listing: listing),
          ],
          if (listing.owner != null ||
              listing.ownerName != null ||
              listing.ownerPhone != null) ...[
            const SizedBox(height: 24),
            _OwnerCard(
              t: t,
              listing: listing,
              displayName: _displayName(),
              initials: _initials(),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Section pieces ────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final FlatNestTheme t;
  final String text;

  const _SectionTitle({required this.t, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: t.ink,
          letterSpacing: -0.2),
    );
  }
}

class _TitleRow extends StatelessWidget {
  final FlatNestTheme t;
  final ListingModel listing;

  const _TitleRow({required this.t, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: t.primarySoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  listing.type,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: t.primaryInk),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                listing.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: t.ink,
                  letterSpacing: -0.4,
                  height: 1.25,
                ),
              ),
              if (listing.area != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: t.inkMid),
                    const SizedBox(width: 3),
                    Text(listing.area!,
                        style: TextStyle(fontSize: 13, color: t.inkMid)),
                  ],
                ),
              ],
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              listing.priceFormatted,
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w700, color: t.ink),
            ),
            Text('per month',
                style: TextStyle(fontSize: 11, color: t.inkSoft)),
          ],
        ),
      ],
    );
  }
}

class _StatStrip extends StatelessWidget {
  final FlatNestTheme t;
  final ListingModel listing;

  const _StatStrip({required this.t, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.borderSoft),
      ),
      child: Row(
        children: [
          _Stat(icon: '🛏', value: '${listing.beds ?? '-'}', label: 'Bed'),
          _StatDivider(t: t),
          _Stat(icon: '🚿', value: '${listing.baths ?? '-'}', label: 'Bath'),
          _StatDivider(t: t),
          _Stat(
              icon: '📐',
              value: listing.size != null ? '${listing.size}' : '-',
              label: 'ft²'),
          if (listing.deposit != null) ...[
            _StatDivider(t: t),
            _Stat(
                icon: '💰',
                value: listing.depositFormatted,
                label: 'Deposit'),
          ],
        ],
      ),
    );
  }
}

class _AvailabilityTags extends StatelessWidget {
  final FlatNestTheme t;
  final ListingModel listing;

  const _AvailabilityTags({required this.t, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _DetailTag(
          text: '📅 ${listing.availableFromFormatted}',
          color: listing.isAvailableNow ? t.successSoft : t.bgAlt,
          textColor: listing.isAvailableNow ? t.success : t.inkMid,
        ),
        if (listing.floorNo != null)
          _DetailTag(
              text: '🏢 Floor ${listing.floorNo}',
              color: t.bgAlt,
              textColor: t.inkMid),
        if (listing.facing != null)
          _DetailTag(
              text: '🧭 ${listing.facing!.label}',
              color: t.bgAlt,
              textColor: t.inkMid),
      ],
    );
  }
}

class _AddressCard extends StatelessWidget {
  final FlatNestTheme t;
  final ListingModel listing;

  const _AddressCard({required this.t, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.borderSoft),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined, size: 16, color: t.inkMid),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              [
                if (listing.road != null) listing.road!,
                if (listing.houseName != null) listing.houseName!,
                if (listing.block != null) 'Block ${listing.block}',
                if (listing.section != null) 'Section ${listing.section}',
              ].join(', '),
              style: TextStyle(fontSize: 13, color: t.inkMid, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnerCard extends StatelessWidget {
  final FlatNestTheme t;
  final ListingModel listing;
  final String displayName;
  final String initials;

  const _OwnerCard({
    required this.t,
    required this.listing,
    required this.displayName,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: t.primarySoft),
                child: Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: t.primary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(displayName,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: t.ink)),
                    if (listing.ownerPhone != null)
                      Text(listing.ownerPhone!,
                          style:
                              TextStyle(fontSize: 12, color: t.inkSoft)),
                    if (listing.ownerAltPhone != null)
                      Text(listing.ownerAltPhone!,
                          style:
                              TextStyle(fontSize: 12, color: t.inkSoft)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => Get.toNamed(Routes.chatList),
                style: ElevatedButton.styleFrom(
                  backgroundColor: t.primarySoft,
                  foregroundColor: t.primaryInk,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Message',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13)),
              ),
            ],
          ),
          if (listing.preferredContact != null) ...[
            const SizedBox(height: 10),
            _PreferredContactBadge(
                t: t, contact: listing.preferredContact!),
          ],
        ],
      ),
    );
  }
}

// ── Small reusable widgets ────────────────────────────────────────────────────

class _DetailTag extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const _DetailTag(
      {required this.text,
      required this.color,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(text,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor)),
    );
  }
}

class _PreferredContactBadge extends StatelessWidget {
  final FlatNestTheme t;
  final String contact;

  const _PreferredContactBadge(
      {required this.t, required this.contact});

  @override
  Widget build(BuildContext context) {
    final label = switch (contact) {
      'whatsapp' => '💬 Prefers WhatsApp',
      'both' => '📞💬 Call or WhatsApp',
      _ => '📞 Prefers Call',
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: t.primarySoft,
          borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: t.primaryInk)),
    );
  }
}

class _Stat extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const _Stat(
      {required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1C1C1E))),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFF8A8A8E))),
          ],
        ),
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  final FlatNestTheme t;
  const _StatDivider({required this.t});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: VerticalDivider(color: t.borderSoft, width: 1),
    );
  }
}
