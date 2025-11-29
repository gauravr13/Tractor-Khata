import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Non-editable time picker with wheel selectors
/// Hour (1-12), Minute (00-59), AM/PM toggle
class TimePickerPopup extends StatefulWidget {
  final TimeOfDay initialTime;
  final bool isHindi;
  
  const TimePickerPopup({
    super.key,
    required this.initialTime,
    this.isHindi = true,
  });
  
  @override
  State<TimePickerPopup> createState() => _TimePickerPopupState();
}

class _TimePickerPopupState extends State<TimePickerPopup> {
  late int selectedHour;
  late int selectedMinute;
  late bool isAM;
  
  @override
  void initState() {
    super.initState();
    selectedHour = widget.initialTime.hourOfPeriod == 0 ? 12 : widget.initialTime.hourOfPeriod;
    selectedMinute = widget.initialTime.minute;
    isAM = widget.initialTime.period == DayPeriod.am;
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 16),
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
            
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                widget.isHindi ? 'समय चुनें' : 'Select Time',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Time selectors container
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200, width: 1.5),
                ),
                child: Row(
                  children: [
                    // Hour picker
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedHour - 1,
                        ),
                        itemExtent: 56,
                        onSelectedItemChanged: (index) {
                          setState(() => selectedHour = index + 1);
                        },
                        children: List.generate(12, (index) {
                          return Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    
                    // Separator
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        ':',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    
                    // Minute picker
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedMinute,
                        ),
                        itemExtent: 56,
                        onSelectedItemChanged: (index) {
                          setState(() => selectedMinute = index);
                        },
                        children: List.generate(60, (index) {
                          return Center(
                            child: Text(
                              index.toString().padLeft(2, '0'),
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    
                    const SizedBox(width: 8),
                    
                    // AM/PM selector
                    Container(
                      width: 80,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildPeriodButton('AM', isAM),
                          const SizedBox(height: 16),
                          _buildPeriodButton('PM', !isAM),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Action buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        widget.isHindi ? 'रद्द करें' : 'Cancel',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        int hour24 = selectedHour == 12 ? 0 : selectedHour;
                        if (!isAM) hour24 += 12;
                        if (hour24 == 24) hour24 = 12;
                        
                        final time = TimeOfDay(hour: hour24, minute: selectedMinute);
                        Navigator.pop(context, time);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        widget.isHindi ? 'ठीक है' : 'OK',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPeriodButton(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isAM = label == 'AM';
        });
      },
      child: Container(
        width: 64,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}

/// Show time picker popup
Future<TimeOfDay?> showTimePickerPopup({
  required BuildContext context,
  required TimeOfDay initialTime,
  bool isHindi = true,
}) async {
  return await showModalBottomSheet<TimeOfDay>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.4),
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    builder: (context) => TimePickerPopup(
      initialTime: initialTime,
      isHindi: isHindi,
    ),
  );
}
