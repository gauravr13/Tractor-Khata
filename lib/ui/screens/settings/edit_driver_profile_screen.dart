import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import '../../../core/providers/driver_provider.dart';
import '../../../core/services/localization_service.dart';

class EditDriverProfileScreen extends StatefulWidget {
  const EditDriverProfileScreen({super.key});

  @override
  State<EditDriverProfileScreen> createState() => _EditDriverProfileScreenState();
}

class _EditDriverProfileScreenState extends State<EditDriverProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  String? _photoPath;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<DriverProvider>(context, listen: false).profile;
    _nameController = TextEditingController(text: profile.name);
    _phoneController = TextEditingController(text: profile.phone ?? '');
    _emailController = TextEditingController(text: profile.email ?? '');
    _photoPath = profile.photoPath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }



  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.green,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
          ),
        ],
      );

      if (croppedFile != null) {
        final compressedPath = await _compressAndSaveImage(croppedFile.path);
        setState(() => _photoPath = compressedPath);
      }
    }
  }

  Future<String> _compressAndSaveImage(String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) return imagePath;

    final resized = img.copyResize(image, width: 400);
    final compressed = img.encodeJpg(resized, quality: 75);

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/driver_profile_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await file.writeAsBytes(compressed);

    return file.path;
  }

  void _showPhotoOptions() {
    final locale = AppLocalizations.of(context)!;
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.green, size: 32),
              title: Text(locale.translate('driver_profile.take_photo'), style: const TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green, size: 32),
              title: Text(locale.translate('driver_profile.choose_gallery'), style: const TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_photoPath != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red, size: 32),
                title: Text(locale.translate('driver_profile.remove_photo'), style: const TextStyle(fontSize: 18, color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _photoPath = null);
                },
              ),
          ],
        ),
      ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final locale = AppLocalizations.of(context)!;

    try {
      await Provider.of<DriverProvider>(context, listen: false).updateProfile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        photoPath: _photoPath,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(locale.translate('driver_profile.profile_updated'))),
      );
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

    ImageProvider? backgroundImage;
    if (_photoPath != null) {
      if (_photoPath!.startsWith('http')) {
        backgroundImage = NetworkImage(_photoPath!);
      } else if (File(_photoPath!).existsSync()) {
        backgroundImage = FileImage(File(_photoPath!));
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(locale.translate('driver_profile.edit_profile'))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _showPhotoOptions,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.green, width: 4),
                        ),
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.green.shade100,
                          backgroundImage: backgroundImage,
                          child: _photoPath == null
                              ? Icon(Icons.person, size: 80, color: Colors.green.shade700)
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 24),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: locale.translate('driver_profile.driver_name'),
                    prefixIcon: const Icon(Icons.person),
                    border: const OutlineInputBorder(),
                  ),
                  style: const TextStyle(fontSize: 18),
                  validator: (val) => val == null || val.trim().isEmpty ? locale.translate('driver_profile.driver_name_error') : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: locale.translate('driver_profile.phone_hint'),
                    prefixIcon: const Icon(Icons.phone),
                    border: const OutlineInputBorder(),
                  ),
                  style: const TextStyle(fontSize: 18),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  readOnly: true, // Email is read-only
                  decoration: InputDecoration(
                    labelText: locale.translate('driver_profile.email_hint'),
                    prefixIcon: const Icon(Icons.email),
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveProfile,
                    child: _isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(locale.translate('driver_profile.save_profile'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
