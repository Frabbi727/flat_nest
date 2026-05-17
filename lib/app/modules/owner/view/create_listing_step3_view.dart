import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/flat_nest_theme.dart';
import '../../listing/model/geo_model.dart';
import '../controller/create_listing_controller.dart';
import 'map_picker_view.dart';

class CreateListingStep3View extends GetView<CreateListingController> {
  const CreateListingStep3View({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<FlatNestTheme>()!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GeoSelect(
                t: t,
                label: 'Division',
                placeholder: 'Select division',
                value: controller.division.value,
                items: controller.divisionItems,
                isLoading: controller.divisionsLoading.value,
                isOpen: controller.activeDropdown.value == 'division',
                onToggle: () => controller.toggleDropdown('division'),
                onPick: controller.pickDivision,
              ),
              _GeoSelect(
                t: t,
                label: 'District',
                placeholder: controller.division.value != null
                    ? 'Select district'
                    : 'Select division first',
                value: controller.district.value,
                items: controller.districtItems,
                isLoading: controller.districtsLoading.value,
                isDisabled: controller.division.value == null &&
                    !controller.districtsLoading.value,
                isOpen: controller.activeDropdown.value == 'district',
                onToggle: () => controller.toggleDropdown('district'),
                onPick: controller.pickDistrict,
              ),
              _GeoSelect(
                t: t,
                label: 'Upazila / Thana',
                placeholder: controller.district.value != null
                    ? 'Select upazila'
                    : 'Select district first',
                value: controller.upazila.value,
                items: controller.upazilaItems,
                isLoading: controller.upazilasLoading.value,
                isDisabled: controller.district.value == null &&
                    !controller.upazilasLoading.value,
                isOpen: controller.activeDropdown.value == 'upazila',
                onToggle: () => controller.toggleDropdown('upazila'),
                onPick: controller.pickUpazila,
              ),
              _GeoSelect(
                t: t,
                label: 'Union / Area',
                placeholder: controller.upazila.value != null
                    ? 'Select union'
                    : 'Select upazila first',
                value: controller.union.value,
                items: controller.unionItems,
                isLoading: controller.unionsLoading.value,
                isDisabled: controller.upazila.value == null &&
                    !controller.unionsLoading.value,
                isOpen: controller.activeDropdown.value == 'union',
                onToggle: () => controller.toggleDropdown('union'),
                onPick: controller.pickUnion,
              ),
              // ── Map pin card ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: _MapPinCard(t: t),
              ),

              if (controller.union.value != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: t.primarySoft,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: t.primary.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_on_rounded, color: t.primary, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          [
                            controller.union.value,
                            controller.upazila.value,
                            controller.district.value,
                            controller.division.value,
                          ].whereType<String>().join(' · '),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: t.primaryInk,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // ── Address detail fields ─────────────────────────────────
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: t.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: t.borderSoft),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 14, color: t.inkSoft),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'These details help renters find your flat easily (optional)',
                        style: AppTextStyles.caption.copyWith(color: t.inkSoft),
                      ),
                    ),
                  ],
                ),
              ),
              _FormGroup(
                t: t,
                label: 'Road',
                child: TextField(
                  controller: controller.roadController,
                  style: AppTextStyles.bodyMedium.copyWith(color: t.ink, fontSize: 15),
                  decoration: _inputDeco(t).copyWith(hintText: 'e.g. Road 5, House 12'),
                ),
              ),
              _FormGroup(
                t: t,
                label: 'House / Building Name',
                child: TextField(
                  controller: controller.houseNameController,
                  style: AppTextStyles.bodyMedium.copyWith(color: t.ink, fontSize: 15),
                  decoration: _inputDeco(t).copyWith(hintText: 'e.g. Green Villa'),
                ),
              ),
              _FormGroup(
                t: t,
                label: 'Block',
                child: TextField(
                  controller: controller.blockController,
                  style: AppTextStyles.bodyMedium.copyWith(color: t.ink, fontSize: 15),
                  decoration: _inputDeco(t).copyWith(hintText: 'e.g. Block B'),
                ),
              ),
              _FormGroup(
                t: t,
                label: 'Section',
                child: TextField(
                  controller: controller.sectionController,
                  style: AppTextStyles.bodyMedium.copyWith(color: t.ink, fontSize: 15),
                  decoration: _inputDeco(t).copyWith(hintText: 'e.g. Section 12'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          )),
    );
  }

  InputDecoration _inputDeco(FlatNestTheme t) => InputDecoration(
        filled: true,
        fillColor: t.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: t.borderSoft),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: t.borderSoft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: t.primary, width: 1.5),
        ),
      );
}

