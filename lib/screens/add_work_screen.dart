import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' hide Column;
import '../database/database.dart';
import '../providers/work_provider.dart';
import '../widgets/time_picker_popup.dart';
import '../widgets/scale_button.dart';
import '../services/localization_service.dart';
import '../widgets/delete_dialog.dart';

/// Add Work Screen - Final Rebuild
/// Uses strictly tappable containers for time input.
/// No text fields for time.
class AddWorkScreen extends StatefulWidget {
  final int farmerId;
  final Work? workToEdit;

  const AddWorkScreen({super.key, required this.farmerId, this.workToEdit});

  @override
  State<AddWorkScreen> createState() => _AddWorkScreenState();
}

class _AddWorkScreenState extends State<AddWorkScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  
  // Text Controllers (ONLY for non-time fields)
  final _customWorkNameController = TextEditingController();
  final _rateController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  // State
  int? _selectedWorkTypeId;
  String _selectedWorkTypeName = '';
  bool _isCustomWork = false;
  DateTime _selectedDate = DateTime.now();
  
  // Time State (Strictly TimeOfDay objects)
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  
  // Display Helpers
  bool _isSaving = false;
  
  @override
  void initState() {
    super.initState();

    if (widget.workToEdit != null) {
      final work = widget.workToEdit!;
      _selectedDate = work.workDate;
      _startTime = TimeOfDay.fromDateTime(work.startTime);
      _endTime = TimeOfDay.fromDateTime(work.endTime);
      _rateController.text = work.ratePerHour.toStringAsFixed(0);
      _amountController.text = work.totalAmount.toStringAsFixed(0);
      _notesController.text = work.notes ?? '';
      
      if (work.workTypeId != null) {
        _selectedWorkTypeId = work.workTypeId;
        _isCustomWork = false;
      } else {
        _selectedWorkTypeId = -1;
        _isCustomWork = true;
        _customWorkNameController.text = work.customWorkName ?? '';
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkProvider>(context, listen: false).loadWorkTypes();
    });
  }

  @override
  void dispose() {
    _customWorkNameController.dispose();
    _rateController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // ---------- Time Logic ----------

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void _calculateTotalTime() {
    if (_startTime == null || _endTime == null) {
      _amountController.text = '';
      return;
    }

    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day, _startTime!.hour, _startTime!.minute);
    var end = DateTime(now.year, now.month, now.day, _endTime!.hour, _endTime!.minute);

    if (end.isBefore(start)) {
      end = end.add(const Duration(days: 1));
    }

    final durationInMinutes = end.difference(start).inMinutes;
    _calculateTotalAmount(durationInMinutes);
  }

  void _calculateTotalAmount(int durationInMinutes) {
    final rate = double.tryParse(_rateController.text.trim()) ?? 0.0;
    final total = (durationInMinutes / 60.0) * rate;
    _amountController.text = total.toStringAsFixed(0);
  }

  Future<void> _pickTime(bool isStart) async {
    final locale = AppLocalizations.of(context)!;
    final initial = isStart ? (_startTime ?? TimeOfDay.now()) : (_endTime ?? TimeOfDay.now());
    
    final picked = await showTimePickerPopup(
      context: context,
      initialTime: initial,
      isHindi: locale.locale.languageCode == 'hi',
    );
    
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
        _calculateTotalTime();
      });
    }
  }

  Future<void> _saveWork() async {
    final locale = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(locale.translate('add_work.select_start_time_error'))),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final startDateTime = DateTime(
        _selectedDate.year, _selectedDate.month, _selectedDate.day,
        _startTime!.hour, _startTime!.minute,
      );
      var endDateTime = DateTime(
        _selectedDate.year, _selectedDate.month, _selectedDate.day,
        _endTime!.hour, _endTime!.minute,
      );

      if (endDateTime.isBefore(startDateTime)) {
        endDateTime = endDateTime.add(const Duration(days: 1));
      }

      final durationInMinutes = endDateTime.difference(startDateTime).inMinutes;
      final ratePerHour = double.parse(_rateController.text.trim());
      final totalAmount = double.tryParse(_amountController.text.trim()) ?? 
                          ((durationInMinutes / 60.0) * ratePerHour);

      final workProvider = Provider.of<WorkProvider>(context, listen: false);

      if (widget.workToEdit != null) {
        final updatedWork = widget.workToEdit!.copyWith(
          workTypeId: Value(_isCustomWork ? null : _selectedWorkTypeId),
          customWorkName: Value(_isCustomWork ? _customWorkNameController.text.trim() : null),
          startTime: startDateTime,
          endTime: endDateTime,
          durationInMinutes: durationInMinutes,
          ratePerHour: ratePerHour,
          totalAmount: totalAmount,
          workDate: _selectedDate,
          notes: Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
        );
        await workProvider.updateWork(updatedWork);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(locale.translate('add_work.success_update'))));
      } else {
        await workProvider.addWork(
          farmerId: widget.farmerId,
          workTypeId: _isCustomWork ? null : _selectedWorkTypeId,
          customWorkName: _isCustomWork ? _customWorkNameController.text.trim() : null,
          startTime: startDateTime,
          endTime: endDateTime,
          ratePerHour: ratePerHour,
          workDate: _selectedDate,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(locale.translate('add_work.success_add'))));
      }
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final workProvider = Provider.of<WorkProvider>(context);
    
    if (!_isCustomWork && _selectedWorkTypeId != null) {
      final match = workProvider.workTypes.where((t) => t.id == _selectedWorkTypeId);
      _selectedWorkTypeName = match.isNotEmpty ? match.first.name : '';
    }
    final title = widget.workToEdit != null 
        ? locale.translate('add_work.title_edit') 
        : '${locale.translate('add_work.title_add')}${_selectedWorkTypeName.isNotEmpty && !_isCustomWork ? ' – $_selectedWorkTypeName' : ''}';

    return Scaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: SlideTransition(position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(anim), child: child)),
          child: Text(title, key: ValueKey(title)),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24), // Extra padding for buttons
              children: [
              // 1. Date
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month_rounded, color: Colors.green.shade600, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(locale.translate('add_work.work_date'), style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('dd MMM yyyy').format(_selectedDate),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Work Type
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: (_selectedWorkTypeId != null && 
                            (workProvider.workTypes.any((t) => t.id == _selectedWorkTypeId) || _selectedWorkTypeId == -1))
                        ? _selectedWorkTypeId 
                        : null,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.green, size: 28),
                    hint: Text(locale.translate('add_work.work_type_label'), style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                    borderRadius: BorderRadius.circular(16),
                    dropdownColor: Colors.white,
                    style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
                    items: [
                      ...workProvider.workTypes.map((t) => DropdownMenuItem(
                        value: t.id, 
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.agriculture, size: 20, color: Colors.blue.shade700),
                            ),
                            const SizedBox(width: 12),
                            Text(t.name),
                          ],
                        ),
                      )),
                      DropdownMenuItem(
                        value: -1, 
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.edit, size: 20, color: Colors.blue.shade700),
                            ),
                            const SizedBox(width: 12),
                            Text(locale.translate('add_work.custom_work_name'), style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() {
                        if (val == -1) {
                          _isCustomWork = true;
                          _selectedWorkTypeId = null;
                          _rateController.clear();
                        } else {
                          _isCustomWork = false;
                          _selectedWorkTypeId = val;
                          try {
                            final type = workProvider.workTypes.firstWhere((t) => t.id == val);
                            _rateController.text = type.ratePerHour.toStringAsFixed(0);
                            if (_startTime != null && _endTime != null) _calculateTotalTime();
                          } catch (_) {}
                        }
                        if (!_isCustomWork) _customWorkNameController.clear();
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              if (_isCustomWork) ...[
                TextFormField(
                  controller: _customWorkNameController,
                  decoration: InputDecoration(
                    labelText: locale.translate('add_work.custom_work_name'), 
                    prefixIcon: Icon(Icons.agriculture, color: Colors.blue.shade700), 
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (val) => _isCustomWork && (val == null || val.trim().isEmpty) ? locale.translate('add_work.enter_custom_name_error') : null,
                ),
                const SizedBox(height: 16),
              ],

              // 3. Start Time & End Time Row
              Row(
                children: [
                  Expanded(child: _buildTimeContainer(locale.translate('add_work.start_time'), _startTime, () => _pickTime(true))),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTimeContainer(locale.translate('add_work.end_time'), _endTime, () => _pickTime(false))),
                ],
              ),
              const SizedBox(height: 16),

              // 5. Total Time
              Builder(
                builder: (context) {
                  String totalTimeText = '--';
                  
                  if (_startTime != null && _endTime != null) {
                    final now = DateTime.now();
                    final start = DateTime(now.year, now.month, now.day, _startTime!.hour, _startTime!.minute);
                    var end = DateTime(now.year, now.month, now.day, _endTime!.hour, _endTime!.minute);

                    if (end.isBefore(start)) {
                      end = end.add(const Duration(days: 1));
                    }

                    final durationInMinutes = end.difference(start).inMinutes;
                    final hours = durationInMinutes ~/ 60;
                    final minutes = durationInMinutes % 60;
                    
                    if (hours > 0 && minutes > 0) {
                      totalTimeText = '$hours ${locale.translate('add_work.hours')} $minutes ${locale.translate('add_work.minutes')}';
                    } else if (hours > 0) {
                      totalTimeText = '$hours ${locale.translate('add_work.hours')}';
                    } else if (minutes > 0) {
                      totalTimeText = '$minutes ${locale.translate('add_work.minutes')}';
                    }
                  }

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50, 
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade100),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(locale.translate('add_work.total_time'), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.green.shade800)),
                        Row(
                          children: [
                            Icon(Icons.timer, size: 18, color: Colors.green.shade700),
                            const SizedBox(width: 8),
                            Text(totalTimeText, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green.shade900)),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              ),
              const SizedBox(height: 16),

              // 6. Rate
              TextFormField(
                controller: _rateController,
                decoration: InputDecoration(
                  labelText: locale.translate('add_work.rate_per_hour'), 
                  prefixIcon: const Icon(Icons.payments_outlined), 
                  prefixText: '₹ ', 
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) {
                  if (_startTime != null && _endTime != null) _calculateTotalTime();
                },
                validator: (val) => val == null || val.isEmpty ? locale.translate('add_work.enter_rate_error') : null,
              ),
              const SizedBox(height: 16),

              // 7. Amount
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: locale.translate('add_work.total_amount'), 
                  prefixIcon: const Icon(Icons.wallet_rounded), 
                  prefixText: '₹ ', 
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                  filled: true, 
                  fillColor: const Color(0xFFE8F5E9),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 16),

              // 8. Notes
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: locale.translate('add_work.notes'), 
                  prefixIcon: const Icon(Icons.edit_note_rounded), 
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // 9. Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ScaleButton(
                  onPressed: _isSaving ? null : _saveWork,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveWork,
                    child: _isSaving 
                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)) 
                        : Text(
                            widget.workToEdit != null ? locale.translate('add_work.update_button') : locale.translate('add_work.save_button'),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              ),
              
              // Delete Button (only when editing)
              if (widget.workToEdit != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ScaleButton(
                    onPressed: () async {
                      final confirm = await showDeleteDialog(
                        context,
                        title: locale.translate('farmer_profile.delete_work_title'),
                        content: locale.translate('farmer_profile.delete_work_message'),
                      );
                      
                      if (confirm == true) {
                        if (!mounted) return;
                        await Provider.of<WorkProvider>(context, listen: false).deleteWork(widget.workToEdit!);
                        
                        if (!mounted) return;
                        Navigator.pop(context);
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(locale.translate('farmer_profile.delete_work_message'))),
                        );
                      }
                    },
                    child: OutlinedButton.icon(
                      onPressed: null, // Handled by ScaleButton
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: Text(locale.translate('common.delete'), style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      ),
    );
  }

  /// A completely custom tappable container for time selection.
  /// NOT a text field.
  Widget _buildTimeContainer(String label, TimeOfDay? time, VoidCallback onTap) {
    final isStart = label.contains('Start') || label.contains('शुरू');
    final iconColor = isStart ? Colors.green.shade600 : Colors.red.shade600;
    final icon = isStart ? Icons.play_circle_outline : Icons.stop_circle_outlined;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 95, 
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      time != null ? _formatTime(time) : '--:--',
                      style: TextStyle(
                        fontSize: 18, 
                        color: time != null ? Colors.black87 : Colors.grey[400], 
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
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
}
