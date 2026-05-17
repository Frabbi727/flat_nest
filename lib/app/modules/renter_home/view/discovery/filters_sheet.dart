import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/service/meta_service.dart';
import '../../../../theme/flat_nest_theme.dart';
import '../../../listing/model/geo_model.dart';
import '../../controller/renter_home_controller.dart';

class FiltersSheet extends StatefulWidget {
  final FlatNestTheme t;
  const FiltersSheet({super.key, required this.t});

  @override
  State<FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<FiltersSheet> {
  late final RenterHomeController _c;

  double _minPrice = 0;
  double _maxPrice = 80000;
  final Set<int> _selectedAmenityIds = {};

  GeoItemModel? _selectedDivision;
  GeoItemModel? _selectedDistrict;
  GeoItemModel? _selectedUpazila;
  GeoItemModel? _selectedUnion;

  int? _selectedBaths;
  int? _selectedFacingId;

  final _floorMinController = TextEditingController();
  final _floorMaxController = TextEditingController();
  final _sizeMinController = TextEditingController();
  final _sizeMaxController = TextEditingController();

  DateTime? _availableFromStart;
  DateTime? _availableFromEnd;
  String? _sortBy;

  FlatNestTheme get t => widget.t;

  @override
  void initState() {
    super.initState();
    _c = Get.find<RenterHomeController>();
    _minPrice = _c.filterPriceMin.value.toDouble();
    _maxPrice = _c.filterMaxPrice.value.toDouble();
    _selectedAmenityIds.addAll(_c.filterAmenityIds);
    _selectedBaths = _c.filterBaths.value;
    _selectedFacingId = _c.filterFacingId.value;
    if (_c.filterFloorMin.value != null) _floorMinController.text = '${_c.filterFloorMin.value}';
    if (_c.filterFloorMax.value != null) _floorMaxController.text = '${_c.filterFloorMax.value}';
    if (_c.filterSizeMin.value != null) _sizeMinController.text = '${_c.filterSizeMin.value}';
    if (_c.filterSizeMax.value != null) _sizeMaxController.text = '${_c.filterSizeMax.value}';
    if (_c.filterAvailableFromStart.value != null) {
      _availableFromStart = DateTime.tryParse(_c.filterAvailableFromStart.value!);
    }
    if (_c.filterAvailableFromEnd.value != null) {
      _availableFromEnd = DateTime.tryParse(_c.filterAvailableFromEnd.value!);
    }
    _sortBy = _c.filterSortBy.value;
  }

  @override
  void dispose() {
    _floorMinController.dispose();
    _floorMaxController.dispose();
    _sizeMinController.dispose();
    _sizeMaxController.dispose();
    super.dispose();
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
            decoration: BoxDecoration(color: t.inkFaint, borderRadius: BorderRadius.circular(2)),
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
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: t.ink, letterSpacing: -0.3),
                      ),
                      TextButton(
                        onPressed: _resetAll,
                        child: Text('Reset all', style: TextStyle(color: t.primary, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── SORT BY ──────────────────────────────────────────────
                  _sectionLabel('SORT BY'),
                  const SizedBox(height: 10),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: t.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: t.border),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String?>(
                        value: _sortBy,
                        hint: Text('Default', style: TextStyle(fontSize: 14, color: t.inkFaint)),
                        isExpanded: true,
                        icon: Icon(Icons.keyboard_arrow_down_rounded, color: t.inkMid, size: 20),
                        style: TextStyle(fontSize: 14, color: t.ink),
                        dropdownColor: t.surface,
                        onChanged: (v) => setState(() => _sortBy = v),
                        items: [
                          DropdownMenuItem(value: null, child: Text('Default', style: TextStyle(color: t.inkMid))),
                          const DropdownMenuItem(value: 'price_asc', child: Text('Price: Low to High')),
                          const DropdownMenuItem(value: 'price_desc', child: Text('Price: High to Low')),
                          const DropdownMenuItem(value: 'newest', child: Text('Newest First')),
                          const DropdownMenuItem(value: 'oldest', child: Text('Oldest First')),
                          const DropdownMenuItem(value: 'size_asc', child: Text('Size: Small to Large')),
                          const DropdownMenuItem(value: 'size_desc', child: Text('Size: Large to Small')),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // ── LOCATION ──────────────────────────────────────────────
                  _sectionLabel('LOCATION'),
                  const SizedBox(height: 12),
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

                  // ── PRICE RANGE ────────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _sectionLabel('PRICE RANGE'),
                      Text(
                        '৳${_fmtPrice(_minPrice.round())} – ৳${_fmtPrice(_maxPrice.round())} /mo',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: t.primary),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: RangeValues(_minPrice, _maxPrice),
                    min: 0,
                    max: 80000,
                    divisions: 160,
                    activeColor: t.primary,
                    inactiveColor: t.borderSoft,
                    onChanged: (v) => setState(() {
                      _minPrice = v.start;
                      _maxPrice = v.end;
                    }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('৳0', style: TextStyle(fontSize: 11, color: t.inkSoft)),
                      Text('৳80k', style: TextStyle(fontSize: 11, color: t.inkSoft)),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // ── BATHROOMS ──────────────────────────────────────────────
                  _sectionLabel('BATHROOMS'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _selChip('Any', _selectedBaths == null, () => setState(() => _selectedBaths = null)),
                      const SizedBox(width: 8),
                      _selChip('1', _selectedBaths == 1, () => setState(() => _selectedBaths = 1)),
                      const SizedBox(width: 8),
                      _selChip('2', _selectedBaths == 2, () => setState(() => _selectedBaths = 2)),
                      const SizedBox(width: 8),
                      _selChip('3+', _selectedBaths == 3, () => setState(() => _selectedBaths = 3)),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // ── FACING DIRECTION ───────────────────────────────────────
                  _sectionLabel('FACING DIRECTION'),
                  const SizedBox(height: 10),
                  Obx(() {
                    final facings = Get.find<MetaService>().listingFacings;
                    if (facings.isEmpty) return const SizedBox.shrink();
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => _selectedFacingId = null),
                          child: _chip('Any', _selectedFacingId == null),
                        ),
                        ...facings.map((f) => GestureDetector(
                              onTap: () => setState(() => _selectedFacingId = f.id),
                              child: _chip(f.label, _selectedFacingId == f.id),
                            )),
                      ],
                    );
                  }),
                  const SizedBox(height: 22),

                  // ── FLOOR RANGE ────────────────────────────────────────────
                  _sectionLabel('FLOOR RANGE'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _numField(_floorMinController, 'Min floor')),
                      const SizedBox(width: 12),
                      Expanded(child: _numField(_floorMaxController, 'Max floor')),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // ── SIZE (SQ FT) ───────────────────────────────────────────
                  _sectionLabel('SIZE (SQ FT)'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _numField(_sizeMinController, 'Min size')),
                      const SizedBox(width: 12),
                      Expanded(child: _numField(_sizeMaxController, 'Max size')),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // ── AVAILABLE FROM ─────────────────────────────────────────
                  _sectionLabel('AVAILABLE FROM'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _datePicker(
                          label: _availableFromStart != null ? _fmtDate(_availableFromStart!) : 'Start date',
                          onTap: () async {
                            final d = await showDatePicker(
                              context: context,
                              initialDate: _availableFromStart ?? DateTime.now(),
                              firstDate: DateTime.now().subtract(const Duration(days: 1)),
                              lastDate: DateTime.now().add(const Duration(days: 730)),
                            );
                            if (d != null) setState(() => _availableFromStart = d);
                          },
                          onClear: _availableFromStart != null ? () => setState(() => _availableFromStart = null) : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _datePicker(
                          label: _availableFromEnd != null ? _fmtDate(_availableFromEnd!) : 'End date',
                          onTap: () async {
                            final d = await showDatePicker(
                              context: context,
                              initialDate: _availableFromEnd ?? DateTime.now(),
                              firstDate: DateTime.now().subtract(const Duration(days: 1)),
                              lastDate: DateTime.now().add(const Duration(days: 730)),
                            );
                            if (d != null) setState(() => _availableFromEnd = d);
                          },
                          onClear: _availableFromEnd != null ? () => setState(() => _availableFromEnd = null) : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // ── AMENITIES ──────────────────────────────────────────────
                  _sectionLabel('AMENITIES'),
                  const SizedBox(height: 10),
                  Obx(() {
                    final ams = _c.amenities;
                    if (ams.isEmpty) {
                      return Text('Loading amenities...', style: TextStyle(fontSize: 13, color: t.inkFaint));
                    }
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ams.map((amenity) {
                        final active = _selectedAmenityIds.contains(amenity.id);
                        return GestureDetector(
                          onTap: () => setState(() {
                            if (active) {
                              _selectedAmenityIds.remove(amenity.id);
                            } else {
                              _selectedAmenityIds.add(amenity.id);
                            }
                          }),
                          child: _chip(active ? '✓ ${amenity.name}' : amenity.name, active),
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text('Cancel', style: TextStyle(color: t.ink, fontWeight: FontWeight.w600)),
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Show results', style: TextStyle(fontWeight: FontWeight.w600)),
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
      minPrice: _minPrice,
      amenityIds: _selectedAmenityIds.toList(),
      baths: _selectedBaths,
      facingId: _selectedFacingId,
      floorMin: int.tryParse(_floorMinController.text.trim()),
      floorMax: int.tryParse(_floorMaxController.text.trim()),
      sizeMin: int.tryParse(_sizeMinController.text.trim()),
      sizeMax: int.tryParse(_sizeMaxController.text.trim()),
      availableFromStart: _availableFromStart != null ? _toApiDate(_availableFromStart!) : null,
      availableFromEnd: _availableFromEnd != null ? _toApiDate(_availableFromEnd!) : null,
      sortBy: _sortBy,
    );
    Navigator.pop(context);
  }

  void _resetAll() {
    setState(() {
      _maxPrice = 80000;
      _minPrice = 0;
      _selectedAmenityIds.clear();
      _selectedDivision = null;
      _selectedDistrict = null;
      _selectedUpazila = null;
      _selectedUnion = null;
      _selectedBaths = null;
      _selectedFacingId = null;
      _floorMinController.clear();
      _floorMaxController.clear();
      _sizeMinController.clear();
      _sizeMaxController.clear();
      _availableFromStart = null;
      _availableFromEnd = null;
      _sortBy = null;
    });
    _c.resetFilters();
  }

  Widget _sectionLabel(String text) => Text(
        text,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: t.inkMid, letterSpacing: 0.6),
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
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: active ? Colors.white : t.inkMid),
      ),
    );
  }

  Widget _selChip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: _chip(label, active));
  }

  Widget _numField(TextEditingController controller, String hint) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: t.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(fontSize: 14, color: t.ink),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 14, color: t.inkFaint),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _datePicker({required String label, required VoidCallback onTap, VoidCallback? onClear}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: t.border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(Icons.calendar_month_outlined, size: 16, color: t.inkSoft),
            const SizedBox(width: 6),
            Expanded(
              child: Text(label, style: TextStyle(fontSize: 13, color: t.ink), overflow: TextOverflow.ellipsis),
            ),
            if (onClear != null)
              GestureDetector(
                onTap: onClear,
                child: Icon(Icons.clear, size: 16, color: t.inkSoft),
              ),
          ],
        ),
      ),
    );
  }

  String _fmtDate(DateTime d) => '${d.day}/${d.month}/${d.year}';

  String _toApiDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _fmtPrice(int n) {
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
                Expanded(child: Text('Loading...', style: TextStyle(fontSize: 14, color: t.inkFaint))),
                SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: t.primary)),
              ],
            )
          : DropdownButtonHideUnderline(
              child: DropdownButton<GeoItemModel>(
                value: value,
                hint: Text(
                  isDisabled ? label : 'Select $label',
                  style: TextStyle(fontSize: 14, color: isDisabled ? t.inkFaint.withValues(alpha: 0.5) : t.inkFaint),
                ),
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: isDisabled ? t.inkFaint : t.inkMid, size: 20),
                style: TextStyle(fontSize: 14, color: t.ink),
                dropdownColor: t.surface,
                onChanged: (enabled && items.isNotEmpty) ? onChanged : null,
                items: [
                  DropdownMenuItem<GeoItemModel>(
                    value: null,
                    child: Text('Any $label', style: TextStyle(color: t.inkMid)),
                  ),
                  ...items.map(
                    (item) => DropdownMenuItem<GeoItemModel>(value: item, child: Text(item.name)),
                  ),
                ],
              ),
            ),
    );
  }
}
