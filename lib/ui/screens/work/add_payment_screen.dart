import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../data/local/database.dart';
import '../../../core/providers/work_provider.dart';
import '../../components/buttons/scale_button.dart';
import '../../../core/services/localization_service.dart';
import '../../components/dialogs/delete_dialog.dart';

class AddPaymentScreen extends StatefulWidget {
  final int farmerId;
  final Payment? paymentToEdit;

  const AddPaymentScreen({super.key, required this.farmerId, this.paymentToEdit});

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.paymentToEdit != null) {
      _selectedDate = widget.paymentToEdit!.date;
      _amountController.text = widget.paymentToEdit!.amount.toStringAsFixed(0);
      _notesController.text = widget.paymentToEdit!.notes ?? '';
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _savePayment() async {
    final locale = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final amount = double.parse(_amountController.text.trim());
      final workProvider = Provider.of<WorkProvider>(context, listen: false);
      
      if (widget.paymentToEdit != null) {
        // Update existing payment
        final updatedPayment = widget.paymentToEdit!.copyWith(
          amount: amount,
          date: _selectedDate,
          notes: Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
        );
        await workProvider.updatePayment(updatedPayment);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(locale.translate('add_payment.success_update'))));
      } else {
        // Add new payment
        await workProvider.addPayment(
          farmerId: widget.farmerId,
          amount: amount,
          date: _selectedDate,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(locale.translate('add_payment.success_add'))));
      }
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(widget.paymentToEdit != null ? locale.translate('add_payment.title_edit') : locale.translate('add_payment.title_add'))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
              // Date
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
                            Text(locale.translate('add_payment.payment_date'), style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500)),
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
              
              // Amount
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: locale.translate('add_payment.amount_label'),
                  prefixIcon: const Icon(Icons.payments_outlined),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return locale.translate('add_payment.amount_error');
                  if (double.tryParse(value) == null) return locale.translate('add_payment.amount_invalid');
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Notes
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: locale.translate('add_payment.notes_label'),
                  prefixIcon: const Icon(Icons.edit_note_rounded),
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              
              // Save Button
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _savePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSaving 
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)) 
                      : Text(
                          widget.paymentToEdit != null ? locale.translate('add_payment.update_button') : locale.translate('add_payment.save_button'), 
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
                        ),
                ),
              ),
              
              // Delete Button (only when editing)
              if (widget.paymentToEdit != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ScaleButton(
                    onPressed: () async {
                      final confirm = await showDeleteDialog(
                        context,
                        title: locale.translate('farmer_profile.delete_payment_title'),
                        content: locale.translate('farmer_profile.delete_payment_message'),
                      );
                      
                      if (confirm == true) {
                        if (!mounted) return;
                        // ignore: use_build_context_synchronously
                        await Provider.of<WorkProvider>(context, listen: false).deletePayment(widget.paymentToEdit!);
                        
                        if (!mounted) return;
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(locale.translate('farmer_profile.delete_payment_message'))),
                        );
                      }
                    },
                    child: OutlinedButton.icon(
                      onPressed: null, // Handled by ScaleButton
                      icon: const Icon(Icons.delete_rounded, color: Colors.red),
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
}
