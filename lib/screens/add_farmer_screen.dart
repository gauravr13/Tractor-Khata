import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' hide Column;
import '../database/database.dart';
import '../providers/farmer_provider.dart';
import '../services/localization_service.dart';
import '../widgets/scale_button.dart';
import '../widgets/animated_bottom_sheet.dart';

class AddFarmerScreen extends StatefulWidget {
  final Farmer? farmerToEdit;

  final bool isBottomSheet;

  const AddFarmerScreen({super.key, this.farmerToEdit, this.isBottomSheet = false});

  @override
  State<AddFarmerScreen> createState() => _AddFarmerScreenState();
}

class _AddFarmerScreenState extends State<AddFarmerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.farmerToEdit != null) {
      _nameController.text = widget.farmerToEdit!.name;
      _phoneController.text = widget.farmerToEdit!.phone ?? '';
      _notesController.text = widget.farmerToEdit!.notes ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveFarmer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final locale = AppLocalizations.of(context)!;

    try {
      final farmerProvider = Provider.of<FarmerProvider>(context, listen: false);

      if (widget.farmerToEdit != null) {
        final updatedFarmer = widget.farmerToEdit!.copyWith(
          name: _nameController.text.trim(),
          phone: Value(_phoneController.text.trim().isEmpty ? null : _phoneController.text.trim()),
          notes: Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
        );
        await farmerProvider.updateFarmer(updatedFarmer);
        
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(locale.translate('add_farmer.success_update'))),
        );
      } else {
        await farmerProvider.addFarmer(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        );
        
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(locale.translate('add_farmer.success_add'))),
        );
      }

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final isEditing = widget.farmerToEdit != null;
    final title = isEditing ? locale.translate('add_farmer.title_edit') : locale.translate('add_farmer.title_add');

    final formContent = Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: locale.translate('add_farmer.name_label'),
              hintText: locale.translate('add_farmer.name_hint'),
              prefixIcon: const Icon(Icons.person_rounded),
              border: const OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            style: const TextStyle(fontSize: 16),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return locale.translate('add_farmer.name_error');
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: locale.translate('add_farmer.phone_label'),
              hintText: locale.translate('add_farmer.phone_hint'),
              prefixIcon: const Icon(Icons.phone_rounded),
              border: const OutlineInputBorder(),
            ),
            style: const TextStyle(fontSize: 16),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _notesController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: locale.translate('add_farmer.notes_label'),
              hintText: locale.translate('add_farmer.notes_hint'),
              prefixIcon: const Icon(Icons.edit_note_rounded),
              border: const OutlineInputBorder(),
            ),
            style: const TextStyle(fontSize: 16),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ScaleButton(
              onPressed: _isSaving ? null : _saveFarmer,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveFarmer,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        isEditing ? locale.translate('add_farmer.update_button') : locale.translate('add_farmer.save_button'),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
              ),
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
                bottom: MediaQuery.of(context).viewInsets.bottom + 16, // Keyboard + padding
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
                    
                    // Form Content
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
