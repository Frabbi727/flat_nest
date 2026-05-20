import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:url_launcher/url_launcher.dart';
import '../../../../theme/flat_nest_theme.dart';
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

  bool get _hasAddress =>
      listing.road != null ||
      listing.houseName != null ||
      listing.block != null ||
      listing.section != null;

  bool get _hasLocation =>
      (listing.lat != null && listing.lng != null) || _hasAddress;

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
          const SizedBox(height: 20),
          _AvailabilityTags(t: t, listing: listing),

          // Description
          if (listing.description != null) ...[
            const SizedBox(height: 28),
            _SectionDivider(t: t),
            const SizedBox(height: 24),
            _SectionTitle(t: t, text: 'About this flat'),
            const SizedBox(height: 10),
            _ExpandableText(t: t, text: listing.description!),
          ],

          // Amenities with icons
          if (listing.amenities.isNotEmpty) ...[
            const SizedBox(height: 28),
            _SectionDivider(t: t),
            const SizedBox(height: 24),
            _SectionTitle(t: t, text: 'Amenities'),
            const SizedBox(height: 12),
            _AmenitiesGrid(t: t, amenities: listing.amenities),
          ],

          // Location — map + address merged
          if (_hasLocation) ...[
            const SizedBox(height: 28),
            _SectionDivider(t: t),
            const SizedBox(height: 24),
            _SectionTitle(t: t, text: 'Location'),
            const SizedBox(height: 12),
            _LocationSection(t: t, listing: listing),
          ],

          // Owner card
          if (listing.owner != null ||
              listing.ownerName != null ||
              listing.ownerPhone != null) ...[
            const SizedBox(height: 28),
            _SectionDivider(t: t),
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

// ── Section helpers ───────────────────────────────────────────────────────────

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
        letterSpacing: -0.2,
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  final FlatNestTheme t;
  const _SectionDivider({required this.t});

  @override
  Widget build(BuildContext context) {
    return Divider(color: t.borderSoft, height: 1, thickness: 1);
  }
}

// ── Title / price ─────────────────────────────────────────────────────────────

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
                    color: t.primaryInk,
                  ),
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
                    Text(
                      listing.area!,
                      style: TextStyle(fontSize: 13, color: t.inkMid),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              listing.priceFormatted,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: t.ink,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'per month',
              style: TextStyle(fontSize: 11, color: t.inkSoft),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Stat strip ────────────────────────────────────────────────────────────────

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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
            label: 'ft²',
          ),
          if (listing.deposit != null) ...[
            _StatDivider(t: t),
            _Stat(
              icon: '💰',
              value: listing.depositFormatted,
              label: 'Deposit',
            ),
          ],
        ],
      ),
    );
  }
}

// ── Availability tags ─────────────────────────────────────────────────────────

class _AvailabilityTags extends StatelessWidget {
  final FlatNestTheme t;
  final ListingModel listing;

  const _AvailabilityTags({required this.t, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _TitledTag(
          t: t,
          icon: '📅',
          label: 'Available From',
          value: listing.availableFromFormatted,
          color: listing.isAvailableNow ? t.successSoft : t.bgAlt,
          labelColor: listing.isAvailableNow ? t.success.withValues(alpha: 0.75) : t.inkSoft,
          valueColor: listing.isAvailableNow ? t.success : t.inkMid,
        ),
        if (listing.floorNo != null)
          _TitledTag(
            t: t,
            icon: '🏢',
            label: 'Floor',
            value: '${listing.floorNo}',
            color: t.bgAlt,
            labelColor: t.inkSoft,
            valueColor: t.inkMid,
          ),
        if (listing.facing != null)
          _TitledTag(
            t: t,
            icon: '🧭',
            label: 'Facing',
            value: listing.facing!.label,
            color: t.bgAlt,
            labelColor: t.inkSoft,
            valueColor: t.inkMid,
          ),
        if (listing.distanceKm != null)
          _TitledTag(
            t: t,
            icon: '📍',
            label: 'Distance',
            value: '${listing.distanceKm!.toStringAsFixed(1)} km away',
            color: t.primarySoft,
            labelColor: t.primaryInk.withValues(alpha: 0.65),
            valueColor: t.primaryInk,
          ),
      ],
    );
  }
}

// ── Expandable description ────────────────────────────────────────────────────

class _ExpandableText extends StatefulWidget {
  final FlatNestTheme t;
  final String text;

  const _ExpandableText({required this.t, required this.text});

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool _expanded = false;
  static const _collapseAt = 180;

