import 'package:flutter/material.dart';

/// Vạch phân cách list — lùi sau artwork, mờ nhẹ (Material 3 / music app).
class InsetListDivider extends StatelessWidget {
  const InsetListDivider({
    super.key,
    this.leadingInset = 80,
    this.endInset = 16,
  });

  /// Mặc định: padding 16 + art 48 + khoảng cách 16.
  final double leadingInset;
  final double endInset;

  @override
  Widget build(BuildContext context) {
    final dividerTheme = Theme.of(context).dividerTheme;
    final color = dividerTheme.color ??
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08);

    return Divider(
      height: 1,
      thickness: dividerTheme.thickness ?? 1,
      indent: leadingInset,
      endIndent: endInset,
      color: color,
    );
  }
}
