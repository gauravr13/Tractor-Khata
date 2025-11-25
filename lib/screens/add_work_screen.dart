import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' hide Column;
import '../database/database.dart';
import '../providers/work_provider.dart';
import '../widgets/time_picker_popup.dart';
import '../services/localization_service.dart';

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
  String _totalTimeText = '';
  bool _isSaving = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkProvider>(context, listen: false).loadWorkTypes();
      _initializeForEdit();
    });
  }

  void _initializeForEdit() {
    if (widget.workToEdit == null) return;
    final work = widget.workToEdit!;
    setState(() {
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
      _calculateTotalTime();
    });
  }

  @override
  void dispose() {
    _customWorkNameController.dispose();
    _rateController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    _animationController.dispose();
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
    final locale = AppLocalizations.of(context)!;
    if (_startTime == null || _endTime == null) {
      setState(() {
        _totalTimeText = '';
        _amountController.text = '';
      });
      return;
    }

    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day, _startTime!.hour, _startTime!.minute);
    var end = DateTime(now.year, now.month, now.day, _endTime!.hour, _endTime!.minute);

    if (end.isBefore(start)) {
      end = end.add(const Duration(days: 1));
    }

    final durationInMinutes = end.difference(start).inMinutes;
    final hours = durationInMinutes ~/ 60;
    final minutes = durationInMinutes % 60;

    setState(() {
      if (hours > 0 && minutes > 0) {
        _totalTimeText = '${locale.translate('add_work.total_time')}: $hours ${locale.translate('add_work.hours')} $minutes ${locale.translate('add_work.minutes')}';
      } else if (hours > 0) {
        _totalTimeText = '${locale.translate('add_work.total_time')}: $hours ${locale.translate('add_work.hours')}';
      } else if (minutes > 0) {
        _totalTimeText = '${locale.translate('add_work.total_time')}: $minutes ${locale.translate('add_work.minutes')}';
      } else {
        _totalTimeText = '';
      }
      if (_totalTimeText.isNotEmpty) _animationController.forward();
    });

    _calculateTotalAmount(durationInMinutes);
  }

  void _calculateTotalAmount(int durationInMinutes) {
    final rate = double.tryParse(_rateController.text.trim()) ?? 0.0;
    final total = (durationInMinutes / 60.0) * rate;
    _amountController.text = total.toStringAsFixed(0);
  }

  Future<void> _pickTime(bool isStart) async {
    final initial = isStart ? _startTime : _endTime;
    // Open the new separate TimePickerPopup
    final result = await showDialog<TimeOfDay>(
      context: context,
      builder: (context) => TimePickerPopup(initialTime: initial),
    );
    
    if (result != null) {
      setState(() {
        if (isStart) {
          _startTime = result;
        } else {
          _endTime = result;
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 1. Date
              ListTile(
                title: Text(locale.translate('add_work.work_date')),
                subtitle: Text(DateFormat('dd MMM yyyy').format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
                shape: RoundedRectangleBorder(side: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
              ),
              const SizedBox(height: 16),

              // 2. Work Type
              DropdownButtonFormField<int>(
                value: _selectedWorkTypeId,
                decoration: InputDecoration(labelText: locale.translate('add_work.work_type_label'), prefixIcon: const Icon(Icons.work), border: const OutlineInputBorder()),
                items: [
                  ...workProvider.workTypes.map((t) => DropdownMenuItem(value: t.id, child: Text(t.name))),
                  DropdownMenuItem(value: -1, child: Text('+ ${locale.translate('add_work.custom_work_name')}')),
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
                validator: (val) => !_isCustomWork && (val == null || val == -1) ? locale.translate('add_work.select_work_type_error') : null,
              ),
              const SizedBox(height: 16),

              if (_isCustomWork) ...[
                TextFormField(
                  controller: _customWorkNameController,
                  decoration: InputDecoration(labelText: locale.translate('add_work.custom_work_name'), prefixIcon: const Icon(Icons.edit), border: const OutlineInputBorder()),
                  validator: (val) => _isCustomWork && (val == null || val.trim().isEmpty) ? locale.translate('add_work.enter_custom_name_error') : null,
                ),
                const SizedBox(height: 16),
              ],

              // 3. Start Time (Tappable Container)
              _buildTimeContainer(locale.translate('add_work.start_time'), _startTime, () => _pickTime(true)),
              const SizedBox(height: 16),

              // 4. End Time (Tappable Container)
              _buildTimeContainer(locale.translate('add_work.end_time'), _endTime, () => _pickTime(false)),
              const SizedBox(height: 16),

              // 5. Total Time
              if (_totalTimeText.isNotEmpty)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green.shade300)),
                    child: Row(children: [const Icon(Icons.timer, color: Colors.green), const SizedBox(width: 10), Text(_totalTimeText, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green.shade800))]),
                  ),
                ),
              if (_totalTimeText.isNotEmpty) const SizedBox(height: 16),

              // 6. Rate
              TextFormField(
                controller: _rateController,
                decoration: InputDecoration(labelText: locale.translate('add_work.rate_per_hour'), prefixIcon: const Icon(Icons.currency_rupee), prefixText: '₹ ', border: const OutlineInputBorder()),
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
                decoration: InputDecoration(labelText: locale.translate('add_work.total_amount'), prefixIcon: const Icon(Icons.account_balance_wallet), prefixText: '₹ ', border: const OutlineInputBorder(), filled: true, fillColor: const Color(0xFFE8F5E9)),
                keyboardType: TextInputType.number,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.green),
              ),
              const SizedBox(height: 16),

              // 8. Notes
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(labelText: locale.translate('add_work.notes'), prefixIcon: const Icon(Icons.note), border: const OutlineInputBorder()),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // 9. Save
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveWork,
                  child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : Text(widget.workToEdit != null ? locale.translate('add_work.update_button') : locale.translate('add_work.save_button'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              
              // 10. Delete Button (only when editing)
              if (widget.workToEdit != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(locale.translate('farmer_profile.delete_work_title')),
                          content: Text(locale.translate('farmer_profile.delete_work_message')),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text(locale.translate('common.cancel')),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text(locale.translate('common.delete'), style: const TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                      
                      if (confirm == true && mounted) {
                        await Provider.of<WorkProvider>(context, listen: false).deleteWork(widget.workToEdit!);
                        if (mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(locale.translate('farmer_profile.delete_work_message'))),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: Text(locale.translate('common.delete'), style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// A completely custom tappable container for time selection.
  /// NOT a text field.
  Widget _buildTimeContainer(String label, TimeOfDay? time, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(label.contains('Start') ? Icons.access_time : Icons.access_time_filled, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(
                    time != null ? _formatTime(time) : 'Tap to select',
                    style: TextStyle(fontSize: 18, color: time != null ? Colors.black : Colors.grey[500], fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
