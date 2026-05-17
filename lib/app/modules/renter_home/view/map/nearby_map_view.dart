import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../../theme/flat_nest_theme.dart';
import '../../../listing/model/listing_model.dart';
import '../../controller/renter_home_controller.dart';

class NearbyMapView extends StatefulWidget {
  const NearbyMapView({super.key});

  @override
  State<NearbyMapView> createState() => _NearbyMapViewState();
}

class _NearbyMapViewState extends State<NearbyMapView> {
  static const _defaultCenter = LatLng(23.8103, 90.4125);
  static const _radii = [2.0, 5.0, 10.0, 20.0];

  late final MapController _mapController;
  late final RenterHomeController _c;
  Worker? _tabWorker;

  LatLng _currentCenter = _defaultCenter;
  LatLng? _userPosition;
  LatLng? _searchCenter; // center of the last completed search
  bool _locating = false;
  bool _mapMoved = false;
  ListingModel? _selectedListing;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _c = Get.find<RenterHomeController>();

    // Re-fetch every time the user switches to the Map tab (index 1).
    // Uses the last known position so no location re-prompt on repeat visits.
    _tabWorker = ever(_c.activeTab, (int tab) {
      if (tab == 1 && mounted) _onTabActivated();
    });

    // Handle the case where Map tab is active from app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_c.activeTab.value == 1) _onTabActivated();
    });
  }

  @override
  void dispose() {
    _tabWorker?.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _onTabActivated() {
    if (_searchCenter != null) {
      // Already located before — just refresh the listings silently
      _c.fetchNearbyListings(
        lat: _searchCenter!.latitude,
        lng: _searchCenter!.longitude,
      );
    } else {
      // First visit — locate user then fetch
      _goToUserAndFetch();
    }
  }

  Future<void> _goToUserAndFetch() async {
    if (!mounted) return;
    setState(() => _locating = true);
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        _fetchAtCenter(_defaultCenter);
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
      ).timeout(const Duration(seconds: 10));

      if (!mounted) return;
      final loc = LatLng(pos.latitude, pos.longitude);
      setState(() {
        _currentCenter = loc;
        _userPosition = loc;
      });
      _mapController.move(loc, _radiusToZoom(_c.nearbyRadius.value));
      _fetchAtCenter(loc);
    } catch (_) {
      _fetchAtCenter(_defaultCenter);
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  void _fetchAtCenter(LatLng loc) {
    if (!mounted) return;
    setState(() {
      _searchCenter = loc;
      _mapMoved = false;
    });
    _c.fetchNearbyListings(lat: loc.latitude, lng: loc.longitude);
  }

  void _onRadiusSelected(double r) {
    _c.nearbyRadius.value = r;
    // Zoom map to fit the new radius
    final center = _searchCenter ?? _currentCenter;
    _mapController.move(center, _radiusToZoom(r));
    _fetchAtCenter(center);
  }

  void _onMapPositionChanged(MapCamera camera, bool hasGesture) {
    if (!hasGesture) return;
    _currentCenter = camera.center;
    if (!_mapMoved && mounted) setState(() => _mapMoved = true);
  }

  double _radiusToZoom(double radiusKm) {
    if (radiusKm <= 2) return 14.5;
    if (radiusKm <= 5) return 13.5;
    if (radiusKm <= 10) return 12.5;
    return 11.5;
  }

  void _onMarkerTap(ListingModel listing) {
    setState(() => _selectedListing = listing);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isDismissible: true,
      builder: (_) => _ListingPreviewSheet(
        listing: listing,
        onViewDetails: () {
          Navigator.pop(context);
          _c.openListing(listing);
        },
      ),
    ).whenComplete(() {
      if (mounted) setState(() => _selectedListing = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return Scaffold(
      backgroundColor: t.bg,
      body: Stack(
        children: [
          // ── Map ──────────────────────────────────────────────────────────
          Obx(() {
            // Observe both so the map rebuilds on listing or radius change
            final listings = _c.nearbyListings.toList();
            final radius = _c.nearbyRadius.value;

            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _defaultCenter,
                initialZoom: 13.5,
                onPositionChanged: _onMapPositionChanged,
              ),
              children: [
                // Tiles
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.flatnest.app',
                  maxZoom: 19,
                ),

                // ── Search radius circle ────────────────────────────────
                if (_searchCenter != null)
                  CircleLayer(
                    circles: [
                      // Filled area — gives the "zone" feel
                      CircleMarker(
                        point: _searchCenter!,
                        radius: radius * 1000,
                        useRadiusInMeter: true,
                        color: t.primary.withValues(alpha: 0.13),
                        borderStrokeWidth: 0,
                        borderColor: Colors.transparent,
                      ),
                      // Solid border ring — makes the edge crisp and clear
                      CircleMarker(
                        point: _searchCenter!,
                        radius: radius * 1000,
                        useRadiusInMeter: true,
                        color: Colors.transparent,
                        borderStrokeWidth: 3.0,
                        borderColor: t.primary.withValues(alpha: 0.75),
                      ),
                    ],
                  ),

                // ── User position dot ───────────────────────────────────
                if (_userPosition != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _userPosition!,
                        width: 22,
                        height: 22,
                        child: Container(
                          decoration: BoxDecoration(
                            color: t.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: t.primary.withValues(alpha: 0.45),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                // ── Listing pin markers ─────────────────────────────────
                MarkerLayer(
                  markers: listings
                      .where((l) => l.lat != null && l.lng != null)
                      .map((l) => Marker(
                            point: LatLng(l.lat!, l.lng!),
                            width: 84,
                            height: 44,
                            // Bottom center of widget sits on the coordinate
                            alignment: Alignment.bottomCenter,
                            child: _PricePin(
                              price: '৳${_shortPrice(l.price)}',
                              isSelected:
                                  _selectedListing?.id == l.id,
                              t: t,
                              onTap: () => _onMarkerTap(l),
                            ),
                          ))
                      .toList(),
                ),
              ],
            );
          }),

          // ── Top bar ──────────────────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: _TopBar(
              t: t,
              locating: _locating,
              onMyLocation: _goToUserAndFetch,
            ),
          ),

          // ── Radius chip selector ─────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 60,
            left: 0,
            right: 0,
            child: Center(
              child: Obx(() => _RadiusChips(
                    t: t,
                    selected: _c.nearbyRadius.value,
                    radii: _radii,
                    onSelect: _onRadiusSelected,
                  )),
            ),
          ),

          // ── "Search this area" button ─────────────────────────────────────
          if (_mapMoved)
            Positioned(
              top: MediaQuery.of(context).padding.top + 112,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => _fetchAtCenter(_currentCenter),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 9),
                    decoration: BoxDecoration(
                      color: t.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: t.primary.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_rounded,
                            color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Search this area',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // ── Bottom status badge ───────────────────────────────────────────
          Obx(() {
            if (_c.nearbyLoading.value) {
              return Positioned(
                bottom: 28,
                left: 0,
                right: 0,
                child: Center(
                  child: _StatusBadge(t: t, loading: true, count: 0),
                ),
              );
            }
            return Positioned(
              bottom: 28,
              left: 0,
              right: 0,
              child: Center(
                child: _StatusBadge(
                  t: t,
                  loading: false,
                  count: _c.nearbyListings.length,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  String _shortPrice(int price) {
    if (price >= 100000) return '${(price / 100000).toStringAsFixed(1)}L';
    if (price >= 1000) return '${(price / 1000).toStringAsFixed(0)}k';
    return price.toString();
  }
}

// ── Price pin marker ──────────────────────────────────────────────────────────

class _PricePin extends StatelessWidget {
  final String price;
  final bool isSelected;
  final FlatNestTheme t;
  final VoidCallback onTap;

  const _PricePin({
    required this.price,
    required this.isSelected,
    required this.t,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected ? t.primary : Colors.white;
    final textColor = isSelected ? Colors.white : t.ink;
    final borderColor = isSelected ? t.primary : t.borderSoft;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Price label chip ──────────────────────────────────────────
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withValues(alpha: isSelected ? 0.25 : 0.12),
                  blurRadius: isSelected ? 12 : 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              price,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: textColor,
                height: 1,
              ),
            ),
          ),
          // ── Triangle pointer ──────────────────────────────────────────
          CustomPaint(
            size: const Size(12, 7),
            painter: _PinTipPainter(
              fillColor: bgColor,
              borderColor: borderColor,
              isSelected: isSelected,
            ),
          ),
        ],
      ),
    );
  }
}

class _PinTipPainter extends CustomPainter {
  final Color fillColor;
  final Color borderColor;
  final bool isSelected;

  const _PinTipPainter({
    required this.fillColor,
    required this.borderColor,
    required this.isSelected,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    // Draw border first (slightly larger, painted under)
    if (!isSelected) {
      canvas.drawPath(
        path,
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.fill,
      );
      // Fill inside (slightly inset effect — draw fill slightly smaller)
      final innerPath = ui.Path()
        ..moveTo(1.2, 0)
        ..lineTo(size.width - 1.2, 0)
        ..lineTo(size.width / 2, size.height - 1.2)
        ..close();
      canvas.drawPath(
        innerPath,
        Paint()
          ..color = fillColor
          ..style = PaintingStyle.fill,
      );
    } else {
      canvas.drawPath(
        path,
        Paint()
          ..color = fillColor
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(_PinTipPainter old) =>
      old.fillColor != fillColor || old.isSelected != isSelected;
}

// ── Top bar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final FlatNestTheme t;
  final bool locating;
  final VoidCallback onMyLocation;

  const _TopBar({
    required this.t,
    required this.locating,
    required this.onMyLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, size: 16, color: t.primary),
                const SizedBox(width: 6),
                Text(
                  'Flats Near Me',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: t.ink,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onMyLocation,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: locating
                  ? const Padding(
                      padding: EdgeInsets.all(11),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location_rounded,
                      size: 20, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Radius chip selector ──────────────────────────────────────────────────────

class _RadiusChips extends StatelessWidget {
  final FlatNestTheme t;
  final double selected;
  final List<double> radii;
  final ValueChanged<double> onSelect;

  const _RadiusChips({
    required this.t,
    required this.selected,
    required this.radii,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: radii.map((r) {
          final isSelected = r == selected;
          return GestureDetector(
            onTap: () => onSelect(r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected ? t.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${r.toInt()} km',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : t.inkMid,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Status badge ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final FlatNestTheme t;
  final bool loading;
  final int count;

  const _StatusBadge(
      {required this.t, required this.loading, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: loading
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 13,
                  height: 13,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: t.primary),
                ),
                const SizedBox(width: 8),
                Text('Searching...',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: t.ink)),
              ],
            )
          : Text(
              count == 0
                  ? 'No flats found in this area'
                  : '$count flat${count == 1 ? '' : 's'} found',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: count == 0 ? t.inkMid : t.ink,
              ),
            ),
    );
  }
}

// ── Listing preview sheet ─────────────────────────────────────────────────────

class _ListingPreviewSheet extends StatelessWidget {
  final ListingModel listing;
  final VoidCallback onViewDetails;

  const _ListingPreviewSheet({
    required this.listing,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, 0, 16, MediaQuery.of(context).padding.bottom + 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: t.borderSoft,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 82,
                      height: 82,
                      child: listing.thumbnailUrl != null
                          ? Image.network(
                              listing.thumbnailUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _PlaceholderThumb(t: t),
                            )
                          : _PlaceholderThumb(t: t),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listing.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: t.ink,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          listing.priceFormatted,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: t.primary,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            if (listing.beds != null)
                              _InfoChip(
                                icon: Icons.bed_outlined,
                                label: '${listing.beds} bed',
                                t: t,
                              ),
                            if (listing.baths != null)
                              _InfoChip(
                                icon: Icons.shower_outlined,
                                label: '${listing.baths} bath',
                                t: t,
                              ),
                            if (listing.distanceKm != null)
                              _InfoChip(
                                icon: Icons.near_me_rounded,
                                label:
                                    '${listing.distanceKm!.toStringAsFixed(1)} km',
                                t: t,
                                highlight: true,
                              ),
                          ],
                        ),
                        if (listing.area != null || listing.floorNo != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              [
                                if (listing.area != null) listing.area!,
                                if (listing.floorNo != null)
                                  'Floor ${listing.floorNo}',
                              ].join(' · '),
                              style: TextStyle(
                                  fontSize: 11, color: t.inkMid),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // View Details button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onViewDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: t.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.open_in_new_rounded, size: 16),
                  label: const Text(
                    'View Details',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final FlatNestTheme t;
  final bool highlight;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.t,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: highlight ? t.primarySoft : t.bgAlt,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 12,
              color: highlight ? t.primary : t.inkMid),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: highlight ? t.primary : t.inkMid,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderThumb extends StatelessWidget {
  final FlatNestTheme t;
  const _PlaceholderThumb({required this.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: t.bgAlt,
      child: Icon(Icons.home_rounded, size: 30, color: t.inkFaint),
    );
  }
}
