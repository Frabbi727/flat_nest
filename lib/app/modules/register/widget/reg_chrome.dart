import 'package:flutter/material.dart';
import '../../../theme/flat_nest_theme.dart';

class RegChrome extends StatelessWidget {
  final FlatNestTheme t;
  final int step;
  final VoidCallback onBack;
  final String title;
  final String? subtitle;
  final Widget child;

  static const _labels = ['Account', 'About you', 'Avatar'];

  const RegChrome({
    super.key,
    required this.t,
    required this.step,
    required this.onBack,
    required this.title,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: t.bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 24, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: onBack,
                    icon: Icon(Icons.arrow_back_ios_new, color: t.ink, size: 18),
                  ),
                  const Spacer(),
                  Text(
                    'Step ${step + 1} of ${_labels.length}',
                    style: TextStyle(
                      fontSize: 12,
                      color: t.inkSoft,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Stepper bars
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: List.generate(_labels.length, (i) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i < _labels.length - 1 ? 8 : 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: i <= step ? t.primary : t.borderSoft,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _labels[i],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: i == step ? FontWeight.w700 : FontWeight.w500,
                              color: i == step
                                  ? t.primary
                                  : i < step
                                      ? t.inkMid
                                      : t.inkSoft,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: t.ink,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 14,
                          color: t.inkMid,
                          height: 1.5,
                        ),
                      ),
                    ],
                    child,
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
