import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/driver_provider.dart';
import '../services/localization_service.dart';
import 'edit_driver_profile_screen.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.translate('driver_profile.title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditDriverProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<DriverProvider>(
        builder: (context, driverProvider, child) {
          final profile = driverProvider.profile;

          ImageProvider? backgroundImage;
          if (profile.photoPath != null) {
            if (profile.photoPath!.startsWith('http')) {
              backgroundImage = NetworkImage(profile.photoPath!);
            } else if (File(profile.photoPath!).existsSync()) {
              backgroundImage = FileImage(File(profile.photoPath!));
            }
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green, width: 4),
                    ),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.green.shade100,
                      backgroundImage: backgroundImage,
                      child: profile.photoPath == null
                          ? Icon(Icons.person, size: 80, color: Colors.green.shade700)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  profile.name,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),

                if (profile.phone != null && profile.phone!.isNotEmpty)
                  _buildInfoCard(
                    icon: Icons.phone,
                    label: locale.translate('driver_profile.phone_number'),
                    value: profile.phone!,
                  ),

                if (profile.email != null && profile.email!.isNotEmpty)
                  _buildInfoCard(
                    icon: Icons.email,
                    label: locale.translate('driver_profile.email_address'),
                    value: profile.email!,
                  ),

                const SizedBox(height: 32),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditDriverProfileScreen()),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: Text(locale.translate('driver_profile.edit_profile'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String label, required String value}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.green, size: 32),
        title: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        subtitle: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
