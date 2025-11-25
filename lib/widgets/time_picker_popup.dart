// =============================================================================
// PROJECT: Tractor Khata
// FILE: time_picker_popup.dart
// DESCRIPTION:
// A custom, modern 12-hour time picker widget.
// Features:
// 1. iOS-style scroll wheels for Hour and Minute selection.
// 2. Segmented control for AM/PM toggling.
// 3. Smooth animations and haptic feedback for better UX.
// 4. Localized labels (AM/PM, Select Time, etc.).
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/localization_service.dart';

/// ---------------------------------------------------------------------------
/// Widget: TimePickerPopup
/// Purpose: Displays a dialog for selecting time (Hour, Minute, AM/PM).
/// ---------------------------------------------------------------------------
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
    // Initialize with provided time or current time
    final now = TimeOfDay.now();
    final init = widget.initialTime ?? now;
    
    // Convert 24h format to 12h format for the UI
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
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- Title ---
            Text(
              locale.translate('time_picker.select_time'),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 32),

            // --- Wheel Pickers (Hour : Minute) ---
            SizedBox(
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Highlight Bar (Selection Indicator)
                  Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  // Wheels Row
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
                      // Separator Colon
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

            // --- AM/PM Segment Control ---
            _buildAmPmSegment(primaryColor, locale),
            const SizedBox(height: 32),

            // --- Action Buttons (Cancel / OK) ---
            _buildActionButtons(context, primaryColor, locale),
          ],
        ),
      ),
    );
  }

  /// Helper: Builds the Action Buttons Row
  Widget _buildActionButtons(BuildContext context, Color primaryColor, AppLocalizations locale) {
    return Row(
      children: [
        // Cancel Button
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
        // OK Button
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.heavyImpact();
              // Convert back to TimeOfDay (24h format)
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

  /// Helper: Builds a scrollable wheel for numbers
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
        perspective: 0.002, // Slight 3D effect
        diameterRatio: 1.5,
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
                duration: const Duration(milliseconds: 150),
                style: TextStyle(
                  fontSize: isSelected ? 26 : 20,
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

  /// Helper: Builds the AM/PM toggle switch
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
          _buildSegmentOption('AM', 'AM', primaryColor),
          _buildSegmentOption('PM', 'PM', primaryColor),
        ],
      ),
    );
  }

  /// Helper: Builds a single option in the AM/PM segment
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
                ? [BoxShadow(color: primaryColor.withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(0, 2))]
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
