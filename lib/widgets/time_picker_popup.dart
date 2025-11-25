import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/localization_service.dart';

/// A premium, modern 12-hour time picker popup.
/// Features:
/// - iOS-style scroll wheels for Hour and Minute
/// - Segmented control for AM/PM
/// - Clean, spacious layout with rounded corners
/// - Smooth animations and haptic feedback
class TimePickerPopup extends StatefulWidget {
  final TimeOfDay? initialTime;

  const TimePickerPopup({super.key, this.initialTime});

  @override
  State<TimePickerPopup> createState() => _TimePickerPopupState();
}

class _TimePickerPopupState extends State<TimePickerPopup> {
  late int _hour;
  late int _minute;
  late String _period;

  @override
  void initState() {
    super.initState();
    final now = TimeOfDay.now();
    final init = widget.initialTime ?? now;
    _hour = init.hourOfPeriod == 0 ? 12 : init.hourOfPeriod;
    _minute = init.minute;
    _period = init.period == DayPeriod.am ? 'AM' : 'PM';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final locale = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 16, // Reduced blur for performance
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Title
            Text(
              locale.translate('time_picker.select_time'),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 32),

            // 2. Wheel Pickers (Hour : Minute)
            SizedBox(
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Highlight Bar
                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  // Wheels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Hour Wheel
                      _buildWheel(
                        min: 1,
                        max: 12,
                        current: _hour,
                        onChanged: (val) => setState(() => _hour = val),
                        width: 70,
                      ),
                      // Separator
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          ':',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade400,
                            height: 1.0, 
                          ),
                        ),
                      ),
                      // Minute Wheel
                      _buildWheel(
                        min: 0,
                        max: 59,
                        current: _minute,
                        onChanged: (val) => setState(() => _minute = val),
                        width: 70,
                        padZero: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. AM/PM Segment
            _buildAmPmSegment(primaryColor, locale),
            const SizedBox(height: 32),

            // 4. Action Buttons
            _buildActionButtons(context, primaryColor, locale),
          ],
        ),
      ),
    );
  }

  /// Action Buttons (Cancel / OK)
  Widget _buildActionButtons(BuildContext context, Color primaryColor, AppLocalizations locale) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              foregroundColor: Colors.grey.shade600,
            ),
            child: Text(
              locale.translate('common.cancel'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.heavyImpact();
              final time = TimeOfDay(
                hour: _period == 'AM'
                    ? (_hour == 12 ? 0 : _hour)
                    : (_hour == 12 ? 12 : _hour + 12),
                minute: _minute,
              );
              Navigator.of(context).pop(time);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              locale.translate('common.ok'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  /// Scrollable Wheel Widget
  Widget _buildWheel({
    required int min,
    required int max,
    required int current,
    required Function(int) onChanged,
    required double width,
    bool padZero = false,
  }) {
    return SizedBox(
      width: width,
      height: 160,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 50,
        perspective: 0.002, // Reduced perspective for performance
        diameterRatio: 1.5, // Flatter for better visibility
        physics: const FixedExtentScrollPhysics(),
        useMagnifier: true,
        magnification: 1.1,
        controller: FixedExtentScrollController(initialItem: current - min),
        onSelectedItemChanged: (index) {
          HapticFeedback.selectionClick();
          onChanged(min + index);
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            final val = min + index;
            final isSelected = val == current;
            return Center(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150), // Faster animation
                style: TextStyle(
                  fontSize: isSelected ? 26 : 20, // Slightly smaller
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
                ),
                child: Text(
                  padZero ? val.toString().padLeft(2, '0') : val.toString(),
                ),
              ),
            );
          },
          childCount: max - min + 1,
        ),
      ),
    );
  }

  /// AM/PM Segmented Control
  Widget _buildAmPmSegment(Color primaryColor, AppLocalizations locale) {
    return Container(
      height: 48,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          _buildSegmentOption(locale.translate('time_picker.am'), 'AM', primaryColor),
          _buildSegmentOption(locale.translate('time_picker.pm'), 'PM', primaryColor),
        ],
      ),
    );
  }

  Widget _buildSegmentOption(String label, String value, Color primaryColor) {
    final isSelected = _period == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          setState(() => _period = value);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}
