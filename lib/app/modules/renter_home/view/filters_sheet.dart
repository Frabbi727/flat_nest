import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/flat_nest_theme.dart';
import '../../listing/model/geo_model.dart';
import '../controller/renter_home_controller.dart';

class FiltersSheet extends StatefulWidget {
  final FlatNestTheme t;
  const FiltersSheet({super.key, required this.t});

  @override
  State<FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<FiltersSheet> {
  late final RenterHomeController _c;

  double _maxPrice = 80000;
  final Set<int> _selectedAmenityIds = {};

  GeoItemModel? _selectedDivision;
  GeoItemModel? _selectedDistrict;
  GeoItemModel? _selectedUpazila;
  GeoItemModel? _selectedUnion;

  FlatNestTheme get t => widget.t;

  @override
  void initState() {
    super.initState();
    _c = Get.find<RenterHomeController>();
    _maxPrice = _c.filterMaxPrice.value.toDouble();
    _selectedAmenityIds.addAll(_c.filterAmenityIds);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: t.inkFaint,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: t.ink,
                          letterSpacing: -0.3,
                        ),
                      ),
                      TextButton(
                        onPressed: _resetAll,
                        child: Text(
                          'Reset all',
                          style: TextStyle(
                              color: t.primary, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── LOCATION ──────────────────────────────────────────────
                  _sectionLabel('LOCATION'),
                  const SizedBox(height: 12),

                  // Division
                  Obx(() => _GeoDropdown(
                        t: t,
                        label: 'Division',
                        value: _selectedDivision,
                        items: _c.divisions,
                        isLoading: _c.isDivisionsLoading.value,
                        enabled: true,
                        onChanged: (item) async {
                          setState(() {
                            _selectedDivision = item;
                            _selectedDistrict = null;
                            _selectedUpazila = null;
                            _selectedUnion = null;
                          });
                          await _c.onDivisionSelected(item?.id);
                        },
                      )),
                  const SizedBox(height: 10),

                  // District
                  Obx(() => _GeoDropdown(
                        t: t,
                        label: 'District',
                        value: _selectedDistrict,
                        items: _c.districts,
                        isLoading: _c.isDistrictsLoading.value,
                        enabled: _selectedDivision != null,
                        onChanged: (item) async {
                          setState(() {
                            _selectedDistrict = item;
                            _selectedUpazila = null;
                            _selectedUnion = null;
                          });
                          await _c.onDistrictSelected(item?.id);
                        },
                      )),
                  const SizedBox(height: 10),

                  // Upazila
                  Obx(() => _GeoDropdown(
                        t: t,
                        label: 'Upazila',
                        value: _selectedUpazila,
                        items: _c.upazilas,
                        isLoading: _c.isUpazilasLoading.value,
                        enabled: _selectedDistrict != null,
                        onChanged: (item) async {
                          setState(() {
                            _selectedUpazila = item;
                            _selectedUnion = null;
                          });
                          await _c.onUpazilaSelected(item?.id);
                        },
                      )),
                  const SizedBox(height: 10),

                  // Union
                  Obx(() => _GeoDropdown(
                        t: t,
                        label: 'Union',
                        value: _selectedUnion,
                        items: _c.unions,
                        isLoading: _c.isUnionsLoading.value,
                        enabled: _selectedUpazila != null,
                        onChanged: (item) {
                          setState(() => _selectedUnion = item);
                          _c.onUnionSelected(item?.id);
                        },
                      )),
                  const SizedBox(height: 22),

                  // ── MAX PRICE ──────────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _sectionLabel('MAX PRICE'),
                      Text(
                        '৳${_formatPrice(_maxPrice.round())} /mo',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: t.primary),
                      ),
                    ],
                  ),
                  Slider(
                    value: _maxPrice,
                    min: 5000,
                    max: 80000,
                    divisions: 150,
                    activeColor: t.primary,
                    inactiveColor: t.borderSoft,
                    onChanged: (v) => setState(() => _maxPrice = v),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('৳5k', style: TextStyle(fontSize: 11, color: t.inkSoft)),
                      Text('৳80k', style: TextStyle(fontSize: 11, color: t.inkSoft)),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // ── AMENITIES ──────────────────────────────────────────────
                  _sectionLabel('AMENITIES'),
                  const SizedBox(height: 10),
                  Obx(() {
                    final ams = _c.amenities;
                    if (ams.isEmpty) {
                      return Text('Loading amenities...',
                          style:
                              TextStyle(fontSize: 13, color: t.inkFaint));
                    }
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ams.map((amenity) {
                        final active =
                            _selectedAmenityIds.contains(amenity.id);
                        return GestureDetector(
                          onTap: () => setState(() {
                            if (active) {
                              _selectedAmenityIds.remove(amenity.id);
                            } else {
                              _selectedAmenityIds.add(amenity.id);
                            }
                          }),
                          child: _chip(
                            active ? '✓ ${amenity.name}' : amenity.name,
                            active,
                          ),
                        );
                      }).toList(),
                    );
                  }),
                  const SizedBox(height: 28),

