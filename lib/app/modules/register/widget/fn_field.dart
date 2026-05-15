import 'package:flutter/material.dart';
import '../../../theme/flat_nest_theme.dart';

enum FieldState { idle, valid, error, focus }

class FNField extends StatefulWidget {
  final FlatNestTheme t;
  final String? label;
  final String? placeholder;
  final TextEditingController controller;
  final FieldState state;
  final String? error;
  final String? hint;
  final IconData? leadingIcon;
  final Widget? trailing;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? fixedPrefix;
  final bool autoFocus;

  const FNField({
    super.key,
    required this.t,
    this.label,
    this.placeholder,
    required this.controller,
    this.state = FieldState.idle,
    this.error,
    this.hint,
    this.leadingIcon,
    this.trailing,
    this.obscureText = false,
    this.keyboardType,
    this.fixedPrefix,
    this.autoFocus = false,
  });

  @override
  State<FNField> createState() => _FNFieldState();
}

class _FNFieldState extends State<FNField> {
  bool _focused = false;

  Color get _borderColor {
    if (widget.state == FieldState.error) return widget.t.error;
    if (_focused || widget.state == FieldState.focus) return widget.t.primary;
    if (widget.state == FieldState.valid) return widget.t.success.withValues(alpha: 0.6);
    return widget.t.borderSoft;
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.t;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: t.inkMid,
            ),
          ),
          const SizedBox(height: 6),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: t.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _borderColor, width: _focused ? 1.5 : 1.0),
          ),
          child: Row(
            children: [
              if (widget.leadingIcon != null) ...[
                const SizedBox(width: 14),
                Icon(
                  widget.leadingIcon,
                  size: 18,
                  color: _focused ? t.primary : t.inkSoft,
                ),
              ],
              if (widget.fixedPrefix != null) ...[
                const SizedBox(width: 14),
                Text(
                  widget.fixedPrefix!,
                  style: TextStyle(
                    fontSize: 15,
                    color: t.ink,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  autofocus: widget.autoFocus,
                  style: TextStyle(fontSize: 15, color: t.ink),
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    hintStyle: TextStyle(color: t.inkFaint),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: widget.leadingIcon == null && widget.fixedPrefix == null ? 14 : 10,
                      vertical: 14,
                    ),
                  ),
                  onTap: () => setState(() => _focused = true),
                  onTapOutside: (_) => setState(() => _focused = false),
                ),
              ),
              if (widget.state == FieldState.valid && widget.trailing == null)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(Icons.check, color: t.success, size: 18),
                ),
              if (widget.trailing != null)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: widget.trailing,
                ),
            ],
          ),
        ),
        if (widget.error != null || widget.hint != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              if (widget.error != null) ...[
                Icon(Icons.info_outline, size: 12, color: t.error),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  widget.error ?? widget.hint!,
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.error != null ? t.error : t.inkSoft,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
