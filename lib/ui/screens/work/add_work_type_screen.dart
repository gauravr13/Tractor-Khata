import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/work_provider.dart';
import '../../../core/services/localization_service.dart';
import '../../components/dialogs/animated_bottom_sheet.dart';

/// Add Work Type Screen.
/// Form to add a new work type to the Rate Card.
class AddWorkTypeScreen extends StatefulWidget {
  final bool isBottomSheet;
  const AddWorkTypeScreen({super.key, this.isBottomSheet = false});

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
    final title = locale.translate('add_work_type.title_add');

    final formContent = Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Work Name Field
          TextFormField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: locale.translate('add_work_type.name_label'),
              prefixIcon: const Icon(Icons.agriculture_rounded, color: Colors.blue),
              border: const OutlineInputBorder(),
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
              prefixIcon: const Icon(Icons.payments_outlined),
              border: const OutlineInputBorder(),
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
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveWorkType,
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(locale.translate('add_work_type.save_button'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );

    if (widget.isBottomSheet) {
      return AnimatedBottomSheetContent(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                left: 20,
                right: 20,
                top: 12,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag Handle
                    Center(
                      child: Container(
                        width: 48,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Title
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    formContent,
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(children: [formContent]),
        ),
      ),
    );
  }
}
