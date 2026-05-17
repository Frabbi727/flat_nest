import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../theme/flat_nest_theme.dart';
import '../../listing/model/listing_model.dart';
import '../controller/renter_home_controller.dart';

class NearbyMapView extends StatefulWidget {
  const NearbyMapView({super.key});

  @override
  State<NearbyMapView> createState() => _NearbyMapViewState();
}

class _NearbyMapViewState extends State<NearbyMapView> {
  static const _defaultCenter = LatLng(23.8103, 90.4125);

  late final MapController _mapController;
  late final RenterHomeController _c;

  LatLng _center = _defaultCenter;
  LatLng? _userPosition;
  bool _locating = false;
  bool _mapMoved = false;
  ListingModel? _selectedListing;

  // Radius options in km
  static const _radii = [2.0, 5.0, 10.0, 20.0];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _c = Get.find<RenterHomeController>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _goToUserAndFetch());
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
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
        _center = loc;
        _userPosition = loc;
        _mapMoved = false;
      });
      _mapController.move(loc, 14);
      _fetchAtCenter(loc);
    } catch (_) {
      _fetchAtCenter(_defaultCenter);
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  void _fetchAtCenter(LatLng loc) {
    if (!mounted) return;
    setState(() => _mapMoved = false);
    _c.fetchNearbyListings(lat: loc.latitude, lng: loc.longitude);
  }

  void _onMapPositionChanged(MapCamera camera, bool hasGesture) {
    if (!hasGesture) return;
    _center = camera.center;
    if (!_mapMoved && mounted) setState(() => _mapMoved = true);
  }

  void _selectListing(ListingModel listing) {
    setState(() => _selectedListing = listing);
    _showListingSheet(listing);
  }

  void _showListingSheet(ListingModel listing) {
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
        onDismiss: () {
          Navigator.pop(context);
          setState(() => _selectedListing = null);
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
            final listings = _c.nearbyListings;
            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _defaultCenter,
                initialZoom: 13,
                onPositionChanged: _onMapPositionChanged,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.flatnest.app',
                  maxZoom: 19,
                ),
                // User position marker
                if (_userPosition != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _userPosition!,
                        width: 20,
                        height: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            color: t.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: t.primary.withValues(alpha: 0.4),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                // Listing markers
                MarkerLayer(
                  markers: listings
                      .where((l) => l.lat != null && l.lng != null)
                      .map((l) => _buildMarker(l, t))
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

          // ── Radius chips ─────────────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 60,
            left: 0,
            right: 0,
            child: Center(
              child: Obx(() => _RadiusChips(
                    t: t,
                    selected: _c.nearbyRadius.value,
                    radii: _radii,
                    onSelect: (r) {
                      _c.nearbyRadius.value = r;
                      _fetchAtCenter(_center);
                    },
                  )),
            ),
          ),

          // ── "Search this area" button ─────────────────────────────────────
          if (_mapMoved)
            Positioned(
              top: MediaQuery.of(context).padding.top + 110,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => _fetchAtCenter(_center),
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search_rounded,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        const Text(
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

          // ── Loading overlay ───────────────────────────────────────────────
          Obx(() {
            if (!_c.nearbyLoading.value) return const SizedBox.shrink();
            return Positioned(
              bottom: 28,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: t.primary),
                      ),
                      const SizedBox(width: 8),
                      Text('Finding flats...',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: t.ink)),
                    ],
                  ),
                ),
              ),
            );
          }),

          // ── Result count badge ────────────────────────────────────────────
          Obx(() {
            if (_c.nearbyLoading.value) return const SizedBox.shrink();
            final count = _c.nearbyListings.length;
            return Positioned(
              bottom: 28,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
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
                  child: Text(
                    count == 0
                        ? 'No flats found nearby'
                        : '$count flat${count == 1 ? '' : 's'} found nearby',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: count == 0 ? t.inkMid : t.ink,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Marker _buildMarker(ListingModel listing, FlatNestTheme t) {
    final isSelected = _selectedListing?.id == listing.id;
    return Marker(
      point: LatLng(listing.lat!, listing.lng!),
      width: 80,
      height: 36,
      child: GestureDetector(
        onTap: () => _selectListing(listing),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isSelected ? t.primary : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isSelected ? 0.25 : 0.15),
                blurRadius: isSelected ? 12 : 6,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(
              color: isSelected ? t.primary : t.borderSoft,
              width: isSelected ? 0 : 1,
            ),
          ),
          child: Text(
            '৳${_shortPrice(listing.price)}',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: isSelected ? Colors.white : t.ink,
            ),
          ),
        ),
      ),
    );
  }

  String _shortPrice(int price) {
    if (price >= 100000) return '${(price / 100000).toStringAsFixed(1)}L';
    if (price >= 1000) return '${(price / 1000).toStringAsFixed(0)}k';
    return price.toString();
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final FlatNestTheme t;
  final bool locating;
  final VoidCallback onMyLocation;

  const _TopBar(
      {required this.t, required this.locating, required this.onMyLocation});

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

// ── Radius chips ──────────────────────────────────────────────────────────────

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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? t.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${r.toInt()} km',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
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

// ── Listing preview sheet ─────────────────────────────────────────────────────

class _ListingPreviewSheet extends StatelessWidget {
  final ListingModel listing;
  final VoidCallback onViewDetails;
  final VoidCallback onDismiss;

  const _ListingPreviewSheet({
    required this.listing,
    required this.onViewDetails,
    required this.onDismiss,
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
              blurRadius: 20,
              offset: const Offset(0, -4),
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
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: listing.thumbnailUrl != null
                        ? Image.network(
                            listing.thumbnailUrl!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _PlaceholderThumb(t: t),
                          )
                        : _PlaceholderThumb(t: t),
                  ),
                  const SizedBox(width: 12),
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
                        const SizedBox(height: 4),
                        Text(
                          listing.priceFormatted,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: t.primary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            if (listing.beds != null) ...[
                              Icon(Icons.bed_outlined,
                                  size: 13, color: t.inkMid),
                              const SizedBox(width: 3),
                              Text('${listing.beds}',
                                  style: TextStyle(
                                      fontSize: 12, color: t.inkMid)),
                              const SizedBox(width: 8),
                            ],
                            if (listing.baths != null) ...[
                              Icon(Icons.shower_outlined,
                                  size: 13, color: t.inkMid),
                              const SizedBox(width: 3),
                              Text('${listing.baths}',
                                  style: TextStyle(
                                      fontSize: 12, color: t.inkMid)),
                              const SizedBox(width: 8),
                            ],
                            if (listing.distanceKm != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                  color: t.primarySoft,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${listing.distanceKm!.toStringAsFixed(1)} km',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: t.primary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (listing.availableFrom != null ||
                            listing.floorNo != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            [
                              listing.availableFromFormatted,
                              if (listing.floorNo != null)
                                'Floor ${listing.floorNo}',
                            ].join(' · '),
                            style: TextStyle(
                                fontSize: 11, color: t.inkMid),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
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
                child: ElevatedButton(
                  onPressed: onViewDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: t.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
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

class _PlaceholderThumb extends StatelessWidget {
  final FlatNestTheme t;
  const _PlaceholderThumb({required this.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      color: t.bgAlt,
      child: Icon(Icons.home_rounded, size: 28, color: t.inkFaint),
    );
  }
}
