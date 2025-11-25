import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/work_provider.dart';
import '../services/localization_service.dart';

/// Add Work Type Screen.
/// Form to add a new work type to the Rate Card.
class AddWorkTypeScreen extends StatefulWidget {
  const AddWorkTypeScreen({super.key});

  @override
  State<AddWorkTypeScreen> createState() => _AddWorkTypeScreenState();
}

class _AddWorkTypeScreenState extends State<AddWorkTypeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _rateController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  Future<void> _saveWorkType() async {
    final locale = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final rate = double.parse(_rateController.text.trim());
      await Provider.of<WorkProvider>(context, listen: false).addWorkType(
        name: _nameController.text.trim(),
        ratePerHour: rate,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(locale.translate('add_work_type.success_add'))));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding work type: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(locale.translate('add_work_type.title_add')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Work Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: locale.translate('add_work_type.name_label'),
                  prefixIcon: const Icon(Icons.work),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return locale.translate('add_work_type.name_error');
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Rate Field
              TextFormField(
                controller: _rateController,
                decoration: InputDecoration(
                  labelText: locale.translate('add_work_type.rate_label'),
                  prefixIcon: const Icon(Icons.currency_rupee),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return locale.translate('add_work_type.rate_error');
                  }
                  if (double.tryParse(value) == null) {
                    return locale.translate('add_work_type.rate_error');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveWorkType,
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(locale.translate('add_work_type.save_button'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
