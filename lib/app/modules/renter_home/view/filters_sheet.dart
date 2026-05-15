import 'package:flutter/material.dart';
import '../../../theme/flat_nest_theme.dart';

class FiltersSheet extends StatefulWidget {
  final FlatNestTheme t;

  const FiltersSheet({super.key, required this.t});

  @override
  State<FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<FiltersSheet> {
  String? selectedType;
  double maxPrice = 35000;
  final Map<String, bool> amenities = {
    'WiFi': true,
    'Parking': false,
    'Gas Line': true,
    'Elevator': false,
    'Generator': false,
    'AC': false,
  };

  FlatNestTheme get t => widget.t;

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
          // Handle
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
                        onPressed: () => setState(() {
                          selectedType = null;
                          maxPrice = 35000;
                          amenities.updateAll((_, __) => false);
                        }),
                        child: Text('Reset', style: TextStyle(color: t.primary, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _sectionLabel('TYPE'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Family', 'Bachelor', 'Couple', 'Student', 'Sublet'].map((type) {
                      final active = selectedType == type;
                      return GestureDetector(
                        onTap: () => setState(() => selectedType = active ? null : type),
                        child: _chip(type, active),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _sectionLabel('MAX PRICE'),
                      Text(
                        '৳${_formatPrice(maxPrice.round())} /mo',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: t.primary),
                      ),
                    ],
                  ),
                  Slider(
                    value: maxPrice,
                    min: 5000,
                    max: 80000,
                    divisions: 150,
                    activeColor: t.primary,
                    inactiveColor: t.borderSoft,
                    onChanged: (v) => setState(() => maxPrice = v),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('৳5k', style: TextStyle(fontSize: 11, color: t.inkSoft)),
                      Text('৳80k', style: TextStyle(fontSize: 11, color: t.inkSoft)),
                    ],
                  ),
                  const SizedBox(height: 22),
                  _sectionLabel('AMENITIES'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: amenities.entries.map((e) {
                      return GestureDetector(
                        onTap: () => setState(() => amenities[e.key] = !e.value),
                        child: _chip(e.value ? '✓ ${e.key}' : e.key, e.value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),
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
                          onPressed: () => Navigator.pop(context),
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

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: t.inkMid,
        letterSpacing: 0.6,
      ),
    );
  }

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
