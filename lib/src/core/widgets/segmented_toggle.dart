import 'package:flutter/material.dart';

import '../style/app_colors.dart';
import '../style/app_radii.dart';
import '../style/app_spacing.dart';
import '../style/app_text_styles.dart';

/// A single option for [SegmentedToggle].
class SegmentedItem<T> {
  const SegmentedItem({required this.value, required this.label});
  final T value;
  final String label;
}

/// Generic pill-style segmented control (animated selection).
///
/// Reusable for any 2+ option exclusive choice; the auth screen uses it
/// for Email / Phone.
class SegmentedToggle<T> extends StatelessWidget {
  const SegmentedToggle({
    super.key,
    required this.items,
    required this.selected,
    required this.onChanged,
  });

  final List<SegmentedItem<T>> items;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.toggleTrack,
        borderRadius: AppRadii.toggle,
      ),
      child: Row(
        children: items.map((item) {
          final bool isSelected = item.value == selected;
          return Expanded(
            child: _Segment(
              label: item.label,
              isSelected: isSelected,
              onTap: () => onChanged(item.value),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface : Colors.transparent,
          borderRadius: AppRadii.toggle,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: isSelected
              ? AppTextStyles.toggleSelected
              : AppTextStyles.toggleUnselected,
        ),
      ),
    );
  }
}