  @override
  Widget build(BuildContext context) {
    final needsToggle = widget.text.length > _collapseAt;
    final display = needsToggle && !_expanded
        ? '${widget.text.substring(0, _collapseAt).trimRight()}…'
        : widget.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          display,
          style:
              TextStyle(fontSize: 13, color: widget.t.inkMid, height: 1.6),
        ),
        if (needsToggle) ...[
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Text(
              _expanded ? 'Show less' : 'Read more',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: widget.t.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ── Amenities grid with icons ─────────────────────────────────────────────────

class _AmenitiesGrid extends StatelessWidget {
  final FlatNestTheme t;
  final List<AmenityModel> amenities;

  const _AmenitiesGrid({required this.t, required this.amenities});

  IconData _icon(String name) {
    final n = name.toLowerCase();
    if (n.contains('wifi') || n.contains('internet')) return Icons.wifi;
    if (n.contains('park')) return Icons.local_parking;
    if (n.contains('lift') || n.contains('elevator')) return Icons.elevator;
    if (n.contains('gas')) return Icons.local_fire_department;
    if (n.contains('water')) return Icons.water_drop;
    if (n.contains('secur') || n.contains('guard')) return Icons.security;
    if (n.contains('gym') || n.contains('fitness')) return Icons.fitness_center;
    if (n.contains('power') || n.contains('generator') || n.contains('backup')) {
      return Icons.bolt;
    }
    if (n.contains('cctv') || n.contains('camera')) return Icons.videocam;
    if (n.contains('ac') || n.contains('air') || n.contains('cool')) {
      return Icons.ac_unit;
    }
    if (n.contains('balcony')) return Icons.balcony;
    if (n.contains('roof')) return Icons.roofing;
    if (n.contains('garden') || n.contains('yard')) return Icons.yard;
    if (n.contains('pool') || n.contains('swim')) return Icons.pool;
    if (n.contains('laundry') || n.contains('wash')) return Icons.local_laundry_service;
    if (n.contains('kitchen')) return Icons.kitchen;
    return Icons.check_circle_outline;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: amenities
          .map(
            (a) => Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: t.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: t.borderSoft),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_icon(a.name), size: 15, color: t.primary),
                  const SizedBox(width: 7),
                  Text(
                    a.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: t.ink,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

// ── Location section (map + address) ─────────────────────────────────────────

class _LocationSection extends StatelessWidget {
  final FlatNestTheme t;
  final ListingModel listing;

  const _LocationSection({required this.t, required this.listing});

  bool get _hasMap => listing.lat != null && listing.lng != null;

  bool get _hasAddress =>
      listing.road != null ||
      listing.houseName != null ||
      listing.block != null ||
      listing.section != null;

  String get _addressLine => [
        if (listing.road != null) listing.road!,
        if (listing.houseName != null) listing.houseName!,
        if (listing.block != null) 'Block ${listing.block}',
        if (listing.section != null) 'Section ${listing.section}',
      ].join(', ');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_hasMap) _MapCard(t: t, lat: listing.lat!, lng: listing.lng!),
        if (_hasAddress) ...[
          if (_hasMap) const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: t.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: t.borderSoft),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: t.primarySoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.location_on_outlined,
                      size: 16, color: t.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _addressLine,
                    style: TextStyle(
                      fontSize: 13,
                      color: t.inkMid,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _MapCard extends StatelessWidget {
  final FlatNestTheme t;
  final double lat;
  final double lng;

  const _MapCard({required this.t, required this.lat, required this.lng});

  Future<void> _openDirections() async {
    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final point = ll.LatLng(lat, lng);

    return GestureDetector(
      onTap: _openDirections,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 210,
          child: Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: point,
                  initialZoom: 16,
                  interactionOptions:
                      const InteractionOptions(flags: InteractiveFlag.none),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.flatnest.app',
                    maxZoom: 19,
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: point,
                        width: 50,
                        height: 58,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: t.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: t.primary.withValues(alpha: 0.45),
                                    blurRadius: 14,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.home_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            CustomPaint(
                              size: const Size(14, 9),
                              painter: _PinTip(color: t.primary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SimpleAttributionWidget(
                    source: Text('© OpenStreetMap contributors'),
                    alignment: Alignment.bottomLeft,
                  ),
                ],
              ),
              // Directions badge overlay
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 13, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.directions_rounded,
                          size: 15, color: t.primary),
                      const SizedBox(width: 5),
                      Text(
                        'Open in Google Maps',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: t.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PinTip extends CustomPainter {
  final Color color;
  const _PinTip({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width / 2, size.height)
        ..close(),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_PinTip old) => old.color != color;
}

// ── Owner card ────────────────────────────────────────────────────────────────

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

  Future<void> _call(String phone) async {
    try {
      await launchUrl(Uri.parse('tel:$phone'));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final avatarUrl = listing.owner?.avatarUrl;
    final hasContact = listing.ownerPhone != null || listing.ownerAltPhone != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: t.borderSoft),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Listed by',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: t.inkSoft,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: t.primarySoft),
                clipBehavior: Clip.antiAlias,
                child: avatarUrl != null
                    ? Image.network(
                        avatarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _initialsWidget(),
                      )
                    : _initialsWidget(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: t.ink,
                  ),
                ),
              ),
            ],
          ),
          // Tappable contact rows
          if (hasContact) ...[
            const SizedBox(height: 12),
            if (listing.ownerPhone != null)
              _ContactRow(
                t: t,
                icon: Icons.call_outlined,
                label: listing.ownerPhone!,
                onTap: () => _call(listing.ownerPhone!),
              ),
            if (listing.ownerAltPhone != null) ...[
              const SizedBox(height: 8),
              _ContactRow(
                t: t,
                icon: Icons.call_outlined,
                label: listing.ownerAltPhone!,
                onTap: () => _call(listing.ownerAltPhone!),
              ),
            ],
          ],
          if (listing.preferredContact != null) ...[
            const SizedBox(height: 10),
            _PreferredContactBadge(t: t, contact: listing.preferredContact!),
          ],
        ],
      ),
    );
  }

  Widget _initialsWidget() {
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: t.primary,
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final FlatNestTheme t;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ContactRow({
    required this.t,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: t.bgAlt,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: t.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: t.primary,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 18, color: t.inkSoft),
          ],
        ),
      ),
    );
  }
}

// ── Small reusable widgets ────────────────────────────────────────────────────

class _TitledTag extends StatelessWidget {
  final FlatNestTheme t;
  final String icon;
  final String label;
  final String value;
  final Color color;
  final Color labelColor;
  final Color valueColor;

  const _TitledTag({
    required this.t,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.labelColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: labelColor,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(icon, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class _PreferredContactBadge extends StatelessWidget {
  final FlatNestTheme t;
  final String contact;

  const _PreferredContactBadge({required this.t, required this.contact});

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
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: t.primaryInk,
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const _Stat({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1C1C1E),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF8A8A8E),
              ),
            ),
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
