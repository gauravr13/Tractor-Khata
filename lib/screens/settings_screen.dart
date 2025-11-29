import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../providers/auth_provider.dart';
import '../providers/driver_provider.dart';
// import '../providers/locale_provider.dart'; // Removed incorrect import
import '../providers/work_provider.dart'; // For Global Summary
import '../services/localization_service.dart';
import 'driver_profile_screen.dart';
import '../widgets/delete_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50], // Softer background
      appBar: AppBar(
        title: Text(locale.translate('settings.title')),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Driver Profile
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            color: Colors.white,
            child: Consumer<DriverProvider>(
              builder: (context, driverProvider, child) {
                final profile = driverProvider.profile;
                return ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green.shade50,
                    backgroundImage: profile.photoPath != null
                        ? (profile.photoPath!.startsWith('http')
                            ? NetworkImage(profile.photoPath!) as ImageProvider
                            : File(profile.photoPath!).existsSync() ? FileImage(File(profile.photoPath!)) : null)
                        : null,
                    child: profile.photoPath == null
                        ? const Icon(Icons.person_rounded, size: 30, color: Colors.green)
                        : null,
                  ),
                  title: Text(
                    profile.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    profile.phone ?? locale.translate('settings.driver_profile_subtitle'),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DriverProfileScreen()),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // 2. Language Selector
          Text(
            locale.translate('settings.language'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Consumer<LocaleProvider>(
              builder: (context, localeProvider, child) {
                return Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => localeProvider.setLocale(const Locale('hi')),
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: localeProvider.locale.languageCode == 'hi' ? Colors.green.shade50 : Colors.transparent,
                            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                            border: localeProvider.locale.languageCode == 'hi' 
                                ? Border.all(color: Colors.green.shade200) 
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              locale.translate('settings.hindi'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: localeProvider.locale.languageCode == 'hi' ? Colors.green.shade700 : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(width: 1, height: 40, color: Colors.grey.shade200),
                    Expanded(
                      child: InkWell(
                        onTap: () => localeProvider.setLocale(const Locale('en')),
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: localeProvider.locale.languageCode == 'en' ? Colors.green.shade50 : Colors.transparent,
                            borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
                            border: localeProvider.locale.languageCode == 'en' 
                                ? Border.all(color: Colors.green.shade200) 
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              locale.translate('settings.english'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: localeProvider.locale.languageCode == 'en' ? Colors.green.shade700 : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // 3. Global Summary
          Text(
            locale.translate('settings.global_summary'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Consumer<WorkProvider>(
                builder: (context, workProvider, child) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(locale.translate('settings.total_works'), style: TextStyle(fontSize: 15, color: Colors.grey[700])),
                          Text(
                            '${workProvider.totalWorkCountGlobal}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(locale.translate('settings.total_work_amount'), style: TextStyle(fontSize: 15, color: Colors.grey[700])),
                          Text(
                            '₹${workProvider.totalEarnings.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(locale.translate('settings.total_received'), style: TextStyle(fontSize: 15, color: Colors.grey[700])),
                          Text(
                            '₹${workProvider.totalReceived.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(locale.translate('settings.total_pending'), style: TextStyle(fontSize: 15, color: Colors.grey[700])),
                          Text(
                            '₹${workProvider.totalPending.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 4. Rate Card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            color: Colors.white,
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.list_alt_rounded, color: Colors.blue),
              ),
              title: Text(locale.translate('settings.manage_rate_card'), style: const TextStyle(fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
              onTap: () => Navigator.pushNamed(context, '/rate_card'),
            ),
          ),
          const SizedBox(height: 24),

          // 5. About Section (Clean, No Icon)
          Center(
            child: Column(
              children: [
                Text(
                  locale.translate('settings.version'),
                  style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    children: [
                      TextSpan(text: locale.translate('settings.made_by')),
                      const TextSpan(
                        text: ' Gaurav Raikwar',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'gauravraikwarji@gmail.com',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // 6. Logout (Minimal)
          Center(
            child: TextButton.icon(
              onPressed: () async {
                final confirm = await showDeleteDialog(
                  context,
                  title: locale.translate('settings.logout_confirm_title'),
                  content: locale.translate('settings.logout_confirm_message'),
                  isLogout: true,
                );

                if (confirm == true) {
                  await authProvider.signOut();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  }
                }
              },
              icon: Icon(Icons.logout_rounded, size: 18, color: Colors.red.shade400),
              label: Text(
                locale.translate('settings.logout'),
                style: TextStyle(color: Colors.red.shade400, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                backgroundColor: Colors.red.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
