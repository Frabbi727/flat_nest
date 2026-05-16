import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' hide Response;
import 'package:latlong2/latlong.dart';
import '../../../theme/flat_nest_theme.dart';

// Result returned when the user confirms a location
class MapPickerResult {
  final double lat;
  final double lng;
  final String? address;
  const MapPickerResult({required this.lat, required this.lng, this.address});
}

class MapPickerView extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;

  const MapPickerView({super.key, this.initialLat, this.initialLng});

  // Push this page and return MapPickerResult or null
  static Future<MapPickerResult?> open({double? lat, double? lng}) async =>
      Get.to<MapPickerResult?>(
        () => MapPickerView(initialLat: lat, initialLng: lng),
        transition: Transition.downToUp,
        duration: const Duration(milliseconds: 300),
      );

  @override
  State<MapPickerView> createState() => _MapPickerViewState();
}

class _MapPickerViewState extends State<MapPickerView> {
  // Default center: Dhaka, Bangladesh
  static const _defaultCenter = LatLng(23.8103, 90.4125);

  // Dedicated Dio for Nominatim reverse geocoding (separate from backend client)
  static final _nominatim = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 8),
    receiveTimeout: const Duration(seconds: 8),
    headers: {
      // Nominatim usage policy requires a meaningful User-Agent
      'User-Agent': 'FlatNest/1.0 (rental listing app)',
      'Accept-Language': 'en',
    },
  ));

  late final MapController _mapController;
  LatLng _center = _defaultCenter;
  String? _address;
  bool _loadingLocation = false;
  bool _geocoding = false;
  Timer? _geocodeTimer;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    if (widget.initialLat != null && widget.initialLng != null) {
      _center = LatLng(widget.initialLat!, widget.initialLng!);
      // Reverse geocode after first frame so map is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _reverseGeocode(_center);
      });
    } else {
      // Request location after first frame so permission dialog can show
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _goToCurrentLocation();
      });
    }
  }

  @override
  void dispose() {
    _geocodeTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _goToCurrentLocation() async {
    if (!mounted) return;
    setState(() => _loadingLocation = true);
    try {
      // 1. Check if location service is enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          _showLocationDialog(
            'Location Off',
            'Please enable location services on your device to use this feature.',
            onSettings: Geolocator.openLocationSettings,
          );
        }
        return;
      }

      // 2. Check / request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (mounted) { _showLocationError('Location permission was denied.'); }
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          _showLocationDialog(
            'Permission Required',
            'Location access is permanently denied. Open app settings to enable it.',
            onSettings: Geolocator.openAppSettings,
          );
        }
        return;
      }

      // 3. Try last known position first for instant feedback
      final last = await Geolocator.getLastKnownPosition();
      if (last != null && mounted) {
        final loc = LatLng(last.latitude, last.longitude);
        setState(() => _center = loc);
        _mapController.move(loc, 16);
        _reverseGeocode(loc);
      }

      // 4. Get accurate current position (no timeout — let it acquire naturally)
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      if (!mounted) return;
      final loc = LatLng(pos.latitude, pos.longitude);
      setState(() => _center = loc);
      _mapController.move(loc, 16);
      _reverseGeocode(loc);
    } on PermissionDeniedException {
      if (mounted) { _showLocationError('Location permission was denied.'); }
    } on LocationServiceDisabledException {
      if (mounted) {
        _showLocationDialog(
          'Location Off',
          'Please enable location services on your device.',
          onSettings: Geolocator.openLocationSettings,
        );
      }
    } catch (e) {
      if (mounted) { _showLocationError('Unable to get location. Try again.'); }
    } finally {
      if (mounted) setState(() => _loadingLocation = false);
    }
  }

  void _showLocationError(String msg) {
    Get.snackbar(
      'Location',
      msg,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      borderRadius: 12,
    );
  }

  void _showLocationDialog(String title, String msg,
      {required Future<void> Function() onSettings}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        content: Text(msg, style: const TextStyle(fontSize: 14, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _onMapPositionChanged(MapCamera camera, bool hasGesture) {
    if (!hasGesture) return;
    _center = camera.center;
    // Debounce geocoding — only fire 600ms after map stops moving
    _geocodeTimer?.cancel();
    setState(() => _address = null);
    _geocodeTimer = Timer(const Duration(milliseconds: 600), () {
      _reverseGeocode(_center);
    });
  }

  Future<void> _reverseGeocode(LatLng pos) async {
    if (mounted) setState(() => _geocoding = true);
    try {
      final response = await _nominatim.get<Map<String, dynamic>>(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'format': 'json',
          'lat': pos.latitude,
          'lon': pos.longitude,
          'addressdetails': 1,
          'zoom': 18, // street/house level detail
        },
      );
      if (!mounted) return;
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!;
        // Build a concise address from the most specific available fields.
        // Nominatim fields vary widely by country — Bangladesh often has
        // neighbourhood/suburb/city but rarely house_number/road.
        final addr = data['address'] as Map<String, dynamic>? ?? {};
        final result = _buildAddress(addr, data['display_name'] as String?);
        setState(() => _address = result);
      }
    } catch (_) {
      // Geocoding is best-effort — silently ignore network failures
    } finally {
      if (mounted) setState(() => _geocoding = false);
    }
  }

  /// Picks the most human-readable short address from Nominatim address fields.
  /// Priority: specific → broad. Falls back to the first 3 parts of display_name.
  String? _buildAddress(Map<String, dynamic> addr, String? displayName) {
    // Ordered from most specific to most general
    final candidates = [
      addr['house_number'],
      addr['road'],
      addr['pedestrian'],
      addr['footway'],
      addr['path'],
      addr['neighbourhood'],
      addr['hamlet'],
      addr['suburb'],
      addr['village'],
      addr['town'],
      addr['city_district'],
      addr['city'],
      addr['county'],
      addr['state_district'],
      addr['state'],
    ];

    final parts = candidates
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .take(3) // keep it concise
        .toList();

    if (parts.isNotEmpty) return parts.join(', ');

    // Last resort: use the first 3 comma-separated parts of display_name
    if (displayName != null) {
      final segments = displayName
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .take(3)
          .toList();
      if (segments.isNotEmpty) return segments.join(', ');
    }

    return null;
  }

  void _confirm() {
    Get.back(
        result: MapPickerResult(
      lat: _center.latitude,
      lng: _center.longitude,
      address: _address,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return Scaffold(
      backgroundColor: t.bg,
      body: Stack(
        children: [
          // ── Map ──────────────────────────────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: widget.initialLat != null ? 16.0 : 13.0,
              onPositionChanged: _onMapPositionChanged,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.flatnest.app',
                maxZoom: 19,
              ),
            ],
          ),

          // ── Crosshair ────────────────────────────────────────────────────
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: t.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: t.primary.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child:
                      const Icon(Icons.location_on, color: Colors.white, size: 26),
                ),
                // Pin stem
                Container(
                  width: 3,
                  height: 14,
                  decoration: BoxDecoration(
                    color: t.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Shadow dot
                Container(
                  width: 10,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          ),

          // ── Top bar ──────────────────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  _MapBtn(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => Get.back(),
                  ),
                  const Spacer(),
                  _MapBtn(
                    icon: Icons.my_location_rounded,
                    loading: _loadingLocation,
                    onTap: _goToCurrentLocation,
                  ),
                ],
              ),
            ),
          ),

          // ── Title chip ───────────────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 62,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  'Move map to pin location',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: t.ink,
                  ),
                ),
              ),
            ),
          ),

          // ── Bottom confirm sheet ──────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(
                  20, 16, 20, MediaQuery.of(context).padding.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: t.borderSoft,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Coordinates display
                  Row(
                    children: [
                      Icon(Icons.gps_fixed_rounded,
                          size: 14, color: t.inkSoft),
                      const SizedBox(width: 6),
                      Text(
                        '${_center.latitude.toStringAsFixed(6)}, ${_center.longitude.toStringAsFixed(6)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: t.inkSoft,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Address
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _geocoding
                        ? Row(
                            key: const ValueKey('loading'),
                            children: [
                              SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: t.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Finding address...',
                                style: TextStyle(
                                    fontSize: 13, color: t.inkSoft),
                              ),
                            ],
                          )
                        : Row(
                            key: ValueKey(_address ?? 'none'),
                            children: [
                              Icon(Icons.location_on_outlined,
                                  size: 16, color: t.primary),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  _address ?? 'No address found at this location',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: t.ink,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 18),

                  // Confirm button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _confirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: t.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: const Text(
                        'Use this location',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool loading;

  const _MapBtn({required this.icon, required this.onTap, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: loading
            ? const Padding(
                padding: EdgeInsets.all(11),
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(icon, size: 20, color: Colors.black87),
      ),
    );
  }
}