                  // ── Buttons ───────────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: t.border),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text('Cancel',
                              style: TextStyle(
                                  color: t.ink,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _applyAndClose,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: t.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Show results',
                              style:
                                  TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _applyAndClose() {
    _c.applyFilters(
      maxPrice: _maxPrice,
      amenityIds: _selectedAmenityIds.toList(),
    );
    Navigator.pop(context);
  }

  void _resetAll() {
    setState(() {
      _maxPrice = 80000;
      _selectedAmenityIds.clear();
      _selectedDivision = null;
      _selectedDistrict = null;
      _selectedUpazila = null;
      _selectedUnion = null;
    });
    _c.resetFilters();
  }

  Widget _sectionLabel(String text) => Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: t.inkMid,
          letterSpacing: 0.6,
        ),
      );

  Widget _chip(String label, bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: active ? t.primary : t.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: active ? t.primary : t.borderSoft),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: active ? Colors.white : t.inkMid,
        ),
      ),
    );
  }

  String _formatPrice(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(0)}k';
    return n.toString();
  }
}

class _GeoDropdown extends StatelessWidget {
  final FlatNestTheme t;
  final String label;
  final GeoItemModel? value;
  final List<GeoItemModel> items;
  final bool isLoading;
  final bool enabled;
  final void Function(GeoItemModel?)? onChanged;

  const _GeoDropdown({
    required this.t,
    required this.label,
    required this.value,
    required this.items,
    this.isLoading = false,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = !enabled;
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDisabled ? t.bg : t.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDisabled ? t.borderSoft : t.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: isLoading
          ? Row(
              children: [
                Expanded(
                  child: Text(
                    'Loading...',
                    style: TextStyle(fontSize: 14, color: t.inkFaint),
                  ),
                ),
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: t.primary),
                ),
              ],
            )
          : DropdownButtonHideUnderline(
              child: DropdownButton<GeoItemModel>(
                value: value,
                hint: Text(
                  isDisabled ? label : 'Select $label',
                  style: TextStyle(
                      fontSize: 14,
                      color: isDisabled
                          ? t.inkFaint.withValues(alpha: 0.5)
                          : t.inkFaint),
                ),
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: isDisabled ? t.inkFaint : t.inkMid,
                  size: 20,
                ),
                style: TextStyle(fontSize: 14, color: t.ink),
                dropdownColor: t.surface,
                onChanged: (enabled && items.isNotEmpty) ? onChanged : null,
                items: [
                  DropdownMenuItem<GeoItemModel>(
                    value: null,
                    child: Text(
                      'Any $label',
                      style: TextStyle(color: t.inkMid),
                    ),
                  ),
                  ...items.map(
                    (item) => DropdownMenuItem<GeoItemModel>(
                      value: item,
                      child: Text(item.name),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