// ── Geo dropdown ─────────────────────────────────────────────────────────────

class _GeoSelect extends StatefulWidget {
  final FlatNestTheme t;
  final String label;
  final String placeholder;
  final String? value;
  final List<GeoItemModel> items;
  final bool isLoading;
  final bool isDisabled;
  final bool isOpen;
  final VoidCallback onToggle;
  final ValueChanged<GeoItemModel> onPick;

  const _GeoSelect({
    required this.t,
    required this.label,
    required this.placeholder,
    required this.value,
    required this.items,
    required this.isLoading,
    required this.isOpen,
    required this.onToggle,
    required this.onPick,
    this.isDisabled = false,
  });

  @override
  State<_GeoSelect> createState() => _GeoSelectState();
}

class _GeoSelectState extends State<_GeoSelect> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  String _query = '';

  @override
  void didUpdateWidget(_GeoSelect old) {
    super.didUpdateWidget(old);
    // Clear search whenever the dropdown opens
    if (widget.isOpen && !old.isOpen) {
      _searchController.clear();
      _query = '';
      // Auto-focus the search field when dropdown opens
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchFocus.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  List<GeoItemModel> get _filtered {
    if (_query.isEmpty) return widget.items;
    final q = _query.toLowerCase();
    return widget.items
        .where((item) => item.name.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;
    final filtered = _filtered;

    return Opacity(
      opacity: widget.isDisabled ? 0.5 : 1,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: AppTextStyles.bodySmall.copyWith(
                color: t.inkMid,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 0.1,
              ),
            ),
            const SizedBox(height: 6),
            // Trigger / search — same slot, one element
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: t.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: widget.isOpen ? t.primary : t.borderSoft,
                  width: widget.isOpen ? 1.5 : 1,
                ),
                boxShadow: widget.isOpen
                    ? [
                        BoxShadow(
                          color: t.primary.withValues(alpha: 0.12),
                          blurRadius: 0,
                          spreadRadius: 4,
                        ),
                      ]
                    : null,
              ),
              child: widget.isOpen
                  // ── Open: inline search field ──
                  ? Row(
                      children: [
                        Icon(Icons.search_rounded, size: 18, color: t.inkSoft),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocus,
                            onChanged: (v) => setState(() => _query = v),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: t.ink,
                              fontSize: 15,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  'Search ${widget.label.toLowerCase()}…',
                              hintStyle: TextStyle(
                                  fontSize: 15, color: t.inkFaint),
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        if (_query.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                            child: Icon(Icons.close_rounded,
                                size: 18, color: t.inkSoft),
                          )
                        else
                          GestureDetector(
                            onTap: widget.onToggle,
                            child: Icon(Icons.keyboard_arrow_up_rounded,
                                size: 20, color: t.inkSoft),
                          ),
                      ],
                    )
                  // ── Closed: tap-to-open display ──
                  : GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: widget.isDisabled || widget.isLoading
                          ? null
                          : widget.onToggle,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.value ?? widget.placeholder,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color:
                                    widget.value != null ? t.ink : t.inkFaint,
                                fontWeight: widget.value != null
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          if (widget.isLoading)
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: t.primary,
                              ),
                            )
                          else
                            Icon(Icons.keyboard_arrow_down_rounded,
                                color: t.inkSoft, size: 20),
                        ],
                      ),
                    ),
            ),

            // ── Dropdown list ──
            if (widget.isOpen)
              Container(
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: t.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: t.borderSoft),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 240),
                  child: widget.items.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: t.primary,
                              ),
                            ),
                          ),
                        )
                      : filtered.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.search_off_rounded,
                                      size: 30, color: t.inkFaint),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Nothing found for "$_query"',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: t.inkSoft,
                                        fontWeight: FontWeight.w500),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) =>
                                  Divider(height: 1, color: t.borderSoft),
                              itemBuilder: (context, i) {
                                final item = filtered[i];
                                final selected = item.name == widget.value;
                                return GestureDetector(
                                  onTap: () {
                                    widget.onPick(item);
                                    _searchController.clear();
                                    setState(() => _query = '');
                                  },
                                  child: Container(
                                    color: selected
                                        ? t.primarySoft
                                        : t.surface,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 13),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _query.isNotEmpty
                                              ? _HighlightText(
                                                  text: item.name,
                                                  query: _query,
                                                  t: t,
                                                  selected: selected,
                                                )
                                              : Text(
                                                  item.name,
                                                  style: AppTextStyles
                                                      .bodyMedium
                                                      .copyWith(
                                                    color: selected
                                                        ? t.primaryInk
                                                        : t.ink,
                                                    fontWeight: selected
                                                        ? FontWeight.w600
                                                        : FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                        ),
                                        if (selected)
                                          Icon(Icons.check_rounded,
                                              color: t.primary, size: 16),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Highlight text ────────────────────────────────────────────────────────────

class _HighlightText extends StatelessWidget {
  final String text;
  final String query;
  final FlatNestTheme t;
  final bool selected;

  const _HighlightText({
    required this.text,
    required this.query,
    required this.t,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final q = query.toLowerCase();
    final lower = text.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;

    while (start < text.length) {
      final idx = lower.indexOf(q, start);
      if (idx == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (idx > start) {
        spans.add(TextSpan(text: text.substring(start, idx)));
      }
      spans.add(TextSpan(
        text: text.substring(idx, idx + q.length),
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: selected ? t.primaryInk : t.primary,
          backgroundColor: t.primary.withValues(alpha: selected ? 0.15 : 0.1),
        ),
      ));
      start = idx + q.length;
    }

    return Text.rich(
      TextSpan(
        style: AppTextStyles.bodyMedium.copyWith(
          color: selected ? t.primaryInk : t.ink,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        children: spans,
      ),
    );
  }
}

// ── Map pin card ──────────────────────────────────────────────────────────────

class _MapPinCard extends GetView<CreateListingController> {
  final FlatNestTheme t;
  const _MapPinCard({required this.t});

  Future<void> _openPicker() async {
    final result = await MapPickerView.open(
      lat: controller.lat.value,
      lng: controller.lng.value,
    );
    if (result != null) {
      controller.setCoordinates(result.lat, result.lng, address: result.address);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pin exact location',
          style: AppTextStyles.bodySmall.copyWith(
            color: t.inkMid,
            fontWeight: FontWeight.w600,
            fontSize: 12,
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 6),
        Obx(() {
          final lat = controller.lat.value;
          final lng = controller.lng.value;
          final hasPin = lat != null && lng != null;

          if (!hasPin) {
            return GestureDetector(
              onTap: _openPicker,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: t.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: t.primary.withValues(alpha: 0.4),
                      style: BorderStyle.solid),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: t.primarySoft,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add_location_alt_rounded,
                          color: t.primary, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tap to pin on map',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: t.ink,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Helps renters find your flat faster',
                            style: TextStyle(fontSize: 11, color: t.inkSoft),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: t.inkSoft, size: 20),
                  ],
                ),
              ),
            );
          }

          // Coordinates pinned — show summary card
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: t.primarySoft,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: t.primary.withValues(alpha: 0.35)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: t.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_on_rounded,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.pinnedAddress.value != null)
                        Text(
                          controller.pinnedAddress.value!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: t.primaryInk,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      Text(
                        '${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: t.primaryInk.withValues(alpha: 0.7),
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _openPicker,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: t.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: t.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: controller.clearCoordinates,
                  child: Icon(Icons.close_rounded,
                      size: 18, color: t.primaryInk.withValues(alpha: 0.5)),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 4),
        Text(
          'Optional — helps renters navigate directly to your flat',
          style: AppTextStyles.caption.copyWith(color: t.inkSoft, fontSize: 11),
        ),
      ],
    );
  }
}

// ── Form group ────────────────────────────────────────────────────────────────

class _FormGroup extends StatelessWidget {
  final FlatNestTheme t;
  final String label;
  final Widget child;

  const _FormGroup({
    required this.t,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: t.inkMid,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}
