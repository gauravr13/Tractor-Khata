import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/localization_service.dart';

class IOSTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const IOSTimePicker({
    super.key,
    required this.initialTime,
    required this.onTimeChanged,
  });

  @override
  State<IOSTimePicker> createState() => _IOSTimePickerState();
}

class _IOSTimePickerState extends State<IOSTimePicker> {
  late int _selectedHour;
  late int _selectedMinute;
  late String _selectedPeriod; // 'AM' or 'PM'
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _periodController;

  @override
  void initState() {
    super.initState();
    final time = widget.initialTime;
    _selectedPeriod = time.period == DayPeriod.am ? 'AM' : 'PM';
    _selectedHour = time.hourOfPeriod;
    if (_selectedHour == 0) _selectedHour = 12;
    _selectedMinute = time.minute;

    _hourController = FixedExtentScrollController(initialItem: _selectedHour - 1);
    _minuteController = FixedExtentScrollController(initialItem: _selectedMinute);
    _periodController = FixedExtentScrollController(initialItem: _selectedPeriod == 'AM' ? 0 : 1);
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _periodController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    int hour = _selectedHour;
    if (_selectedPeriod == 'PM' && hour != 12) hour += 12;
    if (_selectedPeriod == 'AM' && hour == 12) hour = 0;
    
    widget.onTimeChanged(TimeOfDay(hour: hour, minute: _selectedMinute));
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final isHindi = locale.locale.languageCode == 'hi';
    final amLabel = isHindi ? 'पूर्वाह्न' : 'AM';
    final pmLabel = isHindi ? 'अपराह्न' : 'PM';

    return Container(
      height: 250,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                // Selection Overlay
                Center(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Hour Wheel
                    _buildWheel(
                      controller: _hourController,
                      itemCount: 12,
                      width: 60,
                      onChanged: (index) {
                        setState(() {
                          _selectedHour = index + 1;
                          _notifyChange();
                        });
                      },
                      itemBuilder: (index) => Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const Text(':', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.grey)),
                    // Minute Wheel
                    _buildWheel(
                      controller: _minuteController,
                      itemCount: 60,
                      width: 60,
                      onChanged: (index) {
                        setState(() {
                          _selectedMinute = index;
                          _notifyChange();
                        });
                      },
                      itemBuilder: (index) => Center(
                        child: Text(
                          index.toString().padLeft(2, '0'),
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // AM/PM Wheel
                    _buildWheel(
                      controller: _periodController,
                      itemCount: 2,
                      width: 100,
                      onChanged: (index) {
                        setState(() {
                          _selectedPeriod = index == 0 ? 'AM' : 'PM';
                          _notifyChange();
                        });
                      },
                      itemBuilder: (index) => Center(
                        child: Text(
                          index == 0 ? amLabel : pmLabel,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWheel({
    required FixedExtentScrollController controller,
    required int itemCount,
    required double width,
    required ValueChanged<int> onChanged,
    required Widget Function(int) itemBuilder,
  }) {
    return SizedBox(
      width: width,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 50,
        perspective: 0.005,
        diameterRatio: 1.2,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) {
          HapticFeedback.selectionClick();
          onChanged(index);
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            if (index < 0 || index >= itemCount) return null;
            return itemBuilder(index);
          },
          childCount: itemCount,
        ),
      ),
    );
  }
}
